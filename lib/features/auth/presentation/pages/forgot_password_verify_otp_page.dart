import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ForgotPasswordVerifyOtpPage extends ConsumerStatefulWidget {
  const ForgotPasswordVerifyOtpPage({
    required this.email,
    super.key,
  });

  final String email;

  @override
  ConsumerState<ForgotPasswordVerifyOtpPage> createState() =>
      _ForgotPasswordVerifyOtpPageState();
}

class _ForgotPasswordVerifyOtpPageState
    extends ConsumerState<ForgotPasswordVerifyOtpPage> {
  String _otpCode = '';
  bool _isLoading = false;
  bool _isResending = false;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startCooldown(60);
  }

  void _startCooldown(int seconds) {
    if (!mounted) return;
    setState(() => _remainingSeconds = seconds);
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || _remainingSeconds <= 0) return false;
      setState(() => _remainingSeconds -= 1);
      return _remainingSeconds > 0;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6 || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      final resetToken = await ref
          .read(authRepositoryProvider)
          .verifyPasswordResetOtp(email: widget.email, otp: _otpCode);
      if (!mounted) return;
      context.push(
        '/forgot-password/reset?email=${widget.email}&reset_token=$resetToken',
      );
    } on ApiException catch (e) {
      if (mounted) _showSnack(e.message);
    } catch (_) {
      if (mounted) _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (_remainingSeconds > 0 || _isResending) return;
    setState(() => _isResending = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .requestPasswordResetOtp(email: widget.email);
      if (mounted) {
        HapticFeedback.lightImpact();
        _startCooldown(60);
      }
    } on ApiException catch (e) {
      if (mounted) _showSnack(e.message);
    } catch (_) {
      if (mounted) _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(LucideIcons.shieldCheck, size: 48).animate().fadeIn().scale(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Verify Code',
                    style: AppTypography.h2(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Enter the 6-digit code sent to ${widget.email}',
                    style: AppTypography.body(color: colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: AppSpacing.xl2),
                  OtpCodeField(
                    length: 6,
                    onCodeChanged: (code) => setState(() => _otpCode = code),
                    onCodeSubmitted: (_) => _verifyOtp(),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'Verify',
                    isLoading: _isLoading,
                    onPressed: _otpCode.length == 6 ? _verifyOtp : null,
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: TextButton(
                      onPressed: _remainingSeconds == 0 && !_isResending ? _resendCode : null,
                      child: Text(
                        _remainingSeconds == 0
                            ? 'Resend code'
                            : 'Resend in ${_remainingSeconds}s',
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
