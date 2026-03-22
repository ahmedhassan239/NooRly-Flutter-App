import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _success = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Please enter your email.');
      return;
    }

    setState(() {
      _isLoading = true;
      _success = false;
    });

    try {
      await ref.read(authRepositoryProvider).forgotPassword(email: email);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _success = true;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final message = e is RateLimitException
            ? 'Too many requests. Try again later.'
            : e.message;
        _showSnack(message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnack('Something went wrong. Please try again.');
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Forgot Password',
                    style: AppTypography.h1(color: colorScheme.onSurface),
                  ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Enter your email to receive a reset link',
                    style: AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.xl2),
                  if (_success) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.checkCircle, color: colorScheme.primary, size: 24),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Check your email',
                              style: AppTypography.body(color: colorScheme.onSurface),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ] else ...[
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        LucideIcons.mail,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: AppButton(
                        text: 'Send Reset Link',
                        isLoading: _isLoading,
                        onPressed: _sendResetLink,
                      ),
                    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Back to Login',
                        style: AppTypography.body(color: colorScheme.primary)
                            .copyWith(fontWeight: FontWeight.w600),
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
