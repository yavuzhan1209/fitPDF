// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FitPDF';

  @override
  String get tagline => 'Compress and Share';

  @override
  String get homeTitle => 'FitPDF';

  @override
  String get homeSubtitle => 'Compress and Share';

  @override
  String get uploadPdf => 'Upload PDF';

  @override
  String get tapToSelect => 'Tap to select a PDF file';

  @override
  String get readyToCompress => 'Ready to compress';

  @override
  String get tapToChange => 'Tap to change';

  @override
  String get compressionLevel => 'COMPRESSION LEVEL';

  @override
  String get compressPdf => 'Compress PDF';

  @override
  String get selectFirst => 'Select a PDF First';

  @override
  String get recent => 'RECENT';

  @override
  String get noRecentFiles => 'No recent files yet';

  @override
  String get levelSmart => 'Smart';

  @override
  String get levelMaximum => 'Maximum';

  @override
  String get levelSmartDesc => 'Smart compression\n~40-60% smaller';

  @override
  String get levelMaximumDesc => 'Aggressive archival\n~70-90% smaller';

  @override
  String get compressing => 'Compressing...';

  @override
  String get compressionDone => 'Compressed!';

  @override
  String get initializingMsg => 'Initializing...';

  @override
  String get readingMsg => 'Reading PDF structure...';

  @override
  String get analyzingMsg => 'Analyzing images...';

  @override
  String get resamplingMsg => 'Resampling images...';

  @override
  String get metadataMsg => 'Removing metadata...';

  @override
  String get optimizingMsg => 'Optimizing streams...';

  @override
  String get writingMsg => 'Writing output file...';

  @override
  String get doneMsg => 'Done! ✓';

  @override
  String get compression => 'Compression';

  @override
  String get smartReadingMsg => 'Reading PDF document...';

  @override
  String get smartCleaningMetadataMsg => 'Cleaning metadata...';

  @override
  String get smartAnalyzingImagesMsg => 'Analyzing images...';

  @override
  String smartCompressingMsg(int current, int total) {
    return 'Compressing page $current of $total...';
  }

  @override
  String get smartBuildingMsg => 'Building optimized PDF...';

  @override
  String get smartCompletedMsg => 'Done! ✓';

  @override
  String get maximumReadingMsg => 'Reading PDF document...';

  @override
  String get maximumAnalyzingImagesMsg =>
      'Analyzing images for archival compression...';

  @override
  String get maximumGrayscaleMsg =>
      'Converting images to grayscale (3x reduction)...';

  @override
  String get maximumResamplingMsg =>
      'Resampling to 72 DPI (screen standard)...';

  @override
  String get maximumCompressingJpegMsg =>
      'Applying aggressive JPEG compression (30-40%)...';

  @override
  String get maximumRemovingMetadataMsg => 'Removing all metadata...';

  @override
  String get maximumBuildingMsg => 'Building compressed PDF...';

  @override
  String get maximumCompletedMsg => 'Done! ✓';

  @override
  String get isolateInitializingMsg => 'Initializing compression worker...';

  @override
  String get isolateSpawningMsg => 'Starting background compression...';

  @override
  String get isolateCompressionStartedMsg => 'Compression in progress...';

  @override
  String get isolateCompressionFailedMsg =>
      'Compression failed: check file format';

  @override
  String get isolateIsolateErrorMsg => 'Worker process error';

  @override
  String get isolateCancelledMsg => 'Compression cancelled';

  @override
  String get isolateCompletedSuccessMsg =>
      'Compression completed successfully!';

  @override
  String get resultTitle => 'Compression Done!';

  @override
  String get original => 'Original';

  @override
  String get compressed => 'Compressed';

  @override
  String get saved => 'Saved';

  @override
  String get sizeComparison => 'SIZE COMPARISON';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String get shareCompressed => 'Share Compressed PDF';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get email => 'Email';

  @override
  String get files => 'Files';

  @override
  String get compressAnother => 'Compress Another PDF';

  @override
  String get shareText => 'Compressed with FitPDF';

  @override
  String get errorPickingFile => 'Error picking file';

  @override
  String get privacyNote => 'Your PDFs never leave your device.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';
}
