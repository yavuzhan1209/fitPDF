import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FitPDF'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Compress and Share'**
  String get tagline;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'FitPDF'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compress and Share'**
  String get homeSubtitle;

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get uploadPdf;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a PDF file'**
  String get tapToSelect;

  /// No description provided for @readyToCompress.
  ///
  /// In en, this message translates to:
  /// **'Ready to compress'**
  String get readyToCompress;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @compressionLevel.
  ///
  /// In en, this message translates to:
  /// **'COMPRESSION LEVEL'**
  String get compressionLevel;

  /// No description provided for @compressPdf.
  ///
  /// In en, this message translates to:
  /// **'Compress PDF'**
  String get compressPdf;

  /// No description provided for @selectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a PDF First'**
  String get selectFirst;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get recent;

  /// No description provided for @noRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'No recent files yet'**
  String get noRecentFiles;

  /// No description provided for @levelSmart.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get levelSmart;

  /// No description provided for @levelMaximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get levelMaximum;

  /// No description provided for @levelSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart compression\n~40-60% smaller'**
  String get levelSmartDesc;

  /// No description provided for @levelMaximumDesc.
  ///
  /// In en, this message translates to:
  /// **'Aggressive archival\n~70-90% smaller'**
  String get levelMaximumDesc;

  /// No description provided for @compressing.
  ///
  /// In en, this message translates to:
  /// **'Compressing...'**
  String get compressing;

  /// No description provided for @compressionDone.
  ///
  /// In en, this message translates to:
  /// **'Compressed!'**
  String get compressionDone;

  /// No description provided for @initializingMsg.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializingMsg;

  /// No description provided for @readingMsg.
  ///
  /// In en, this message translates to:
  /// **'Reading PDF structure...'**
  String get readingMsg;

  /// No description provided for @analyzingMsg.
  ///
  /// In en, this message translates to:
  /// **'Analyzing images...'**
  String get analyzingMsg;

  /// No description provided for @resamplingMsg.
  ///
  /// In en, this message translates to:
  /// **'Resampling images...'**
  String get resamplingMsg;

  /// No description provided for @metadataMsg.
  ///
  /// In en, this message translates to:
  /// **'Removing metadata...'**
  String get metadataMsg;

  /// No description provided for @optimizingMsg.
  ///
  /// In en, this message translates to:
  /// **'Optimizing streams...'**
  String get optimizingMsg;

  /// No description provided for @writingMsg.
  ///
  /// In en, this message translates to:
  /// **'Writing output file...'**
  String get writingMsg;

  /// No description provided for @doneMsg.
  ///
  /// In en, this message translates to:
  /// **'Done! ✓'**
  String get doneMsg;

  /// No description provided for @compression.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get compression;

  /// No description provided for @smartReadingMsg.
  ///
  /// In en, this message translates to:
  /// **'Reading PDF document...'**
  String get smartReadingMsg;

  /// No description provided for @smartCleaningMetadataMsg.
  ///
  /// In en, this message translates to:
  /// **'Cleaning metadata...'**
  String get smartCleaningMetadataMsg;

  /// No description provided for @smartAnalyzingImagesMsg.
  ///
  /// In en, this message translates to:
  /// **'Analyzing images...'**
  String get smartAnalyzingImagesMsg;

  /// No description provided for @smartCompressingMsg.
  ///
  /// In en, this message translates to:
  /// **'Compressing page {current} of {total}...'**
  String smartCompressingMsg(int current, int total);

  /// No description provided for @smartBuildingMsg.
  ///
  /// In en, this message translates to:
  /// **'Building optimized PDF...'**
  String get smartBuildingMsg;

  /// No description provided for @smartCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Done! ✓'**
  String get smartCompletedMsg;

  /// No description provided for @maximumReadingMsg.
  ///
  /// In en, this message translates to:
  /// **'Reading PDF document...'**
  String get maximumReadingMsg;

  /// No description provided for @maximumAnalyzingImagesMsg.
  ///
  /// In en, this message translates to:
  /// **'Analyzing images for archival compression...'**
  String get maximumAnalyzingImagesMsg;

  /// No description provided for @maximumGrayscaleMsg.
  ///
  /// In en, this message translates to:
  /// **'Converting images to grayscale (3x reduction)...'**
  String get maximumGrayscaleMsg;

  /// No description provided for @maximumResamplingMsg.
  ///
  /// In en, this message translates to:
  /// **'Resampling to 72 DPI (screen standard)...'**
  String get maximumResamplingMsg;

  /// No description provided for @maximumCompressingJpegMsg.
  ///
  /// In en, this message translates to:
  /// **'Applying aggressive JPEG compression (30-40%)...'**
  String get maximumCompressingJpegMsg;

  /// No description provided for @maximumRemovingMetadataMsg.
  ///
  /// In en, this message translates to:
  /// **'Removing all metadata...'**
  String get maximumRemovingMetadataMsg;

  /// No description provided for @maximumBuildingMsg.
  ///
  /// In en, this message translates to:
  /// **'Building compressed PDF...'**
  String get maximumBuildingMsg;

  /// No description provided for @maximumCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Done! ✓'**
  String get maximumCompletedMsg;

  /// No description provided for @isolateInitializingMsg.
  ///
  /// In en, this message translates to:
  /// **'Initializing compression worker...'**
  String get isolateInitializingMsg;

  /// No description provided for @isolateSpawningMsg.
  ///
  /// In en, this message translates to:
  /// **'Starting background compression...'**
  String get isolateSpawningMsg;

  /// No description provided for @isolateCompressionStartedMsg.
  ///
  /// In en, this message translates to:
  /// **'Compression in progress...'**
  String get isolateCompressionStartedMsg;

  /// No description provided for @isolateCompressionFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Compression failed: check file format'**
  String get isolateCompressionFailedMsg;

  /// No description provided for @isolateIsolateErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Worker process error'**
  String get isolateIsolateErrorMsg;

  /// No description provided for @isolateCancelledMsg.
  ///
  /// In en, this message translates to:
  /// **'Compression cancelled'**
  String get isolateCancelledMsg;

  /// No description provided for @isolateCompletedSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Compression completed successfully!'**
  String get isolateCompletedSuccessMsg;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Compression Done!'**
  String get resultTitle;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @compressed.
  ///
  /// In en, this message translates to:
  /// **'Compressed'**
  String get compressed;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @sizeComparison.
  ///
  /// In en, this message translates to:
  /// **'SIZE COMPARISON'**
  String get sizeComparison;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @shareCompressed.
  ///
  /// In en, this message translates to:
  /// **'Share Compressed PDF'**
  String get shareCompressed;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @compressAnother.
  ///
  /// In en, this message translates to:
  /// **'Compress Another PDF'**
  String get compressAnother;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Compressed with FitPDF'**
  String get shareText;

  /// No description provided for @errorPickingFile.
  ///
  /// In en, this message translates to:
  /// **'Error picking file'**
  String get errorPickingFile;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your PDFs never leave your device.'**
  String get privacyNote;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
