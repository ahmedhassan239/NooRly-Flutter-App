# iOS Build Instructions for NooRly-Flutter-App

## ⚠️ Important Notice

**iOS builds CANNOT be performed on Linux.** This project has been configured for iOS, but you need macOS with Xcode to build.

## What Has Been Done

✅ **iOS Configuration Updated:**
- App Display Name: **NooRly**
- Bundle Name: **NooRly-Flutter-App**
- iOS platform files are ready

✅ **Build Script Created:**
- `build_ios.sh` - Automated build script for macOS

## Building on macOS

### Option 1: Use the Build Script (Recommended)

```bash
cd /path/to/NooRly-Flutter-App
./build_ios.sh
```

This will create:
- **Simulator build**: `build/ios/iphonesimulator/Runner.app`
- **Device build**: `build/ios/iphoneos/Runner.app`
- **IPA file**: `build/ios/ipa/*.ipa`

### Option 2: Manual Build Commands

```bash
cd /path/to/NooRly-Flutter-App

# Build for iOS Simulator (testing)
flutter build ios --simulator --release

# Build for iOS Device (requires code signing)
flutter build ios --release

# Create IPA file (for TestFlight/App Store)
flutter build ipa --release
```

### Option 3: Build Using Xcode

```bash
# Open the project in Xcode
open ios/Runner.xcworkspace

# Then in Xcode:
# 1. Select your target device/simulator
# 2. Product > Build (⌘B)
# 3. Product > Archive (for distribution)
```

## Build Output Paths

After building on macOS, you'll find:

### For Testing (Simulator):
```
build/ios/iphonesimulator/Runner.app
```

### For Device Testing:
```
build/ios/iphoneos/Runner.app
```

### For Distribution (IPA):
```
build/ios/ipa/NooRly-Flutter-App.ipa
```

## Prerequisites for macOS Build

1. **macOS** (10.15 or later)
2. **Xcode** (latest version from Mac App Store)
3. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
4. **Flutter** installed and configured:
   ```bash
   flutter doctor
   ```
5. **Apple Developer Account** (for device testing and App Store)

## Code Signing Setup

Before building for a physical device, you need to:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Go to **Signing & Capabilities** tab
4. Select your **Team** (Apple Developer account)
5. Xcode will automatically manage provisioning profiles

## Testing Options

### On iOS Simulator:
```bash
flutter run -d ios
```

### On Physical Device:
1. Connect your iPhone/iPad via USB
2. Trust the computer on your device
3. Run: `flutter run -d <device-id>`
   - Find device ID: `flutter devices`

## Distribution

### TestFlight:
1. Build IPA: `flutter build ipa --release`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Product > Archive
4. Distribute App > App Store Connect

### App Store:
Same as TestFlight, but select "App Store" distribution method.

## Current Project Configuration

- **Project Name**: NooRly-Flutter-App
- **Display Name**: NooRly
- **Bundle Identifier**: com.omicron.app.flutterApp
- **iOS Minimum Version**: Check `ios/Podfile`

## Need Help?

- Flutter iOS Setup: https://docs.flutter.dev/deployment/ios
- Xcode Help: https://developer.apple.com/xcode/
- Apple Developer: https://developer.apple.com/programs/

## Alternative: Cloud CI/CD

If you don't have a Mac, consider:
- **Codemagic** (https://codemagic.io) - Free tier available
- **GitHub Actions** with macOS runner
- **Bitrise** (https://www.bitrise.io) - Free tier available
