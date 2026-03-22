import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlockBadgeIcon extends StatelessWidget {
  const FlockBadgeIcon({
    super.key,
    this.size = 64.0,
    this.glowSize = 80.0,
    this.useAnimation = true,
  });

  final double size;
  final double glowSize;
  final bool useAnimation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget content = Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect (radial gradient shadow)
        Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.2),
                colorScheme.primary.withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Circular container with logo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.18), // ~12px for 64px size
            child: SvgPicture.asset(
              'assets/brand/flock_logo.svg',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );

    if (useAnimation) {
      // We apply animations as children of the stack roughly match the original
      // But here we simplify: we just animate the whole stack or reconstruct the specific animations
      // to match exactly what WelcomePage had.
      // Re-implementing the specific stagger from WelcomePage:
      return Stack(
        alignment: Alignment.center,
        children: [
           // Glow
           Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.2),
                colorScheme.primary.withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            ),

        // Icon Circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.18),
            child: SvgPicture.asset(
              'assets/brand/flock_logo.svg',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            ),
        ],
      );
    }

    return content;
  }
}
