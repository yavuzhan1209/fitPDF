import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'strategies/light_strategy.dart';
import 'strategies/balanced_strategy.dart';
import 'strategies/maximum_strategy.dart';
import '../../../core/constants/app_constants.dart';

/// Sealed class hierarchy for type-safe isolate messaging.
sealed class IsolateMessage {
  const IsolateMessage();
}

/// Progress update from worker isolate to main thread.
class ProgressMessage extends IsolateMessage {
  final double percent;
  final String status;
  const ProgressMessage({required this.percent, required this.status});
}

/// Final compressed PDF bytes — sent once on success.
class ResultMessage extends IsolateMessage {
  final Uint8List bytes;
  const ResultMessage({required this.bytes});
}

/// Sent when compression fails — contains error description.
class ErrorMessage extends IsolateMessage {
  final String error;
  const ErrorMessage({required this.error});
}

/// Data payload transferred to the isolate worker.
/// Uses [TransferableTypedData] for zero-copy transfer of large PDF bytes.
class IsolatePayload {
  /// PDF bytes — zero-copy via TransferableTypedData
  final TransferableTypedData bytes;

  /// Which compression strategy to run
  final CompressionLevel level;

  /// Channel to send messages back to the main isolate
  final SendPort replyTo;

  IsolatePayload({
    required this.bytes,
    required this.level,
    required this.replyTo,
  });
}

/// High-performance PDF compressor running on a dedicated [Isolate].
///
/// Fixes applied:
/// - [Fix 2] Uncaught isolate errors are captured via [addErrorListener]
///   and forwarded as [ErrorMessage] — the stream never hangs indefinitely.
/// - [Fix 3] Calling [compressWithProgress] while a previous compression
///   is still running automatically cancels it first, preventing port leaks.
class IsolateCompressor {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  /// Error listener port — must be closed separately from the data port.
  ReceivePort? _errorPort;

  bool _cancelled = false;

  /// Returns true if a compression task is currently running.
  bool get isRunning => _isolate != null;

  /// Compresses [pdfBytes] using the given [level] strategy.
  ///
  /// Returns a [Stream] of [IsolateMessage]:
  /// - [ProgressMessage]  — periodic progress updates
  /// - [ResultMessage]    — final compressed bytes on success
  /// - [ErrorMessage]     — description if anything goes wrong
  ///
  /// FIX 3: If called while already running, the previous task is cancelled
  /// automatically before the new one starts. No manual [cancel] needed.
  Stream<IsolateMessage> compressWithProgress(
      Uint8List pdfBytes,
      CompressionLevel level,
      ) async* {
    // FIX 3: Cancel any in-flight compression before starting a new one.
    if (isRunning) {
      cancel();
      // Give the event loop one tick to process the kill signal.
      await Future.delayed(Duration.zero);
    }

    _cancelled = false;
    _receivePort = ReceivePort();

    // FIX 2: Dedicated port that captures uncaught isolate errors.
    // Without this, an exception inside the isolate silently drops the
    // SendPort and the stream would hang forever waiting for ResultMessage.
    _errorPort = ReceivePort();

    try {
      final transferableBytes = TransferableTypedData.fromList([pdfBytes]);

      final payload = IsolatePayload(
        bytes: transferableBytes,
        level: level,
        replyTo: _receivePort!.sendPort,
      );

      _isolate = await Isolate.spawn(
        _worker,
        payload,
        paused: false,
        // FIX 2: Route uncaught isolate errors to our dedicated port.
        onError: _errorPort!.sendPort,
        // Also catch isolate exit to detect unexpected termination.
        onExit: _receivePort!.sendPort,
      );

      // FIX 2: Listen on error port in parallel.
      // If an uncaught error arrives, convert it to ErrorMessage and close.
      _errorPort!.listen((error) {
        // error is a List: [errorString, stackTraceString]
        final msg = error is List ? error.first.toString() : error.toString();
        _receivePort!.sendPort.send(ErrorMessage(error: 'Isolate error: $msg'));
      });

      await for (final message in _receivePort!.cast<IsolateMessage?>()) {
        if (_cancelled) {
          _isolate?.kill(priority: Isolate.immediate);
          break;
        }

        // onExit sends null — treat as unexpected termination.
        if (message == null) {
          yield ErrorMessage(error: 'Isolate terminated unexpectedly');
          break;
        }

        yield message;

        if (message is ResultMessage || message is ErrorMessage) {
          break;
        }
      }
    } catch (e) {
      yield ErrorMessage(error: 'Isolate spawn failed: $e');
    } finally {
      _cleanup();
    }
  }

  /// Cancels any ongoing compression immediately.
  void cancel() {
    _cancelled = true;
    _isolate?.kill(priority: Isolate.immediate);
    _cleanup();
  }

  /// Releases all resources: ports and isolate reference.
  void _cleanup() {
    _errorPort?.close();   // FIX 2: close error port too
    _errorPort = null;
    _receivePort?.close();
    _receivePort = null;
    _isolate = null;
  }

  /// Static isolate entry point — must be static (or top-level) so Dart
  /// can copy it to the new isolate's memory space.
  static Future<void> _worker(IsolatePayload payload) async {
    try {
      // Materialise zero-copy bytes back into a usable Uint8List.
      final pdfBytes = payload.bytes.materialize().asUint8List();

      void onProgress(double progress, String status) {
        payload.replyTo.send(ProgressMessage(
          percent: progress,
          status: status,
        ));
      }

      Uint8List result;

      switch (payload.level) {
        case CompressionLevel.light:
          result = await LightStrategy(onProgress: onProgress).run(pdfBytes);
        case CompressionLevel.balanced:
          result = await BalancedStrategy(onProgress: onProgress).run(pdfBytes);
        case CompressionLevel.maximum:
          result = await MaximumStrategy(onProgress: onProgress).run(pdfBytes);
      }

      payload.replyTo.send(ResultMessage(bytes: result));
    } catch (e) {
      payload.replyTo.send(ErrorMessage(error: 'Compression failed: $e'));
    }
  }
}
