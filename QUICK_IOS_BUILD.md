# Quick iOS Build Guide for Testing

## 🚀 Fastest Way to Build iOS for Testing

### Option 1: Codemagic (Recommended - No Mac Needed!) ⭐

**Free tier available** - Build iOS apps in the cloud!

1. **Sign up**: Go to https://codemagic.io and sign up (free)
2. **Connect your repository**: 
   - GitHub/GitLab/Bitbucket
   - Select your `NooRly-Flutter-App` repository
3. **Configure**:
   - The `codemagic.yaml` file is already set up
   - Codemagic will detect it automatically
4. **Build**:
   - Click "Start new build"
   - Select "iOS Build Workflow"
   - Wait ~10-15 minutes
5. **Download**:
   - Get your `.ipa` file from the build artifacts
   - Install on your iPhone via TestFlight or direct install

**Build Output Path**: Download from Codemagic dashboard

---

### Option 2: Build on macOS (If You Have Access)

```bash
cd /home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App

# Quick build for simulator (fastest)
flutter build ios --simulator --release

# Output: build/ios/iphonesimulator/Runner.app
```

**Build Output Path**: 
```
/home/ahmed-hassan/Projects/Omicron/mobile_app/NooRly-Flutter-App/build/ios/iphonesimulator/Runner.app
```

For device testing:
```bash
flutter build ios --release
flutter build ipa --release
```

**Build Output Paths**:
- Device: `build/ios/iphoneos/Runner.app`
- IPA: `build/ios/ipa/*.ipa`

---

### Option 3: GitHub Actions (If Using GitHub)

1. Push your code to GitHub
2. GitHub Actions will automatically build (workflow file already created)
3. Download artifacts from Actions tab

**Build Output Path**: Download from GitHub Actions artifacts

---

## 📱 Testing the Build

### On iOS Simulator:
```bash
flutter run -d ios
```

### On Physical Device:
1. Install the `.ipa` file via:
   - **TestFlight** (recommended)
   - **Xcode** (connect device, drag & drop)
   - **Apple Configurator 2**

---

## ⚡ Quick Commands Reference

```bash
# Build for simulator (testing)
flutter build ios --simulator --release

# Build for device (requires code signing)
flutter build ios --release

# Create IPA file
flutter build ipa --release

# Run on connected device
flutter run -d ios

# List available devices
flutter devices
```

---

## 🔧 Code Signing Setup (Required for Device Testing)

1. Open Xcode: `open ios/Runner.xcworkspace`
2. Select **Runner** project → **Signing & Capabilities**
3. Select your **Team** (Apple Developer account)
4. Xcode will auto-generate provisioning profiles

---

## 📍 Expected Build Paths

After building, you'll find:

**Simulator Build:**
```
build/ios/iphonesimulator/Runner.app
```

**Device Build:**
```
build/ios/iphoneos/Runner.app
```

**IPA File (for distribution):**
```
build/ios/ipa/NooRly-Flutter-App.ipa
```

---

## 🆘 Troubleshooting

**"No iOS builds found"**
- You're on Linux - use Codemagic or macOS

**"Code signing required"**
- Open Xcode and configure signing
- Or use `--no-codesign` flag (simulator only)

**"Pod install failed"**
- Run: `cd ios && pod install --repo-update`

---

## 💡 Recommended: Use Codemagic

**Why Codemagic?**
- ✅ No Mac required
- ✅ Free tier (500 build minutes/month)
- ✅ Automatic builds
- ✅ TestFlight integration
- ✅ Easy artifact downloads

**Setup Time**: ~5 minutes
**Build Time**: ~10-15 minutes

Sign up now: https://codemagic.io
