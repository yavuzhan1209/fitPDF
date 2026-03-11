# FitPDF 🗜️
**Compress and Share** — A Cross-Platform Flutter PDF Compressor

## 📝 About FitPDF

FitPDF is a modern, user-friendly PDF compression application built with Flutter. It enables users to reduce PDF file sizes without significant quality loss, making it easier to share and store PDF documents. The app offers multiple compression levels, supports multiple languages (English and Turkish), and features a polished UI with glassmorphism design patterns and coral red branding.

**Current Status**: Beta Version
- ✅ Core compression UI implemented
- ✅ Multi-language support (English, Turkish)
- ✅ Android and iOS platform support
- 🚧 Actual PDF compression logic (see Production Upgrade section)


```
lib/
├── main.dart                          # App entry point + locale management
├── l10n.yaml                          # ARB configuration
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
    ├── home/                          # Select PDF + compression level picker
    ├── compress/                      # Progress indicator + compression logic
    └── result/                        # Compression stats + Share functionality

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
├── Runner/AppDelegate.swift           # Flutter v2 embedding
└── Podfile                            # platform :ios, '12.0'
```

## 📱 Supported Platforms

| Platform | Minimum Version | Status |
|:---:|:---:|:---:|
| Android | API 21 (Android 5.0) | ✅ Active |
| iOS | iOS 12.0 | ✅ Active |

## 🎨 Design System

- **Brand Color**: Coral Red (#FF6B6B)
- **UI Pattern**: Glassmorphism cards with modern gradient buttons
- **Font**: System default with custom text scales
- **Localization**: Full support for multi-language deployment
