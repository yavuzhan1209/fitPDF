import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'strategies/smart_strategy.dart';
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
class IsolateCompressor {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  ReceivePort? _errorPort;
  bool _cancelled = false;

  /// Returns true if a compression task is currently running.
  bool get isRunning => _isolate != null;

  /// Compresses [pdfBytes] using the given [level] strategy.
  /// Returns a [Stream] of [IsolateMessage].
  /// If called while already running, cancels previous task first.
  Stream<IsolateMessage> compressWithProgress(
      Uint8List pdfBytes,
      CompressionLevel level,
      ) async* {
    // Cancel any in-flight compression before starting a new one
    if (isRunning) {
      cancel();
      await Future.delayed(Duration.zero);
    }

    _cancelled = false;
    _receivePort = ReceivePort();

    // Dedicated port for uncaught isolate errors — prevents infinite hang
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
        onError: _errorPort!.sendPort,
        onExit: _receivePort!.sendPort,
      );

      // Forward uncaught isolate errors as ErrorMessage
      _errorPort!.listen((error) {
        final msg = error is List ? error.first.toString() : error.toString();
        _receivePort!.sendPort.send(ErrorMessage(error: 'Isolate error: $msg'));
      });

      await for (final message in _receivePort!.cast<IsolateMessage?>()) {
        if (_cancelled) {
          _isolate?.kill(priority: Isolate.immediate);
          break;
        }

        // onExit sends null — unexpected termination
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

  /// Cancels ongoing compression immediately.
  void cancel() {
    _cancelled = true;
    _isolate?.kill(priority: Isolate.immediate);
    _cleanup();
  }

  void _cleanup() {
    _errorPort?.close();
    _errorPort = null;
    _receivePort?.close();
    _receivePort = null;
    _isolate = null;
  }

  /// Static isolate entry point — must be static for Isolate.spawn.
  static Future<void> _worker(IsolatePayload payload) async {
    try {
      final pdfBytes = payload.bytes.materialize().asUint8List();

      void onProgress(double progress, String status) {
        payload.replyTo.send(ProgressMessage(
          percent: progress,
          status: status,
        ));
      }

      Uint8List result;

      switch (payload.level) {
        case CompressionLevel.smart:
          result = await SmartStrategy(onProgress: onProgress).run(pdfBytes);
        case CompressionLevel.maximum:
          result = await MaximumStrategy(onProgress: onProgress).run(pdfBytes);
      }

      payload.replyTo.send(ResultMessage(bytes: result));
    } catch (e) {
      payload.replyTo.send(ErrorMessage(error: 'Compression failed: $e'));
    }
  }
}