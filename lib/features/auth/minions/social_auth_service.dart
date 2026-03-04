import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Exceptions for social auth failures
class SocialAuthException implements Exception {
  final String message;
  final dynamic originalError;

  SocialAuthException(this.message, [this.originalError]);

  @override
  String toString() => 'SocialAuthException: $message ${originalError != null ? "($originalError)" : ""}';
}

/// Service to handle interaction with native Social SDKs.
class SocialAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in with Google and return the ID Token.
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // We need the idToken to verify on backend
      final idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw SocialAuthException('Failed to retrieve Google ID Token');
      }

      return idToken;
    } catch (e) {
      if (e is SocialAuthException) rethrow;
      throw SocialAuthException('Google sign in failed', e);
    }
  }

  /// Sign in with Apple and return the Identity Token.
  Future<String?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return credential.identityToken;
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
              return null;
          }
      }
      throw SocialAuthException('Apple sign in failed', e);
    }
  }

  /// Sign in with Facebook and return the Access Token.
  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.cancelled) {
        return null;
      }

      if (result.status == LoginStatus.failed) {
        throw SocialAuthException(result.message ?? 'Facebook login failed');
      }

      return result.accessToken?.token;
    } catch (e) {
      if (e is SocialAuthException) rethrow;
      throw SocialAuthException('Facebook sign in failed', e);
    }
  }

  /// Sign out from all providers.
  Future<void> signOut() async {
    try {
        await Future.wait([
            _googleSignIn.signOut(),
            FacebookAuth.instance.logOut(),
            // Apple doesn't have a specific sign out method
        ]);
    } catch (e) {
        // Ignore logout errors
        if (kDebugMode) print('Social logout error: $e');
    }
  }
}
