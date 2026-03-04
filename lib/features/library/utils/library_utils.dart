/// Library helpers: hex color parsing and icon mapping.
library;

import 'package:flutter/material.dart';

import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/features/duas/utils/category_icon_mapping.dart';

/// Parses "#RRGGBB" (or "#AARRGGBB") to [Color]. Returns [fallback] if invalid.
Color parseHexColor(String? hex, [Color? fallback]) {
  final c = AppColors.fromHex(hex);
  return c ?? fallback ?? const Color(0xFF8B5CF6);
}

/// Maps backend icon key to [IconData]. Safe fallback for unknown keys.
IconData iconKeyToIconData(String? key) => iconFromKey(key);
