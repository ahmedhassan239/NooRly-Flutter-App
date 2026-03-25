import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Global subtle Islamic pattern behind the whole app.
///
/// **Source artwork:** Illustrator export `web/Islamic Pattern Background.svg` →
/// `assets/images/islamic_pattern_background.svg` (background rect stripped so
/// [ColorScheme.surface] shows through).
///
/// Place as the [MaterialApp.builder] wrapper so it sits under the [Navigator].
/// Pair with [ThemeData.scaffoldBackgroundColor] `Colors.transparent` so each
/// screen’s [Scaffold] does not paint an opaque layer over this.
class AppPatternBackground extends StatelessWidget {
  const AppPatternBackground({
    required this.child,
    super.key,
  });

  static const String assetPath = 'assets/images/islamic_pattern_background.svg';

  final Widget? child;

  /// Invert light artwork so it reads softly on dark surfaces.
  static const ColorFilter _darkPatternFilter = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255,
    0, -1, 0, 0, 255,
    0, 0, -1, 0, 255,
    0, 0, 0, 1, 0,
  ]);

  /// Roughly 20% visual strength: present as texture, never competing with UI.
  static const double _patternOpacityLight = 0.02;
  static const double _patternOpacityDark = 0.03;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternOpacity =
        isDark ? _patternOpacityDark : _patternOpacityLight;

    final pattern = SvgPicture.asset(
      assetPath,
      fit: BoxFit.cover,
      allowDrawingOutsideViewBox: true,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: scheme.surface),
        Positioned.fill(
          child: Opacity(
            opacity: patternOpacity,
            child: isDark
                ? ColorFiltered(
                    colorFilter: _darkPatternFilter,
                    child: pattern,
                  )
                : pattern,
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
