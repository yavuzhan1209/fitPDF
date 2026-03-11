// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'FitPDF';

  @override
  String get tagline => 'Sıkıştır ve Paylaş';

  @override
  String get homeTitle => 'FitPDF';

  @override
  String get homeSubtitle => 'Sıkıştır ve Paylaş';

  @override
  String get uploadPdf => 'PDF Yükle';

  @override
  String get tapToSelect => 'PDF dosyası seçmek için dokun';

  @override
  String get readyToCompress => 'Sıkıştırmaya hazır';

  @override
  String get tapToChange => 'Değiştirmek için dokun';

  @override
  String get compressionLevel => 'SIKIŞTIRMA SEVİYESİ';

  @override
  String get compressPdf => 'PDF\'i Sıkıştır';

  @override
  String get selectFirst => 'Önce PDF Seçin';

  @override
  String get recent => 'SON İŞLEMLER';

  @override
  String get noRecentFiles => 'Henüz işlem yok';

  @override
  String get levelLight => 'Hafif';

  @override
  String get levelBalanced => 'Dengeli';

  @override
  String get levelMaximum => 'Maksimum';

  @override
  String get levelLightDesc => 'Kayıpsız optimizasyon\n~%5-15 küçük';

  @override
  String get levelBalancedDesc => 'Akıllı görsel sıkıştırma\n~%40-60 küçük';

  @override
  String get levelMaximumDesc => 'Agresif arşivleme\n~%70-90 küçük';

  @override
  String get compressing => 'Sıkıştırılıyor...';

  @override
  String get compressionDone => 'Tamamlandı!';

  @override
  String get initializingMsg => 'Hazırlanıyor...';

  @override
  String get readingMsg => 'PDF yapısı okunuyor...';

  @override
  String get analyzingMsg => 'Görseller analiz ediliyor...';

  @override
  String get resamplingMsg => 'Görseller yeniden örnekleniyor...';

  @override
  String get metadataMsg => 'Meta veriler kaldırılıyor...';

  @override
  String get optimizingMsg => 'Akışlar optimize ediliyor...';

  @override
  String get writingMsg => 'Çıktı dosyası yazılıyor...';

  @override
  String get doneMsg => 'Bitti! ✓';

  @override
  String get compression => 'Sıkıştırma';

  @override
  String get lightReadingMsg => 'PDF yapısı okunuyor...';

  @override
  String get lightCleaningMetadataMsg => 'Belge metaverisi temizleniyor...';

  @override
  String get lightCleaningInfoMsg => 'Bilgi sözlüğü temizleniyor...';

  @override
  String get lightRemovingEmptyMsg => 'Boş akışlar kaldırılıyor...';

  @override
  String get lightSubsettingFontsMsg => 'Fontlar alt kümeye ayrılıyor...';

  @override
  String get lightRemovingUnusedMsg =>
      'Kullanılmayan kaynaklar kaldırılıyor...';

  @override
  String get lightBuildingMsg => 'Optimize edilmiş PDF oluşturuluyor...';

  @override
  String get lightCompletedMsg => 'Bitti! ✓';

  @override
  String get balancedReadingMsg => 'PDF belgesi okunuyor...';

  @override
  String get balancedAnalyzingImagesMsg => 'Görseller analiz ediliyor...';

  @override
  String get balancedResamplingMsg =>
      'Görseller 144 DPI\'ye yeniden örnekleniyor...';

  @override
  String get balancedCompressingJpegMsg =>
      'JPEG\'e sıkıştırılıyor (kalite: %65)...';

  @override
  String get balancedOptimizingStreamMsg =>
      'Görsel akışları optimize ediliyor...';

  @override
  String get balancedCleaningMetadataMsg => 'Meta veriler temizleniyor...';

  @override
  String get balancedOptimizingFontsMsg => 'Fontlar optimize ediliyor...';

  @override
  String get balancedBuildingMsg => 'Optimize edilmiş PDF oluşturuluyor...';

  @override
  String get balancedCompletedMsg => 'Bitti! ✓';

  @override
  String get maximumReadingMsg => 'PDF belgesi okunuyor...';

  @override
  String get maximumAnalyzingImagesMsg =>
      'Arşivleme sıkıştırması için görseller analiz ediliyor...';

  @override
  String get maximumGrayscaleMsg =>
      'Görseller gri tona dönüştürülüyor (3x azalma)...';

  @override
  String get maximumResamplingMsg =>
      '72 DPI\'ye yeniden örnekleniyor (ekran standardı)...';

  @override
  String get maximumCompressingJpegMsg =>
      'Agresif JPEG sıkıştırması uygulanıyor (%30-40)...';

  @override
  String get maximumRemovingMetadataMsg => 'Tüm meta veriler kaldırılıyor...';

  @override
  String get maximumRemovingFontsMsg => 'Font verisi kaldırılıyor...';

  @override
  String get maximumBuildingMsg => 'Sıkıştırılmış PDF oluşturuluyor...';

  @override
  String get maximumCompletedMsg => 'Bitti! ✓';

  @override
  String get resultTitle => 'Sıkıştırma Tamamlandı!';

  @override
  String get original => 'Orijinal';

  @override
  String get compressed => 'Sıkıştırılmış';

  @override
  String get saved => 'Kazanılan';

  @override
  String get sizeComparison => 'BOYUT KARŞILAŞTIRMASI';

  @override
  String get before => 'Önce';

  @override
  String get after => 'Sonra';

  @override
  String get shareCompressed => 'Sıkıştırılmış PDF\'i Paylaş';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get email => 'E-posta';

  @override
  String get files => 'Dosyalar';

  @override
  String get compressAnother => 'Başka PDF Sıkıştır';

  @override
  String get shareText => 'FitPDF ile sıkıştırıldı';

  @override
  String get errorPickingFile => 'Dosya seçilirken hata oluştu';

  @override
  String get privacyNote => 'PDF\'leriniz hiçbir zaman cihazınızdan çıkmaz.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';
}
