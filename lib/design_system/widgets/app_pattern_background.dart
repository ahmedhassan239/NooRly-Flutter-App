import 'package:flutter/material.dart';

/// Global subtle Islamic pattern behind the whole app.
///
/// **Source artwork (update here, then copy into assets):**
/// `web/islamic-pattern.png` — bundled at runtime as [assetPath] for mobile + web.
///
/// Place as the [MaterialApp.builder] wrapper so it sits under the [Navigator].
/// Pair with [ThemeData.scaffoldBackgroundColor] `Colors.transparent` so each
/// screen’s [Scaffold] does not paint an opaque layer over this.
class AppPatternBackground extends StatelessWidget {
  const AppPatternBackground({
    required this.child,
    super.key,
  });

  static const String assetPath = 'assets/images/islamic-pattern.png';

  final Widget? child;

  /// Invert light artwork so it reads softly on dark surfaces.
  static const ColorFilter _darkPatternFilter = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255,
    0, -1, 0, 0, 255,
    0, 0, -1, 0, 255,
    0, 0, 0, 1, 0,
  ]);

  /// Tile opacity for the repeating pattern — keep low so cards/text stay dominant.
  /// Tuned slightly above the previous 0.065 / 0.085 for a bit more presence without noise.
  static const double _patternOpacityLight = 0.082;
  static const double _patternOpacityDark = 0.105;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternOpacity =
        isDark ? _patternOpacityDark : _patternOpacityLight;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: scheme.surface),
        Opacity(
          opacity: patternOpacity,
          child: isDark
              ? ColorFiltered(
                  colorFilter: _darkPatternFilter,
                  child: Image.asset(
                    assetPath,
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                    alignment: Alignment.topLeft,
                    filterQuality: FilterQuality.medium,
                    gaplessPlayback: true,
                  ),
                )
              : Image.asset(
                  assetPath,
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.none,
                  alignment: Alignment.topLeft,
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
