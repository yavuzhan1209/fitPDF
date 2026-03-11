# FitPDF 🗜️
**Sıkıştır ve Paylaş** — Flutter PDF Compressor

## 🚀 Kurulum ve Çalıştırma

```bash
# 1. Bağımlılıkları yükle
flutter pub get

# 2. Localizations oluştur (otomatik - generate: true ile)
flutter gen-l10n

# 3. Android'de çalıştır
flutter run

# 4. Release APK
flutter build apk --release
```

## 🌍 Dil Ekleme

Yeni bir dil eklemek için sadece 2 adım:

### Adım 1 — ARB dosyası oluştur
`lib/core/l10n/` klasörüne `app_de.arb` (Almanca için) ekle:
```json
{
  "@@locale": "de",
  "appName": "FitPDF",
  "tagline": "Komprimieren und teilen",
  ...
}
```

### Adım 2 — main.dart'a ekle
```dart
supportedLocales: const [
  Locale('en'),
  Locale('tr'),
  Locale('de'),  // ← bunu ekle
],
```

### Adım 3 — Dil seçicide göster
`home_screen.dart` → `_showLanguageSheet()` içine:
```dart
_langTile(context, '🇩🇪  Deutsch', const Locale('de')),
```

## 📁 Proje Yapısı

```
lib/
├── main.dart                          # App entry + locale yönetimi
├── l10n.yaml                          # ARB config
├── core/
│   ├── theme/app_theme.dart           # Coral Red brand colors
│   ├── constants/app_constants.dart   # CompressionLevel enum
│   ├── widgets/
│   │   ├── coral_button.dart          # Gradient CTA button
│   │   └── glass_card.dart            # Glassmorphism card
│   └── l10n/
│       ├── app_en.arb                 # 🇬🇧 English strings
│       └── app_tr.arb                 # 🇹🇷 Turkish strings
└── features/
    ├── home/                          # Select PDF + level picker
    ├── compress/                      # Progress + compress logic
    └── result/                        # Stats + Share

android/
├── app/build.gradle                   # compileSdk, minSdk 21
├── app/src/main/
│   ├── AndroidManifest.xml            # v2 embedding, FileProvider
│   ├── kotlin/.../MainActivity.kt     # FlutterActivity (v2)
│   └── res/
│       ├── xml/file_paths.xml
│       ├── values/styles.xml
│       └── drawable/launch_background.xml
└── settings.gradle                    # Flutter plugin loader

ios/
├── Runner/Info.plist                  # PDF document type, permissions
├── Runner/AppDelegate.swift           # Flutter v2
└── Podfile                            # platform :ios, '12.0'
```

## ⚡ Compression Levels

| Level    | Image Quality | Boyut Hedefi |
|----------|:---:|:---:|
| 🪶 Hafif    | 85% | ~%25 küçük |
| ⚡ Dengeli  | 60% | ~%55 küçük |
| 💎 Maksimum | 35% | ~%80 küçük |

## 🔧 Gerçek PDF Sıkıştırma (Production Upgrade)

`compress_screen.dart` → `_compress()` metodunu şu şekilde upgrade et:

```dart
// 1. PDF'i oku (pdf package ile parse et)
// 2. Her sayfadaki görselleri çıkar
// 3. image package ile kaliteyi düşür (imageQuality getter'ı kullan)
// 4. Görselleri geri göm ve yeni PDF yaz
```

## 📱 Desteklenen Platformlar

| Platform | Min Versiyon | Durum |
|:---:|:---:|:---:|
| Android | API 21 (Android 5.0) | ✅ |
| iOS | iOS 12.0 | ✅ |
