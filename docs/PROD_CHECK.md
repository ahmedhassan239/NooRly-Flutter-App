# Production Safety Check Guide

This document explains how to use the Production Safety Layer to ensure your app is using the correct API environment.

## Overview

The Production Safety Layer prevents the app from accidentally connecting to non-production APIs (e.g., localhost, staging) when running in **Production mode**. It includes:

1. **ProdSafetyGuard**: Validates that the environment matches the base URL.
2. **RequestIdInterceptor**: Tags all requests with a unique ID and logs them for debugging.
3. **DebugNetworkScreen**: A UI for inspecting network logs, environment configuration, and API health.

## How It Works

### Environment Detection

The app automatically sets the environment based on the build mode:

- **Debug Mode** → `AppEnvironment.dev` (uses `http://localhost:8000/api/v1`)
- **Profile/Release Mode** → `AppEnvironment.prod` (uses `https://admin.noorly.net/api/v1`)

You can manually override this in `main.dart` by calling:
```dart
ApiConfig.setEnvironment(AppEnvironment.staging);
```

### Safety Validation

Every `login` and `register` call checks:
```dart
if (environment == prod && baseUrl != "https://admin.noorly.net/api/v1") {
  throw ProdSafetyException("Action blocked...");
}
```

**Result**: If you're in Production mode but using a non-production URL, authentication will be blocked with a clear error message.

## Accessing the Debug Screen

To open the Debug Network Screen:

1. Navigate to `/auth/debug` (existing Debug Auth Screen).
2. Tap the **"Open Network Diagnostics / Prod Safety"** button.
3. Or directly navigate to `/auth/debug/network`.

## Debug Network Screen Features

### 1. Environment Info
- **Environment**: Current environment (dev, staging, prod).
- **Build Mode**: Debug, Profile, or Release.
- **Base URL**: The active API URL.

### 2. Actions
- **Ping Health**: Sends a GET request to `/health` to verify API connectivity.
- **Test Register**: Creates a test account with a random email to verify the full auth flow.

### 3. Network Logs
- Shows the last 50 network requests.
- Each log includes:
  - **Method** (GET, POST, etc.)
  - **URL** (full resolved URL)
  - **Status Code**
  - **Request ID**
  - **Environment**
  - **Request/Response Body** (first 200 chars)

Tap any log to view full details.

## Verifying Production Configuration

To confirm your app is using production APIs:

1. Build the app in release mode: `flutter build apk --release` (or `flutter build ios --release`).
2. Run the app on a physical device.
3. Open the Debug Network Screen.
4. Check the **Base URL**. It should be `https://admin.noorly.net/api/v1`.
5. Try to **Ping Health**. You should see a successful response.
6. Check the network logs. The **Environment** column should show `prod`.

## Troubleshooting

### "Action Blocked by ProdSafetyGuard"
**Cause**: You're in Production mode (`AppEnvironment.prod`) but the `baseUrl` is set to a non-production value (e.g., `localhost`).

**Solution**:
1. Check `main.dart` to see if `ApiConfig.setEnvironment` is being called.
2. Ensure you're building with the correct flavor or build mode.
3. Update `ApiConfig.baseUrl` logic if needed.

### Network Logs Not Appearing
**Cause**: The `RequestIdInterceptor` might not be registered or the `NetworkLogService` is not wired correctly.

**Solution**: Verify `ApiClient` includes `RequestIdInterceptor` in the interceptors list (see `lib/core/api/api_client.dart`).

## Security Notes

- The Debug Network Screen logs request/response bodies (limited to 200 chars).
- **DO NOT** deploy apps to production with sensitive data logging enabled.
- In production builds, consider hiding or removing access to `/auth/debug/network`.
