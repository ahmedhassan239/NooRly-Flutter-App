/// Prayer page header: location, date, current time, optional mute icon.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PrayerHeader extends StatelessWidget {
  const PrayerHeader({
    required this.locationLabel,
    required this.dateLabel,
    required this.currentTimeLabel,
    this.showMuteIcon = true,
    this.isMuted = false,
    this.onMuteTap,
    super.key,
  });

  final String locationLabel;
  final String dateLabel;
  final String currentTimeLabel;
  final bool showMuteIcon;
  final bool isMuted;
  final VoidCallback? onMuteTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        locationLabel,
                        style: AppTypography.bodySm(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  dateLabel,
                  style: AppTypography.h1(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.prayerSchedule,
                  style: AppTypography.bodySm(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showMuteIcon)
                IconButton(
                  onPressed: onMuteTap,
                  icon: Icon(
                    isMuted ? LucideIcons.bellOff : LucideIcons.bell,
                    color: isMuted
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
              if (showMuteIcon) const SizedBox(height: AppSpacing.sm),
              Text(
                currentTimeLabel,
                style: AppTypography.h1(color: colorScheme.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Format DateTime to "HH:mm" (24h) for display. Uses [locale] for script (e.g. Arabic digits when 'ar').
String formatTimeForDisplay(DateTime dateTime, [String? locale]) {
  final loc = locale ?? 'en';
  return DateFormat('HH:mm', loc).format(dateTime);
}

/// Format DateTime to short date (e.g. "Tue, Jan 13" or "الأحد، ١٥ مارس" for ar).
String formatDateForDisplay(DateTime date, [String? locale]) {
  final loc = locale ?? 'en';
  return DateFormat('EEE, MMM d', loc).format(date);
}
