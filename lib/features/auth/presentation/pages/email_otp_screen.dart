import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/auth/providers/email_otp_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';

class EmailOtpScreen extends ConsumerStatefulWidget {
  const EmailOtpScreen({
    required this.email,
    super.key,
  });

  final String email;

  @override
  ConsumerState<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends ConsumerState<EmailOtpScreen> with SingleTickerProviderStateMixin {
  String _otpCode = '';
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: 500.ms);
    
    // Check cooldown on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emailOtpProvider.notifier).checkCooldown(widget.email);
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_otpCode.length == 6) {
      ref.read(emailOtpProvider.notifier).verifyOtp(widget.email, _otpCode);
    }
  }

  void _handleResend() {
    ref.read(emailOtpProvider.notifier).sendOtp(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(emailOtpProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Side effect: Shake on error
    ref.listen(emailOtpProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        _shakeController.forward(from: 0);
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: colorScheme.error),
        );
      }
      
      if (next.isVerified && !previous!.isVerified) {
         // Token was stored by verifyEmailOtp; refresh auth state then go to home (redirect will send to onboarding if needed)
         ref.read(authProvider.notifier).initialize().then((_) {
           if (context.mounted) context.go('/home');
         });
      }
    });

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
                  const Icon(LucideIcons.mailCheck, size: 48).animate().fadeIn().scale(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text(
                    l10n.otpTitle,
                    style: AppTypography.h2(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms).moveY(begin: 10, end: 0),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  Text(
                    l10n.otpSubtitle(widget.email),
                    style: AppTypography.body(color: colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),
                  
                  const SizedBox(height: AppSpacing.xl2),
                  
                  // OTP Field with Shake Animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: OtpCodeField(
                      length: 6,
                      onCodeChanged: (code) => setState(() => _otpCode = code),
                      onCodeSubmitted: (_) => _handleVerify(),
                    )
                    .animate(controller: _shakeController, autoPlay: false)
                    .shake(hz: 4, curve: Curves.easeInOutCubic),
                  ).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  AppButton(
                    text: l10n.otpVerifyButton,
                    onPressed: _otpCode.length == 6 ? _handleVerify : null,
                    isLoading: state.isLoading,
                  ).animate().fadeIn(delay: 400.ms),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Resend Code
                  Center(
                    child: TextButton(
                      onPressed: state.canResend && !state.isLoading 
                          ? _handleResend 
                          : null,
                      child: Text(
                        state.canResend 
                            ? l10n.otpResend 
                            : l10n.otpResendIn(state.remainingSeconds),
                        style: AppTypography.body(
                          color: state.canResend 
                              ? colorScheme.primary 
                              : colorScheme.onSurface.withOpacity(0.5),
                        ),
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
