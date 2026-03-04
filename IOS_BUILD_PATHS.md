# iOS Build Paths for NooRly-Flutter-App

## 📍 Project Location
```
/home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App
```

## 🎯 Build Output Paths (After Building)

### Option 1: Codemagic Cloud Build (Recommended)
**No Mac Required!**

After building on Codemagic, download from:
- **Codemagic Dashboard** → Build Artifacts → Download `.ipa` file
- **Path on Codemagic**: `build/ios/ipa/*.ipa`

**Setup**: 
1. Go to https://codemagic.io
2. Connect your repository
3. The `codemagic.yaml` file is already configured
4. Start build → Download IPA

---

### Option 2: macOS Build

#### Simulator Build (for testing):
```
/home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App/build/ios/iphonesimulator/Runner.app
```

#### Device Build (for physical device):
```
/home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App/build/ios/iphoneos/Runner.app
```

#### IPA File (for TestFlight/App Store):
```
/home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App/build/ios/ipa/*.ipa
```

---

### Option 3: GitHub Actions Build

After pushing to GitHub and workflow runs:
- **GitHub Repository** → Actions tab → Latest workflow run → Artifacts
- Download: `ios-ipa` and `ios-simulator` artifacts

---

## 🚀 Quick Start Commands

### On macOS:
```bash
cd /home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App

# Build for simulator (fastest)
flutter build ios --simulator --release

# Build for device
flutter build ios --release

# Create IPA
flutter build ipa --release
```

### Using Build Script:
```bash
cd /home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App
./build_ios.sh
```

---

## 📱 Testing the Build

### Install on Simulator:
```bash
flutter run -d ios
```

### Install on Device:
1. **Via Xcode**: Open `ios/Runner.xcworkspace` → Connect device → Run
2. **Via IPA**: Use TestFlight or Apple Configurator 2
3. **Via Codemagic**: Download IPA → Install via TestFlight

---

## ✅ What's Already Configured

- ✅ iOS project files (`ios/` directory)
- ✅ App name: **NooRly**
- ✅ Bundle name: **NooRly-Flutter-App**
- ✅ Codemagic config (`codemagic.yaml`)
- ✅ GitHub Actions workflow (`.github/workflows/ios-build.yml`)
- ✅ Build script (`build_ios.sh`)
- ✅ Export options (`ios/ExportOptions.plist`)

---

## 🎯 Recommended: Use Codemagic

**Why?**
- ✅ No Mac needed
- ✅ Free tier (500 min/month)
- ✅ Automatic builds
- ✅ Easy downloads

**Steps:**
1. Sign up: https://codemagic.io
2. Connect repo
3. Start build
4. Download IPA

**Build Time**: ~10-15 minutes

---

## 📋 Files Created

1. `codemagic.yaml` - Cloud build configuration
2. `.github/workflows/ios-build.yml` - GitHub Actions workflow
3. `build_ios.sh` - macOS build script
4. `QUICK_IOS_BUILD.md` - Quick reference guide
5. `ios/ExportOptions.plist` - IPA export configuration

---

## 🔗 Useful Links

- Codemagic: https://codemagic.io
- Flutter iOS Docs: https://docs.flutter.dev/deployment/ios
- Apple Developer: https://developer.apple.com

---

**Next Step**: Choose your build method and follow the instructions above!
