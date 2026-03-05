import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';

/// Home screen layout constants (design: centered card column).
class HomeLayout {
  HomeLayout._();

  /// Max width of the content column (web/desktop). 1100–1200px per design.
  static const double maxContentWidth = 1100;

  /// Horizontal padding for the content column.
  static const double contentPaddingHorizontal = AppSpacing.lg;

  /// Vertical padding between sections.
  static const double sectionSpacing = AppSpacing.lg;

  /// Bottom padding for the scroll (above bottom nav).
  static const double scrollBottomPadding = AppSpacing.xl2;
}

/// Paints a subtle dotted background (very low opacity, not noisy).
class DottedBackgroundPainter extends CustomPainter {
  DottedBackgroundPainter({
    required this.dotColor,
    this.spacing = 24,
    this.dotRadius = 1.2,
  });

  final Color dotColor;
  final double spacing;
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Scaffold for Home: light dotted background + centered scrollable column.
class HomeScaffold extends StatelessWidget {
  const HomeScaffold({
    required this.child,
    super.key,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? colorScheme.surface;
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: DottedBackgroundPainter(
              dotColor: colorScheme.outline.withValues(alpha: 0.08),
              spacing: 24,
              dotRadius: 1.2,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(color: bg.withValues(alpha: 0.6)),
        ),
        child,
      ],
    );
  }
}

/// Centered content column with max width and consistent padding.
class HomeLayoutColumn extends StatelessWidget {
  const HomeLayoutColumn({
    required this.child,
    super.key,
    this.onRefresh,
  });

  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scrollView = SingleChildScrollView(
      physics: onRefresh != null
          ? const AlwaysScrollableScrollPhysics()
          : null,
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.contentPaddingHorizontal,
        AppSpacing.md,
        HomeLayout.contentPaddingHorizontal,
        HomeLayout.scrollBottomPadding,
      ),
      child: child,
    );

    final content = onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: scrollView,
          )
        : scrollView;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeLayout.maxContentWidth),
        child: content,
      ),
    );
  }
}
