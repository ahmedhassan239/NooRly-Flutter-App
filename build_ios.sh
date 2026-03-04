#!/bin/bash

# iOS Build Script for NooRly-Flutter-App
# This script must be run on macOS with Xcode installed

set -e

echo "🚀 Building iOS app for NooRly-Flutter-App..."
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: iOS builds can only be performed on macOS"
    echo "   Current OS: $OSTYPE"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    echo "   Please install Xcode from the Mac App Store"
    exit 1
fi

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter is not installed or not in PATH"
    exit 1
fi

echo "✅ Environment checks passed"
echo ""

# Get the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "📦 Building Flutter bundle..."
flutter build bundle

echo ""
echo "📱 Building iOS app..."
echo ""

# Build for iOS Simulator (for testing)
echo "Building for iOS Simulator..."
flutter build ios --simulator --release

SIMULATOR_BUILD_PATH="build/ios/iphonesimulator/Runner.app"
if [ -d "$SIMULATOR_BUILD_PATH" ]; then
    echo ""
    echo "✅ iOS Simulator build completed!"
    echo "📍 Simulator build path: $PROJECT_DIR/$SIMULATOR_BUILD_PATH"
fi

echo ""
echo "Building for iOS Device..."
flutter build ios --release

DEVICE_BUILD_PATH="build/ios/iphoneos/Runner.app"
if [ -d "$DEVICE_BUILD_PATH" ]; then
    echo ""
    echo "✅ iOS Device build completed!"
    echo "📍 Device build path: $PROJECT_DIR/$DEVICE_BUILD_PATH"
fi

echo ""
echo "📦 Creating IPA file..."
flutter build ipa --release

IPA_PATH="build/ios/ipa/*.ipa"
if ls $IPA_PATH 1> /dev/null 2>&1; then
    IPA_FILE=$(ls $IPA_PATH | head -1)
    echo ""
    echo "✅ IPA file created!"
    echo "📍 IPA path: $PROJECT_DIR/$IPA_FILE"
    echo ""
    echo "📋 Build Summary:"
    echo "   - Simulator build: $SIMULATOR_BUILD_PATH"
    echo "   - Device build: $DEVICE_BUILD_PATH"
    echo "   - IPA file: $IPA_FILE"
else
    echo ""
    echo "⚠️  IPA file not found. You may need to configure code signing in Xcode."
fi

echo ""
echo "✨ Build process completed!"
echo ""
echo "To install on a device:"
echo "   1. Open Xcode: open ios/Runner.xcworkspace"
echo "   2. Connect your iOS device"
echo "   3. Select your device in Xcode"
echo "   4. Click Run (▶️)"
echo ""
echo "To upload to TestFlight:"
echo "   1. Open Xcode: open ios/Runner.xcworkspace"
echo "   2. Product > Archive"
echo "   3. Distribute App > App Store Connect"
echo ""
