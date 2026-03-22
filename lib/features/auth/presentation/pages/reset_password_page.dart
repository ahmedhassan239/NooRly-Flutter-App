import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    super.key,
    this.initialEmail,
    this.initialToken,
  });

  final String? initialEmail;
  final String? initialToken;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  bool get _hasDeepLinkParams =>
      (widget.initialEmail?.trim().isNotEmpty ?? false) &&
      (widget.initialToken?.trim().isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (email.isEmpty) {
      _showSnack('Please enter your email.');
      return;
    }
    if (token.isEmpty) {
      _showSnack('Please enter the reset token from your email.');
      return;
    }
    if (password.length < 8) {
      _showSnack('Password must be at least 8 characters.');
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).resetPassword(
            email: email,
            token: token,
            password: password,
            passwordConfirmation: confirm,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password has been reset. You can log in now.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.go('/login');
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
                    'Reset Password',
                    style: AppTypography.h1(color: colorScheme.onSurface),
                  ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Enter your new password below',
                    style: AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.xl2),
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    readOnly: _hasDeepLinkParams,
                    prefixIcon: Icon(
                      LucideIcons.mail,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
                  if (!_hasDeepLinkParams) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: _tokenController,
                      hintText: 'Reset token (from email link)',
                      obscureText: true,
                      prefixIcon: Icon(
                        LucideIcons.key,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ).animate().fadeIn(delay: 350.ms).moveY(begin: 20, end: 0),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'New password',
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(
                      LucideIcons.lock,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _confirmController,
                    hintText: 'Confirm password',
                    obscureText: _obscureConfirm,
                    prefixIcon: Icon(
                      LucideIcons.lock,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ).animate().fadeIn(delay: 450.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AppButton(
                      text: 'Reset Password',
                      isLoading: _isLoading,
                      onPressed: _resetPassword,
                    ),
                  ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Back to Login',
                        style: AppTypography.body(color: colorScheme.primary)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ).animate().fadeIn(delay: 550.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
