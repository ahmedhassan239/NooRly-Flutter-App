import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

/// Asset path for mosque silhouette (Flutter asset under assets/, not web-only).
const String _kMosqueSvgAsset = 'assets/images/mosque_islam.svg';

/// App logo — same source as launcher icon / native splash (`assets/branding/app_icon.png`).
const String _kBrandingLogoAsset = 'assets/branding/app_icon.png';

/// Welcome/landing page. Full-screen Stack: gradient → mosque silhouette → overlay → content.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  static const Color _blueDark = Color(0xFF0D2137);
  static const Color _blueBottom = Color(0xFF1A2F47);
  static const Color _accentOrange = Color(0xFFF7943E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (auth.status == AuthStatus.initial || auth.status == AuthStatus.loading) {
      // Match native / web splash: warm off-white + centered logo (no generic spinner).
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Image.asset(
            _kBrandingLogoAsset,
            width: 168,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            semanticLabel: 'NooRly',
          ),
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
              // Layer 1: full-screen vertical gradient (dark blue top → lighter blue bottom)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_blueDark, _blueBottom],
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms),

              // Layer 2: mosque SVG — large centered hero silhouette behind entire content
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

              // Layer 3: subtle dark overlay for readability (black 0.12–0.25)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.18),
                ),
              ),

              // Layer 4: foreground content (headline + subtitle + buttons) centered, max width 480
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [WelcomePage._blueDark, WelcomePage._blueBottom],
          ),
        ),
        child: SafeArea(
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
                  TextButton(onPressed: onLogin, child: const Text('Sign in')),
                  TextButton(onPressed: onGuest, child: const Text('Continue as guest')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Loads mosque SVG from asset; on failure prints error and shows fallback dome shape.
class _MosqueSilhouetteLayer extends StatelessWidget {
  const _MosqueSilhouetteLayer({required this.assetPath});
  final String assetPath;

  /// Opacity for silhouette (0.25–0.45) so it's visible but not overpowering.
  static const double _silhouetteOpacity = 0.35;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            debugPrint('❌ [WelcomePage] Mosque SVG failed to load: ${snapshot.error}');
          }
          return const _FallbackDomeShape(opacity: _silhouetteOpacity);
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        return Opacity(
          opacity: _silhouetteOpacity,
          child: SvgPicture.string(
            snapshot.data!,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

/// Simple dome shape used when mosque SVG fails to load.
class _FallbackDomeShape extends StatelessWidget {
  const _FallbackDomeShape({required this.opacity});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return CustomPaint(
          size: Size(w, h),
          painter: _DomePainter(opacity: opacity),
        );
      },
    );
  }
}

class _DomePainter extends CustomPainter {
  _DomePainter({required this.opacity});
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
