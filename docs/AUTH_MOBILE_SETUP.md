# Mobile Authentication Setup Guide

This guide details the required platform-specific configuration for enabling Social Authentication (Google, Apple, Facebook) in the NooRly Flutter App.

## 1. Google Sign-In

### Firebase Setup
1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Create a project (or use existing) for NooRly.
3.  Add an **Android** app:
    - Package name: `com.omicron.noorly` (Verify in `android/app/build.gradle`).
    - Download `google-services.json` and place it in `android/app/`.
    - **Important**: Add your SHA-1 and SHA-256 fingerprints to the Firebase Android app settings.
        - Run `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android` to get debug keys.
        - For production, use your release keystore.
4.  Add an **iOS** app:
    - Bundle ID: `com.omicron.noorly` (Verify in `ios/Runner.xcodeproj`).
    - Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
    - **Important**: Open `ios/Runner.xcworkspace` in Xcode and drag the file into the `Runner` folder (ensure "Copy items if needed" is checked).

### Android Configuration
No additional code changes needed if `google-services.json` is present and the plugin is installed.

### iOS Configuration
1.  Open `ios/Runner/Info.plist`.
2.  Add a URL Scheme for Google Sign-In (reverse client ID):
    ```xml
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <!-- Copied from GoogleService-Info.plist REVERSED_CLIENT_ID -->
                <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
            </array>
        </dict>
    </array>
    ```

---

## 2. Sign In with Apple

### Apple Developer Account
1.  Go to [Apple Developer Console](https://developer.apple.com/account/).
2.  In **Certificates, Identifiers & Profiles**, select **Identifiers**.
3.  Select your App ID (`com.omicron.noorly`).
4.  Check the **Sign In with Apple** capability and save.
5.  If dealing with a backend (NooRly API), you may need to configure a **Service ID** and **Key** for server-side validation if web-login is needed, but for native iOS app to API, the `identityToken` is usually sufficient for verification.

### Xcode Configuration
1.  Open `ios/Runner.xcworkspace` in Xcode.
2.  Select the **Runner** target -> **Signing & Capabilities**.
3.  Click **+ Capability** and add **Sign In with Apple**.

### Android Configuration (Web Flow)
Since "Sign In with Apple" on Android uses a web flow:
1.  You need a Service ID in Apple Developer Console.
2.  Configure the redirect URL to your backend or a deep link.
3.  *Note: The `sign_in_with_apple` package handles the web flow on Android automatically if configured.*

---

## 3. Facebook Login

### Meta for Developers
1.  Go to [Meta Developers](https://developers.facebook.com/).
2.  Create an App (Type: Consumer or Business).
3.  In **Settings > Basic**, get your **App ID** and **Client Token**.
4.  Add **Android** platform:
    - Google Play Package Name: `com.omicron.noorly`
    - Class Name: `com.omicron.noorly.MainActivity`
    - Key Hashes: Generate using `keytool` (similar to Google SHA-1 but base64 encoded).
5.  Add **iOS** platform:
    - Bundle ID: `com.omicron.noorly`

### Android Configuration
1.  Open `android/app/src/main/res/values/strings.xml`.
2.  Add:
    ```xml
    <string name="facebook_app_id">YOUR_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbYOUR_APP_ID</string>
    <string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
    ```
3.  Open `android/app/src/main/AndroidManifest.xml`.
4.  Add queries and meta-data (check `flutter_facebook_auth` docs for latest manifest requirements).

### iOS Configuration
1.  Open `ios/Runner/Info.plist`.
2.  Add:
    ```xml
    <key>FacebookAppID</key>
    <string>YOUR_APP_ID</string>
    <key>FacebookClientToken</key>
    <string>YOUR_CLIENT_TOKEN</string>
    <key>FacebookDisplayName</key>
    <string>NooRly</string>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>fbapi</string>
        <string>fb-messenger-share-api</string>
    </array>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>fbYOUR_APP_ID</string>
            </array>
        </dict>
    </array>
    ```
