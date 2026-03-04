import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State for Email OTP flow.
@immutable
class EmailOtpState {
  const EmailOtpState({
    this.isLoading = false,
    this.isVerified = false,
    this.error,
    this.remainingSeconds = 0,
    this.canResend = true,
  });

  final bool isLoading;
  final bool isVerified;
  final String? error;
  final int remainingSeconds;
  final bool canResend;

  EmailOtpState copyWith({
    bool? isLoading,
    bool? isVerified,
    String? error,
    bool clearError = false,
    int? remainingSeconds,
    bool? canResend,
  }) {
    return EmailOtpState(
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      error: clearError ? null : (error ?? this.error),
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      canResend: canResend ?? this.canResend,
    );
  }
}

final emailOtpProvider = StateNotifierProvider.autoDispose<EmailOtpNotifier, EmailOtpState>((ref) {
  return EmailOtpNotifier(ref);
});

class EmailOtpNotifier extends StateNotifier<EmailOtpState> {
  EmailOtpNotifier(this._ref) : super(const EmailOtpState());

  final Ref _ref;
  Timer? _timer;
  
  AuthRepository get _authRepository => _ref.read(authRepositoryProvider);
  SharedPreferences get _prefs => _ref.read(sharedPreferencesProvider);

  static const String _cooldownKeyPrefix = 'otp_last_sent_at_';
  static const int _cooldownSeconds = 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> sendOtp(String email) async {
    // Prevent double submit if loading
    if (state.isLoading) return;
    
    // Check local cooldown first (in case we re-entered screen)
    // Actually we should have loaded cooldown on init or check it here.
    // If state.canResend is false, we shouldn't send, unless forcibly logic?
    if (!state.canResend) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authRepository.sendEmailOtp(email: email);
      
      await _setCooldown(email);
      state = state.copyWith(isLoading: false);
    } on ApiException catch (e) {
       // Handle 429 specifically
       if (e is RateLimitException && e.retryAfter != null) {
          await _setCooldown(email, customSeconds: e.retryAfter);
       }
       state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authRepository.verifyEmailOtp(email: email, otp: otp);
      
      // Success
      state = state.copyWith(isLoading: false, isVerified: true);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkCooldown(String email) async {
     final lastSentStr = _prefs.getString('$_cooldownKeyPrefix$email');
     if (lastSentStr == null) return;

     final lastSent = DateTime.tryParse(lastSentStr);
     if (lastSent == null) return;

     final diff = DateTime.now().difference(lastSent).inSeconds;
     final remaining = _cooldownSeconds - diff;

     if (remaining > 0) {
       _startTimer(remaining);
     } else {
       // Ensure state is correct if expired
       if (!state.canResend) {
          state = state.copyWith(remainingSeconds: 0, canResend: true);
       }
     }
  }

  Future<void> _setCooldown(String email, {int? customSeconds}) async {
    await _prefs.setString('$_cooldownKeyPrefix$email', DateTime.now().toIso8601String());
    _startTimer(customSeconds ?? _cooldownSeconds);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    state = state.copyWith(remainingSeconds: seconds, canResend: false);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(remainingSeconds: 0, canResend: true);
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }
}
