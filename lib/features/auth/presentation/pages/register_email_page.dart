import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/app_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/auth/providers/register_provider.dart';

class RegisterEmailPage extends ConsumerStatefulWidget {
  const RegisterEmailPage({super.key});

  @override
  ConsumerState<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends ConsumerState<RegisterEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedGender;
  DateTime? _birthDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final registerState = ref.watch(registerProvider);
    final isLoading = registerState is RegisterLoading;

    // Navigate to OTP when backend returns needs_email_verification; prevent back to register loop
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next is RegisterNeedsOtp) {
        final email = Uri.encodeComponent(next.email);
        context.go('/auth/verify-email?email=$email');
        ref.read(registerProvider.notifier).reset();
      }
      if (next is RegisterError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: colorScheme.error,
          ),
        );
      }
      if (next is RegisterSuccess) {
        context.go('/home');
      }
    });

    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: AppTypography.h1(color: colorScheme.onSurface),
                    ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: AppSpacing.xs),
                    
                    Text(
                      'Enter your details to register',
                      style: AppTypography.body(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),

                    const SizedBox(height: AppSpacing.xl2),

                    // Name
                    AppTextField(
                      controller: _nameController,
                      hintText: 'Full Name',
                      prefixIcon: Icon(LucideIcons.user, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),

                    const SizedBox(height: AppSpacing.md),

                    // Email
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(LucideIcons.mail, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 350.ms).moveY(begin: 20, end: 0),

                    const SizedBox(height: AppSpacing.md),

                    // Gender (optional)
                    _buildGenderSelector(colorScheme),
                    const SizedBox(height: AppSpacing.md),

                    // Birth date (optional)
                    _buildBirthDateField(context, colorScheme),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: AppSpacing.md),

                    // Confirm Password
                    AppTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icon(LucideIcons.lock, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? LucideIcons.eye : LucideIcons.eyeOff,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 450.ms).moveY(begin: 20, end: 0),

                    const SizedBox(height: AppSpacing.xl),

                    // Submit Button (disabled while loading to prevent double-tap)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: AppButton(
                        text: 'Register',
                        isLoading: isLoading,
                        onPressed: _handleRegister,
                      ),
                    ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(ColorScheme colorScheme) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Gender (optional)',
        hintText: 'Select',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          hint: Text(
            'Select gender',
            style: AppTypography.body(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
      ),
    ).animate().fadeIn(delay: 375.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildBirthDateField(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _birthDate ?? DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _birthDate = picked);
      },
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Birth date',
          hintText: 'YYYY-MM-DD',
          prefixIcon: Icon(
            LucideIcons.calendar,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        child: Text(
          _birthDate != null
              ? DateFormat('yyyy-MM-dd').format(_birthDate!)
              : 'Tap to select',
          style: AppTypography.body(
            color: _birthDate != null
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0);
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(registerProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            name: _nameController.text.trim(),
            gender: _selectedGender,
            birthDate: _birthDate,
          );
    }
  }
}
