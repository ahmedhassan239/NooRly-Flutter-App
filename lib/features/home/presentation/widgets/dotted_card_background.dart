import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show RadialGradient;
import 'package:flutter_app/design_system/radius.dart';

/// Paints a subtle dotted grid. Uses only the provided [size]; no infinity.
class DottedCardPatternPainter extends CustomPainter {
  DottedCardPatternPainter({
    required this.dotColor,
    this.spacing = 30,
    this.dotRadius = 1.2,
    this.vignetteOpacity = 0.02,
  });

  final Color dotColor;
  final double spacing;
  final double dotRadius;
  final double vignetteOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || !size.width.isFinite || !size.height.isFinite) return;
    final paint = Paint()..color = dotColor;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }

    if (vignetteOpacity > 0) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: vignetteOpacity),
        ],
      );
      canvas.drawRect(
        rect,
        Paint()
          ..shader = gradient.createShader(rect)
          ..blendMode = BlendMode.darken,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DottedCardPatternPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.vignetteOpacity != vignetteOpacity;
  }
}

/// Reusable card with optional dotted pattern. Stack size is driven by the
/// content (unpositioned child), so safe inside Column/ScrollView (no infinite height).
/// When [enablePattern] is false, renders plain card. Use for: Next Prayer,
/// Your Journey, Today's Focus (not Daily Inspiration).
class PatternedCard extends StatelessWidget {
  const PatternedCard({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.enablePattern = true,
    this.dotOpacity = 0.08,
    this.dotSpacing = 30,
    this.dotRadius = 1.2,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool enablePattern;
  final double dotOpacity;
  final double dotSpacing;
  final double dotRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? AppRadius.card;
    final baseColor = backgroundColor ??
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.85);
    final border = borderColor ?? colorScheme.outline.withValues(alpha: 0.12);

    final paddingResolved = padding ?? const EdgeInsets.all(20);

    if (kDebugMode) {
      debugPrint('[PatternedCard] build enablePattern=$enablePattern');
    }

    Widget content;
    if (enablePattern) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: Container(color: baseColor),
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: DottedCardPatternPainter(
                    dotColor: colorScheme.primary.withValues(alpha: dotOpacity),
                    spacing: dotSpacing,
                    dotRadius: dotRadius,
                    vignetteOpacity: 0.015,
                  ),
                ),
              ),
            ),
            Padding(
              padding: paddingResolved,
              child: child,
            ),
          ],
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          color: baseColor,
          padding: paddingResolved,
          child: child,
        ),
      );
    }

    content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Used for the 3 Home section cards; delegates to [PatternedCard] with pattern on.
class DottedCard extends StatelessWidget {
  const DottedCard({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.dotOpacity = 0.08,
    this.dotSpacing = 30,
    this.dotRadius = 1.2,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final double dotOpacity;
  final double dotSpacing;
  final double dotRadius;

  @override
  Widget build(BuildContext context) {
    return PatternedCard(
      padding: padding,
      onTap: onTap,
      borderRadius: borderRadius,
      enablePattern: true,
      dotOpacity: dotOpacity,
      dotSpacing: dotSpacing,
      dotRadius: dotRadius,
      child: child,
    );
  }
}
