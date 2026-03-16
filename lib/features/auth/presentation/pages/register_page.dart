import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Listen for global auth state changes in case social login succeeds instantly
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
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Noorly',
                        style: AppTypography.h1(color: colorScheme.onSurface),
                      ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Create an account to save your progress',
                        style: AppTypography.body(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl2),

                  // Email Button
                  _SocialButton(
                    onPressed: () => _handleEmailLogin(context),
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onSurface,
                    icon: LucideIcons.mail,
                    label: 'Continue with Email',
                    hasBorder: true,
                  ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),

                  const Spacer(),

                  // Continue as Guest
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _handleGuestContinue(context, ref),
                      icon: Icon(
                        LucideIcons.user,
                        size: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      label: Text(
                        'Continue as Guest',
                        style: AppTypography.body(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleEmailLogin(BuildContext context) {
    context.go('/auth/register/email'); // keep nested route for register flow
  }

  void _handleGuestContinue(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).enterGuestMode();
    context.go('/onboarding/about-you');
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.assetPath,
    this.icon,
    required this.label,
    this.hasBorder = false,
    this.tintIcon = false,
  }) : assert(assetPath != null || icon != null, 'Either assetPath or icon must be provided');

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? assetPath;
  final IconData? icon;
  final String label;
  final bool hasBorder;
  final bool tintIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: hasBorder
              ? BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (assetPath != null)
              tintIcon
                  ? SvgPicture.asset(
                      assetPath!,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      assetPath!,
                      width: 24,
                      height: 24,
                    )
            else
              Icon(icon, size: 24, color: foregroundColor),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypography.body(color: foregroundColor).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
