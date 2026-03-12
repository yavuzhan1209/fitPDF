# 📋 FitPDF - Complete Project Documentation

## 🎯 Project Overview

**FitPDF** is a cross-platform Flutter application designed to compress PDF files efficiently while maintaining quality. It provides users with a modern, intuitive interface to reduce PDF file sizes for easier sharing and storage. The application is built with a focus on user experience, offering multiple compression strategies with real-time progress tracking.

**Current Status**: Beta Version
- ✅ Core compression UI implemented
- ✅ Multi-language support (English, Turkish)
- ✅ Android and iOS platform support
- ✅ Three compression strategies (Light, Balanced, Maximum)
- ✅ Real-time progress tracking and visual feedback

---

## 📱 Platform Support & Requirements

| Aspect | Details |
|:---:|:---|
| **Target Platforms** | Android (API 21+), iOS (12.0+) |
| **Flutter SDK** | ^3.3.0 |
| **Min Android SDK** | API 21 (Android 5.0) |
| **Min iOS Version** | iOS 12.0 |
| **Device Orientation** | Portrait only (portrait-up & portrait-down) |

---

## 🏗️ Project Architecture

### Directory Structure

```
fitpdf/
├── lib/
│   ├── main.dart                          # App entry point, locale management
│   ├── l10n.yaml                          # Localization configuration
│   │
│   ├── core/                              # Shared, reusable components
│   │   ├── constants/
│   │   │   └── app_constants.dart         # CompressionLevel enum, compression ratios
│   │   ├── theme/
│   │   │   └── app_theme.dart             # Coral Red branding, dark theme, typography
│   │   ├── widgets/
│   │   │   ├── coral_button.dart          # Gradient CTA button component
│   │   │   └── glass_card.dart            # Glassmorphism card component
│   │   └── l10n/
│   │       ├── app_en.arb                 # English localization strings
│   │       └── app_tr.arb                 # Turkish localization strings
│   │
│   ├── features/                          # Feature-specific modules
│   │   ├── home/                          # Home/Landing feature
│   │   │   ├── presentation/
│   │   │   │   ├── home_screen.dart       # Main home screen UI
│   │   │   │   └── widgets/
│   │   │   │       ├── compression_level_selector.dart  # Level picker UI
│   │   │   │       ├── logo_header.dart                 # App header with settings
│   │   │   │       └── recent_files_list.dart           # Recent PDFs display
│   │   │
│   │   ├── compress/                      # Compression execution feature
│   │   │   ├── domain/
│   │   │   │   ├── pdf_compressor.dart    # Main compressor orchestrator
│   │   │   │   ├── helpers/
│   │   │   │   │   ├── pdf_parser.dart    # PDF binary parser (zero-dependency)
│   │   │   │   │   └── jpeg_resampler.dart # Image resampling utilities
│   │   │   │   └── strategies/            # Three compression strategies
│   │   │   │       ├── light_strategy.dart     # Lossless structural optimization
│   │   │   │       ├── balanced_strategy.dart  # Image quality/size balance
│   │   │   │       └── maximum_strategy.dart   # Aggressive archival compression
│   │   │   └── presentation/
│   │   │       ├── compress_screen.dart   # Progress screen during compression
│   │   │       └── widgets/
│   │   │           └── squeeze_animation.dart  # Animated compression indicator
│   │   │
│   │   ├── preview/                       # PDF preview feature
│   │   │   └── presentation/
│   │   │       └── pdf_preview_screen.dart # View PDF before compression
│   │   │
│   │   └── result/                        # Compression results feature
│   │       └── presentation/
│   │           ├── result_screen.dart     # Results display & sharing
│   │           └── widgets/
│   │               ├── preview_comparison.dart  # Before/after comparison
│   │               ├── size_comparison_bar.dart # Visual size reduction bar
│   │               └── stat_card.dart           # Stat display cards
│   │
│   └── l10n/                              # Generated localization files
│       ├── app_localizations.dart         # Main localization provider
│       ├── app_localizations_en.dart      # English translations (generated)
│       └── app_localizations_tr.dart      # Turkish translations (generated)
│
├── android/                               # Android platform-specific code
│   ├── app/build.gradle                   # Android app configuration
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml            # Android manifest, permissions, FileProvider
│   │   ├── kotlin/.../MainActivity.kt     # Flutter Activity (v2 embedding)
│   │   └── res/                           # Resources (styles, layouts, drawables)
│   └── settings.gradle                    # Flutter plugin loader
│
├── ios/                                   # iOS platform-specific code
│   ├── Runner/
│   │   ├── AppDelegate.swift              # Flutter v2 embedding entry point
│   │   ├── Info.plist                     # iOS app configuration, permissions
│   │   ├── GeneratedPluginRegistrant.*    # Auto-generated plugin registration
│   │   └── Assets.xcassets/               # App assets and icons
│   ├── Podfile                            # iOS dependency management
│   └── Runner.xcworkspace/                # Xcode workspace
│
├── assets/                                # App assets
│   ├── animations/
│   │   └── compress.json                  # Lottie animation for compression
│   └── images/
│       └── icon.png                       # App icon
│
├── pubspec.yaml                           # Flutter project configuration & dependencies
└── l10n.yaml                              # Root localization configuration
```

---

## 🔧 Core Technologies & Dependencies

### Framework & Language
- **Flutter**: ^3.3.0 - Cross-platform UI framework
- **Dart**: 3.3.0+ - Primary programming language

### Key Dependencies

#### PDF Processing
- **`syncfusion_flutter_pdf: ^32.2.9`** - Professional PDF manipulation
  - PDF document reading/writing
  - Metadata extraction and modification
  - Stream compression options
  
- **`syncfusion_flutter_core: ^32.2.9`** - Syncfusion core utilities

- **`pdfx: ^2.8.0`** - PDF rendering and page rasterization
  - Used for maximum compression strategy page rendering
  - Low-level PDF manipulation

#### Image Processing
- **`image: ^4.1.7`** - Image manipulation library
  - Decode/encode JPEG, PNG, etc.
  - Grayscale conversion
  - Image resizing and resampling

#### File & System Access
- **`file_picker: ^8.1.2`** - File selection dialog
  - Platform-native file pickers for Android/iOS
  - Supports multiple selection modes

- **`path_provider: ^2.1.3`** - Platform-specific directory access
  - Application documents directory
  - Temporary storage

- **`path: ^1.9.0`** - Cross-platform path utilities
  - Path manipulation without platform checks

#### Sharing & Social
- **`share_plus: ^10.0.0`** - Cross-platform file sharing
  - Share via WhatsApp, Email, Files app
  - System share dialog

#### Localization
- **`intl: 0.20.2`** - Internationalization package
  - Multi-language support
  - Date/time formatting

- **`flutter_localizations`** - Flutter localization services
  - Material and Cupertino localizations

#### UI & Design
- **`google_fonts: ^6.2.1`** - Google Fonts integration
  - Custom typography
  - Used: Inter font family

- **`flutter_animate: ^4.5.0`** - Animation library
  - Implicit animations
  - Staggered animations
  - Chain animations

- **`percent_indicator: ^4.2.3`** - Progress indicators
  - Linear progress bars
  - Circular progress indicators

#### Development Tools
- **`flutter_launcher_icons: ^0.14.1`** - Icon generator
  - Auto-generates Android and iOS icons
  - Adaptive icon support

---

## 🎨 Design System & Branding

### Color Palette

| Color | Hex | Role | Usage |
|:---:|:---:|:---|:---|
| **Primary Coral** | `#EF5350` | Primary accent | Buttons, progress bar |
| **Coral Light** | `#FF6F61` | Lighter accent | Gradient start |
| **Coral Dark** | `#B71C1C` | Darker accent | Gradient end |
| **Background Primary** | `#121212` | Main background | Scaffold, surfaces |
| **Background Secondary** | `#1E1E1E` | Secondary background | Cards, dialogs |
| **Background Card** | `#1F1F1F` | Card background | Glass cards, inputs |
| **Text Primary** | `#FFFFFF` | Primary text | Headings, labels |
| **Text Secondary** | `#B0B0B0` | Secondary text | Body text |
| **Text Muted** | `#666666` | Muted text | Hints, captions |
| **Accent Green** | `#66BB6A` | Success/positive | Saved indicator |
| **Accent Blue** | `#42A5F5` | Info | Information elements |

### Design Patterns

1. **Glassmorphism**
   - Frosted glass effect on cards
   - Semi-transparent backgrounds
   - Blur and shadow effects for depth

2. **Gradient Buttons**
   - Coral gradient from light to dark
   - Used for primary CTAs
   - Smooth transitions

3. **Dark Theme**
   - OLED-friendly pure blacks
   - Reduced eye strain for mobile users
   - Premium feel

### Typography

- **Font Family**: Inter (Google Fonts)
- **Display Large**: 32px, 800 weight, -0.5 spacing
- **Display Medium**: 24px, 700 weight, -0.3 spacing
- **Title Large**: 20px, 600 weight
- **Title Medium**: 16px, 500 weight
- **Body Large**: 16px, color secondary
- **Body Medium**: 14px, color secondary
- **Label Large**: 16px, 600 weight

---

## 📊 Compression Strategies

### 1. 🪶 Light Strategy (Lossless Structural Optimization)

**Target**: 5-15% reduction | Quality: 100% preserved

**Mechanism**:
```
Input PDF → Read Structure → Clean Metadata → Remove Unused Objects 
→ Optimize Fonts → Build Output
```

**Operations**:
1. **Metadata Cleaning**
   - Removes document information fields: Author, Creator, Producer, Keywords, Subject, Title
   - Strips creation/modification dates
   - Clears all XMP metadata

2. **Unused Objects Removal**
   - Detects and removes unreferenced objects in PDF structure
   - Removes empty streams and hollow objects (`<<>>`)
   - Eliminates duplicate resources

3. **Font Optimization**
   - Removes FontDescriptor references where possible
   - Preserves font subsetting capabilities
   - Maintains text searchability (Ctrl+F)

4. **Result**:
   - File size: 5-15% smaller
   - Visual quality: Absolutely no change
   - Text: Fully searchable and selectable
   - Best for: Documents with embedded metadata/unused resources

**Code Location**: `lib/features/compress/domain/strategies/light_strategy.dart`

---

### 2. ⚡ Balanced Strategy (Standard Image Compression)

**Target**: 40-60% reduction | Quality: Imperceptible loss

**Mechanism**:
```
Input PDF → Read Structure → Clean Metadata → Analyze Images 
→ Resample to 144 DPI → Convert to JPEG (65% quality) 
→ Remove Empty Objects → Optimize Fonts → Build Output
```

**Operations**:
1. **Image Resampling**
   - Reduces image resolution from 300 DPI to 144 DPI
   - Maintains visual quality for screen and print
   - Resizes while preserving aspect ratio
   - Uses linear interpolation for smooth scaling

2. **JPEG Compression**
   - Converts all images to JPEG format
   - Sets quality factor to 65% (good balance)
   - Reduces color information efficiently
   - Handles PNG, JPEG2000, and other formats

3. **Metadata & Font Optimization**
   - Same as Light strategy
   - Additional stream compression

4. **Result**:
   - File size: 40-60% smaller
   - Visual quality: Imperceptible loss on screen/print
   - Text: Fully searchable
   - Best for: Sharing via email, cloud storage, messaging apps

**Code Location**: `lib/features/compress/domain/strategies/balanced_strategy.dart`

**Image Processing Details**:
- Decoding: Handles multiple image formats
- Resizing: DPI calculation: `new_width = (old_width × 144) / 300`
- Encoding: JPEG quality = 65
- Optimization: Only applies if compressed size < original

---

### 3. 💎 Maximum Strategy (Aggressive Archival)

**Target**: 70-90% reduction | Quality: Noticeable pixelation

**Mechanism**:
```
Input PDF → Clean Metadata → Extract Images → Grayscale Conversion 
→ Resample to 72 DPI → Compress to JPEG (35% quality) 
→ Rebuild PDF → Remove Empty Objects → Build Output
```

**Operations**:
1. **Grayscale Conversion**
   - Converts all color images to black & white
   - Reduces color information by ~3x
   - Maintains luminosity information
   - Suitable for document archival

2. **Aggressive Downsampling**
   - Reduces to 72 DPI (screen standard)
   - Calculation: `new_width = (old_width × 72) / 300`
   - Results in 4x to 6x size reduction per image

3. **Low-Quality JPEG**
   - JPEG quality set to 35%
   - Maximum compression at cost of quality
   - Visible pixelation and artifacts
   - Efficient for bandwidth-limited scenarios

4. **Complete Metadata Removal**
   - Removes all document information
   - Clears fonts and unused resources
   - Minimal overhead

5. **Result**:
   - File size: 70-90% smaller
   - Visual quality: Noticeably pixelated
   - Images: B&W with compression artifacts
   - Text: May become harder to read
   - Best for: Archival, fast sharing, bandwidth conservation

**Code Location**: `lib/features/compress/domain/strategies/maximum_strategy.dart`

---

## 🔍 PDF Processing Pipeline

### PDF Parser (`pdf_parser.dart`)

A **zero-dependency**, pure Dart PDF parser that handles binary PDF structure manipulation:

**Key Classes**:

#### `PdfParser`
Main class for reading and rebuilding PDFs

```dart
PdfParser(Uint8List original)
  - fullText          // Entire PDF as string
  - header            // PDF version header
  - objects           // List of PdfObject
  - build()           // Reconstructs PDF with modifications
```

**Methods**:
- `_extractHeader()`: Captures PDF version (e.g., `%PDF-1.4`)
- `_parseObjects()`: Uses regex to extract all objects from PDF
- `build()`: Rebuilds PDF with cross-reference table and trailer
- `_trailer()`: Reconstructs trailer with size updates

#### `PdfObject`
Represents individual PDF objects

**Properties**:
```dart
id              // Object ID (0-n)
generation      // Generation number (usually 0)
content         // Raw object content (string)
```

**Detection Methods**:
- `isMetadata`: Detects metadata objects
- `isImage`: Finds image objects (`/Subtype /Image`)
- `isJpegImage`: JPEG format (`/DCTDecode`)
- `isFlatImage`: PNG/ZIP format (`/FlateDecode`)
- `isJpx`: JPEG2000 format (`/JPXDecode`)
- `isCompressibleImage`: Any compressible image
- `isFont`: Font objects
- `hasEmptyStream`: Empty stream detection

**Manipulation Methods**:
- `extractStreamBytes()`: Extracts binary stream data
- `replaceStreamWithJpeg(List<int> jpegBytes)`: Replaces image stream
  - Updates filter from FlateDecode to DCTDecode
  - Removes DecodeParms
  - Updates stream length
  - Replaces binary content

**Code Location**: `lib/features/compress/domain/helpers/pdf_parser.dart`

---

### Image Resampling (`jpeg_resampler.dart`)

Utility class for intelligent image resizing

**Features**:
- DPI calculation for target resolutions
- Aspect ratio preservation
- Multiple interpolation methods (linear, cubic)
- Format detection and conversion

---

## 🎮 User Interface Flow

### Screen Navigation

```
HomeScreen (PDF Selection)
    ↓
    ├─→ CompressionLevelSelector
    ├─→ CoralButton (Compress) → CompressScreen
    └─→ PdfPreviewScreen
        
CompressScreen (Compression Progress)
    ↓ (On completion)
    ↓
ResultScreen (Results & Sharing)
    ├─→ Stat Cards (Before/After/Saved)
    ├─→ PreviewComparison
    ├─→ CoralButton (Share)
    └─→ ActionTiles (WhatsApp, Email, Files)
```

### 1. HomeScreen (`home_screen.dart`)

**Purpose**: PDF selection and compression level picker

**Key Features**:
- Upload zone (GestureDetector-based file picker)
- File info display (name, size)
- Compression level selector with emoji indicators
- Compression button with dynamic label
- Preview button (visible when file selected)
- Recent files list
- Language selector in header
- Privacy note at bottom

**State Variables**:
```dart
_filePath         // Selected PDF path
_fileName         // File display name
_fileSizeBytes    // Original file size
_level            // Selected CompressionLevel
_picking          // File picker loading state
```

**Key Methods**:
- `_pickFile()`: Opens file picker for PDF selection
- `_startCompress()`: Navigates to CompressScreen
- `_previewFile()`: Opens PDF preview
- `_fmtSize(int b)`: Formats bytes to KB/MB display

**Animations**:
- Fade-in on load
- Slide animations for upload zone
- Staggered animations for level selector and button

---

### 2. CompressScreen (`compress_screen.dart`)

**Purpose**: Real-time compression progress display

**Key Features**:
- Squeeze animation (PDF icon squeezing)
- Progress bar with gradient
- Progress percentage display
- Status message updates
- Level indicator badge
- Warning dialog for maximum compression

**State Variables**:
```dart
_progress         // 0.0 to 1.0 progress value
_status           // Current status message
_done             // Compression completion flag
```

**Key Methods**:
- `_run()`: Main compression orchestration
- `_compress()`: Executes strategy and saves result
- `_showMaximumWarning()`: Warns about quality loss
- `_updateProgress()`: Updates UI with compression progress

**Progress Flow**:
```
Compression initiated (10%)
  → Strategy starts → Progress callbacks → 100%
  → Navigates to ResultScreen
```

---

### 3. ResultScreen (`result_screen.dart`)

**Purpose**: Display compression results and sharing options

**Key Features**:
- Success checkmark animation
- Stat cards (Original, Compressed, Saved %)
- Size comparison bar (visual ratio)
- Before/After preview comparison
- Share button (system share)
- Quick action tiles (WhatsApp, Email, Files)
- "Compress Another" button

**Calculations**:
```dart
_savedPct = (1 - compressedSize / originalSize) × 100
```

**Key Methods**:
- `_fmt(int b)`: Format bytes
- `_share()`: Share via platform share dialog
- Animated stat cards and comparisons

---

## 🌍 Localization System

### Supported Languages
- 🇬🇧 **English** (Default)
- 🇹🇷 **Turkish**

### Implementation

**Configuration** (`l10n.yaml`):
```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**File Structure**:
- `app_en.arb` - English translation strings (source)
- `app_tr.arb` - Turkish translation strings
- `app_localizations.dart` - Generated provider (auto-generated)
- `app_localizations_en.dart` - Generated English class
- `app_localizations_tr.dart` - Generated Turkish class

### Usage in Code

```dart
// Get localization instance
final l = AppLocalizations.of(context);

// Access translated strings
Text(l.compressPdf)      // "Compress PDF" / "PDF'i Sıkışt…"
Text(l.compressionLevel) // "Compression Level" / "Sıkıştırma Seviyesi"
```

### Language Switching

Implemented in main.dart with `FitPDFApp.setLocale()`:

```dart
FitPDFApp.setLocale(context, const Locale('tr')); // Switch to Turkish
```

---

## 🛠️ Core Components

### Widgets

#### `CoralButton` (`core/widgets/coral_button.dart`)
Primary call-to-action button

**Properties**:
- `label`: Button text
- `icon`: Optional icon
- `onTap`: Tap callback
- `isOutlined`: Outlined style option
- `loading`: Loading state indicator

**Styling**:
- Gradient background (coral theme)
- Smooth transitions
- Rounded corners (24px)
- Ripple effect on tap

#### `GlassCard` (`core/widgets/glass_card.dart`)
Glassmorphism card component

**Properties**:
- `child`: Card content
- `padding`: Inner padding
- `borderRadius`: Customize border radius

**Styling**:
- Frosted glass effect
- Semi-transparent background
- Blur effects
- Subtle shadows

#### `SqueezeAnimation` (`compress/presentation/widgets/squeeze_animation.dart`)
Animated PDF compression indicator

**Properties**:
- `isCompressing`: Animation state

**Animation**:
- Scales PDF icon continuously
- Visual feedback during compression
- Smooth easing curves

---

## 🔐 Security & Privacy

### File Handling
- Files stored in application documents directory
- No cloud uploads
- Local processing only
- Temporary files cleaned after compression

### Permissions (Android)
- `READ_EXTERNAL_STORAGE`: Read PDF files
- `WRITE_EXTERNAL_STORAGE`: Save compressed PDFs
- File scope storage for Android 12+

### Permissions (iOS)
- `NSLocalNetworkUsageDescription`: Local network (if needed)
- File access via `FileProvider`

### Privacy Note
App displays: "Your files are processed locally. Never uploaded to any server."

---

## 📦 Build Configuration

### Android (`android/app/build.gradle`)
```groovy
compileSdk 34
minSdk 21
targetSdk 34
```

### iOS (`ios/Podfile`)
```ruby
platform :ios, '12.0'
```

### App Icons
- **Configuration**: `flutter_launcher_icons` in pubspec.yaml
- **Icon Path**: `assets/images/icon.png`
- **Adaptive Icon**: Android adaptive icon support
- **Auto-generation**: Runs on `flutter pub get`

---

## 🚀 Building & Running

### Development
```bash
flutter pub get
flutter run
```

### Android Release
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS Release
```bash
flutter build ios --release
# Then archive via Xcode
```

### Localization Generation
```bash
flutter gen-l10n
```

---

## 🧠 Key Architectural Decisions

1. **Strategy Pattern for Compression**
   - Allows easy addition of new compression methods
   - Each strategy independent and testable
   - Runtime selection based on user preference

2. **Zero-Dependency PDF Parser**
   - No external PDF library required for parsing
   - Custom regex-based approach for performance
   - Minimal package dependencies

3. **Dark Theme Only**
   - OLED optimization
   - Reduced eye strain
   - Premium feel
   - Consistent branding

4. **Glassmorphism Design**
   - Modern aesthetic
   - Distinct from typical Material Design
   - Enhanced visual hierarchy

5. **Feature-Based Architecture**
   - Clear separation of concerns
   - Scalable for feature addition
   - Maintainable code organization

---

## 📈 Performance Considerations

### Compression Speed
- **Light**: 1-3 seconds (minimal processing)
- **Balanced**: 3-10 seconds (image processing)
- **Maximum**: 5-15 seconds (grayscale + aggressive compression)

### Memory Usage
- Entire PDF loaded into memory (Uint8List)
- Image decoding/encoding in-memory
- Suitable for PDFs up to ~100MB on modern devices

### UI Responsiveness
- Progress updates on main thread (setState)
- Compression runs on default thread (non-blocking)
- Future-based async/await pattern

---

## 🔄 Data Flow

### Compression Pipeline

```
User selects PDF
    ↓
Home Screen: Store file path & metadata
    ↓
User selects compression level
    ↓
User taps "Compress"
    ↓
Compress Screen: Show progress
    ↓
PdfCompressor: Route to selected strategy
    ↓
Strategy execution:
  1. Load PDF as Uint8List
  2. Parse PDF structure (PdfParser)
  3. Apply strategy operations
  4. Generate progress callbacks
  5. Rebuild PDF binary
    ↓
Save compressed file to Documents directory
    ↓
Result Screen: Display stats & sharing options
    ↓
User shares or compresses another
```

---

## 🧪 Testing Considerations

### Unit Test Areas
- Compression ratio calculations
- Image resampling math
- PDF object parsing
- Size formatting logic

### Integration Test Areas
- File picker selection
- Compression execution
- Navigation between screens
- Localization switching

### Manual Test Scenarios
- Various PDF sizes (1MB, 10MB, 50MB)
- Different image types (JPEG, PNG, JPEG2000)
- Text-heavy vs. image-heavy PDFs
- All three compression levels
- Language switching

---

## 📝 Constants & Enums

### `CompressionLevel` Enum

```dart
enum CompressionLevel {
  light,      // 🪶 5-15% reduction
  balanced,   // ⚡ 40-60% reduction
  maximum;    // 💎 70-90% reduction

  double get ratio
  int get imageQuality
  String get emoji
}
```

### Compression Ratios
- **Light**: 0.75 (75% of original)
- **Balanced**: 0.45 (45% of original)
- **Maximum**: 0.20 (20% of original)

### Image Quality
- **Light**: 85% (minimal loss)
- **Balanced**: 60% (balanced quality)
- **Maximum**: 35% (aggressive)

---

## 🎯 Future Enhancement Roadmap

### Planned Features
1. **Batch Compression**: Multiple PDFs at once
2. **Compression Presets**: Save custom settings
3. **Compression History**: Track previously compressed files
4. **PDF Merging**: Combine multiple PDFs
5. **Selective Compression**: Compress specific pages only
6. **Cloud Integration**: Optional cloud backup
7. **Advanced Settings**: Fine-tune compression parameters
8. **Statistics Dashboard**: Lifetime compression stats

### Performance Improvements
1. Implement stream-based PDF parsing for large files
2. Add multi-threading for image processing
3. Optimize memory usage for 100MB+ PDFs
4. Cache parsed PDF structures

### Platform Expansion
1. **Desktop**: Windows, macOS, Linux via Flutter
2. **Web**: Flutter Web version

---

## 📞 Technical Support & Debugging

### Common Issues & Solutions

#### Issue: Compression results in 0% reduction
- **Cause**: PDF structure already optimized or images are minimal
- **Solution**: Try different compression level or check PDF content

#### Issue: App crashes on large PDFs (>100MB)
- **Cause**: Memory limitations
- **Solution**: Reduce PDF size first, optimize on device with more RAM

#### Issue: Image quality unexpectedly poor
- **Cause**: Original images low quality or excessive JPEG re-encoding
- **Solution**: Use Light strategy to avoid image reprocessing

#### Issue: Text not searchable after compression
- **Cause**: Maximum strategy may affect OCR or text layers
- **Solution**: Use Light or Balanced for searchable PDFs

---

## 📄 License & Contribution

**Status**: Beta Open Source Project

For contribution guidelines and license information, refer to project repository documentation.

---

## 👨‍💻 Developer Quick Start

### Prerequisites
- Flutter SDK 3.3.0+
- Xcode 14+ (for iOS)
- Android Studio with NDK (for Android)
- Git

### Setup Steps
```bash
# Clone repository
git clone [repository-url]

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on device/emulator
flutter run

# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

### Code Structure Quick Navigation
- **UI Logic**: `lib/features/*/presentation/`
- **Business Logic**: `lib/features/compress/domain/strategies/`
- **Shared Components**: `lib/core/`
- **Localization**: `lib/core/l10n/`
- **Styling**: `lib/core/theme/app_theme.dart`

---

## 📊 Project Statistics

| Metric | Value |
|:---|:---|
| **Total Screens** | 4 (Home, Compress, Result, Preview) |
| **Supported Languages** | 2 (English, Turkish) |
| **Compression Strategies** | 3 (Light, Balanced, Maximum) |
| **External Dependencies** | 13+ packages |
| **Minimum API Level** | Android 21 (API 5.0) |
| **Minimum iOS Version** | 12.0 |
| **Target Platforms** | Android, iOS |
| **Design System Colors** | 12 core colors |

---

## 📚 Additional Resources

### Flutter Documentation
- [Flutter Docs](https://docs.flutter.dev)
- [Dart Language Guide](https://dart.dev/guides)

### PDF Standards
- [PDF Reference 1.7](https://www.adobe.io/content/dam/udp/assets/open/pdf/specification/adobe_pdf_reference.pdf)

### Image Processing
- [Image Package Docs](https://pub.dev/packages/image)

### Localization
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

**Document Version**: 1.0 | **Last Updated**: 2026-03-12


