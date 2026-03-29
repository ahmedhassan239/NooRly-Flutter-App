import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_brand_logo.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

/// Asset path for mosque silhouette (Flutter asset under assets/, not web-only).
const String _kMosqueSvgAsset = 'assets/images/mosque_islam.svg';

/// Welcome/landing page. Uses an opaque brand backdrop so the global app pattern does not
/// show here; other routes still use the shared pattern from `MaterialApp.builder` unchanged.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  static const Color _blueDark = Color(0xFF0D2137);
  static const Color _blueBottom = Color(0xFF1A2F47);
  static const Color _accentOrange = Color(0xFFF7943E);

  static const double _readabilityOverlayAlpha = 0.18;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (auth.status == AuthStatus.initial || auth.status == AuthStatus.loading) {
      // Match native / web splash: warm surface + centered logo (opaque — hides global pattern).
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: AppBrandLogo(size: 168),
        ),
      );
    }

    // Startup error (e.g. network failure during auth init): show message + retry
    if (auth.errorMessage != null) {
      return _StartupErrorScreen(
        message: auth.errorMessage!,
        onRetry: () => ref.read(authProvider.notifier).initialize(),
        onGuest: () => context.go('/onboarding/about-you'),
        onLogin: () => context.go('/login'),
      );
    }

    return Scaffold(
      backgroundColor: _blueDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = MediaQuery.sizeOf(context);
          final screenWidth = size.width;
          // On screens > 1200px use 60% width; on small screens use 90% for full hero silhouette.
          final svgWidthPercent = screenWidth > 1200 ? 0.6 : 0.9;
          final svgWidth = screenWidth * svgWidthPercent;

          if (kDebugMode) {
            debugPrint('✅ [WelcomePage] Screen width: $screenWidth');
            debugPrint('✅ [WelcomePage] Final calculated SVG width: $svgWidth ($svgWidthPercent of screen)');
            debugPrint('✅ [WelcomePage] SVG alignment: center');
            debugPrint('✅ [WelcomePage] Overlay layer exists');
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              _WelcomeAtmosphere(
                svgWidth: svgWidth,
              ).animate().fadeIn(duration: 800.ms),

              // Foreground: headline + subtitle + buttons, max width 480
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTypography(context),
                            const SizedBox(height: 32),
                            _buildButtons(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTypography(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.displayLg(color: Colors.white)
                .copyWith(fontSize: 32, height: 1.3),
            children: [
              TextSpan(
                text: 'Assalamu Alaikum\n',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 24,
                ),
              ),
              const TextSpan(
                text: 'Welcome to ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const TextSpan(
                text: 'Noorly',
                style: TextStyle(
                  color: _accentOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .moveY(begin: 20, end: 0, duration: 600.ms),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Your companion in building a life of faith, step by step.',
          textAlign: TextAlign.center,
          style: AppTypography.body().copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .moveY(begin: 20, end: 0, duration: 600.ms),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    const radius = 18.0;
    const buttonHeight = 56.0;

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () => context.go('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Get Started', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 500.ms)
            .moveY(begin: 20, end: 0),

        const SizedBox(height: 18),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: () => context.go('/login'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: const Text(
                'I already have an account',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 500.ms)
            .moveY(begin: 20, end: 0),

        const SizedBox(height: 16),

        TextButton.icon(
          onPressed: () => context.go('/onboarding/about-you'),
          icon: Icon(
            LucideIcons.user,
            size: 18,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          label: Text(
            'Continue as Guest',
            style: AppTypography.body().copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: 500.ms)
            .moveY(begin: 20, end: 0),
      ],
    );
  }
}

/// Opaque brand gradient + mosque + darken layer (covers global pattern on this route only).
class _WelcomeAtmosphere extends StatelessWidget {
  const _WelcomeAtmosphere({required this.svgWidth});

  final double svgWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                WelcomePage._blueDark,
                WelcomePage._blueBottom,
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                _kMosqueSvgAsset,
                width: svgWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black
                .withValues(alpha: WelcomePage._readabilityOverlayAlpha),
          ),
        ),
      ],
    );
  }
}

/// Shown when auth initialization fails (e.g. network error). Offers retry and fallbacks.
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({
    required this.message,
    required this.onRetry,
    required this.onGuest,
    required this.onLogin,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onGuest;
  final VoidCallback onLogin;

  /// Whether the message describes a genuine network / connectivity problem.
  bool get _isConnectionError {
    final m = message.toLowerCase();
    return m.contains('connection') ||
        m.contains('network') ||
        m.contains('internet') ||
        m.contains('timed out') ||
        m.contains('timeout');
  }

  @override
  Widget build(BuildContext context) {
    final isConn = _isConnectionError;
    final heading = isConn ? 'Connection problem' : 'Something went wrong';
    final icon    = isConn ? LucideIcons.wifiOff  : LucideIcons.alertCircle;

    return Scaffold(
      backgroundColor: WelcomePage._blueDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final svgWidthPercent = screenWidth > 1200 ? 0.6 : 0.9;
          final svgWidth = screenWidth * svgWidthPercent;

          return Stack(
            fit: StackFit.expand,
            children: [
              _WelcomeAtmosphere(svgWidth: svgWidth),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 48,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          heading,
                          style: AppTypography.h1(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: AppTypography.body().copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onRetry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WelcomePage._accentOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Retry'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: onLogin,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: onGuest,
                          child: Text(
                            'Continue as guest',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
