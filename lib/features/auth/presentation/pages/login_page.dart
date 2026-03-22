import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/app_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    // Listen for errors or success validation
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: colorScheme.error),
        );
      }
      
      if (next.isAuthenticated) {
        context.go('/home');
      }
    });

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
                   // Back Button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      LucideIcons.arrowLeft,
                      color: colorScheme.onSurface,
                    ),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: AppSpacing.lg),
                  
                  // Title & Subtitle
                  Text(
                    'Welcome Back',
                    style: AppTypography.h1(color: colorScheme.onSurface),
                  ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: AppSpacing.xs),
                  
                  Text(
                    'Continue your journey',
                    style: AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: AppSpacing.xl2),

                  // Email
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(LucideIcons.mail, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: AppSpacing.md),

                  // Password
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(LucideIcons.lock, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 20,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ).animate().fadeIn(delay: 550.ms).moveY(begin: 20, end: 0),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.body(
                          color: colorScheme.primary,
                        ).copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AppButton(
                      text: 'Log In',
                      isLoading: isLoading,
                      onPressed: _handleLogin,
                    ),
                  ).animate().fadeIn(delay: 650.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: AppSpacing.xl),

                  // Sign Up Link
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/register'),
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.body(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    ref.read(authProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }
}
