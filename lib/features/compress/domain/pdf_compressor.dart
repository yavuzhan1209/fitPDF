import 'dart:typed_data';
import 'strategies/light_strategy.dart';
import 'strategies/balanced_strategy.dart';
import 'strategies/maximum_strategy.dart';

class PdfCompressor {
  static Future<Uint8List> compressLight(
      Uint8List input, {
        void Function(double, String)? onProgress,
      }) =>
      LightStrategy(onProgress: onProgress).run(input);

  static Future<Uint8List> compressBalanced(
      Uint8List input, {
        void Function(double, String)? onProgress,
      }) =>
      BalancedStrategy(onProgress: onProgress).run(input);

  static Future<Uint8List> compressMaximum(
      Uint8List input, {
        void Function(double, String)? onProgress,
      }) =>
      MaximumStrategy(onProgress: onProgress).run(input);
}