/// Register flow state and notifier.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

/// States for the register screen flow.
sealed class RegisterState {
  const RegisterState();
}

/// Initial state before submit.
class RegisterIdle extends RegisterState {
  const RegisterIdle();
}

/// Register request in progress.
class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

/// Register succeeded; user must verify email. Navigate to OTP screen.
class RegisterNeedsOtp extends RegisterState {
  const RegisterNeedsOtp(this.email);
  final String email;
}

/// Register returned token; user is authenticated.
class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.authResponse);
  final AuthResponse authResponse;
}

/// Register failed with message.
class RegisterError extends RegisterState {
  const RegisterError(this.message);
  final String message;
}

/// Register notifier: calls auth register and emits explicit states for UI (OTP navigation, errors).
final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref);
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(this._ref) : super(const RegisterIdle());

  final Ref _ref;

  /// Submit register. On [RegisterResultNeedsOtp] emits [RegisterNeedsOtp]; UI should navigate to OTP.
  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    String? gender,
    DateTime? birthDate,
  }) async {
    state = const RegisterLoading();

    try {
      final result = await _ref.read(authProvider.notifier).register(
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
            name: name,
            gender: gender,
            birthDate: birthDate,
          );

      if (result is RegisterResultNeedsOtp) {
        state = RegisterNeedsOtp(result.email);
        return;
      }
      if (result is RegisterResultAuthed) {
        state = RegisterSuccess(result.authResponse);
        return;
      }
      state = const RegisterError('Unexpected response.');
    } on ApiException catch (e) {
      state = RegisterError(e.message);
    } on Exception catch (e) {
      final message = e.toString();
      state = RegisterError(
        message.length > 200 ? '${message.substring(0, 200)}...' : message,
      );
    }
  }

  /// Reset to idle (e.g. after navigating away).
  void reset() {
    state = const RegisterIdle();
  }
}
