import 'package:flutter/material.dart';

/// Raster app mark — same file as launcher / native splash (`flutter_launcher_icons`).
/// Square canvas; wordmark may sit low in the art; use [AppBrandLogoCircular] for round masks.
const String kAppBrandLogoAsset = 'assets/branding/app_icon.png';

/// Full wordmark / logo without circular clipping (splash, wide headers).
///
/// Uses a square box so [BoxFit.contain] centers the artwork on both axes (avoids vertical drift).
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({
    super.key,
    this.size = 168,
  });

  /// Width and height of the layout box (asset scales inside with [BoxFit.contain]).
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        kAppBrandLogoAsset,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        semanticLabel: 'NooRly',
      ),
    );
  }
}

/// Profile / app-icon style: circular container with the brand PNG [BoxFit.contain] inside.
///
/// Uses generous inset so the wordmark is not clipped by the circle. If the PNG itself has
/// uneven transparent padding, nudge with [alignment] or fix the source asset.
class AppBrandLogoCircular extends StatelessWidget {
  const AppBrandLogoCircular({
    super.key,
    this.diameter = 120,
    this.insetFraction = 0.14,
    this.backgroundColor,
    this.alignment = Alignment.center,
  });

  final double diameter;

  /// Padding inside the circle as a fraction of [diameter] (larger = smaller logo, safer margins).
  final double insetFraction;

  final Color? backgroundColor;

  /// Fine-tune optical center if the artwork has asymmetric padding (e.g. `(0, -0.05)` shifts up).
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.9);
    final inset = (diameter * insetFraction).clamp(4.0, diameter * 0.45);
    return ClipOval(
      child: Material(
        color: bg,
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: Padding(
            padding: EdgeInsets.all(inset),
            child: Image.asset(
              kAppBrandLogoAsset,
              fit: BoxFit.contain,
              alignment: alignment,
              filterQuality: FilterQuality.high,
              semanticLabel: 'NooRly',
            ),
          ),
        ),
      ),
    );
  }
}
