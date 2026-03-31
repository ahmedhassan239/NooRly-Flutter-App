import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/journey/presentation/journey_mock_data.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Individual lesson item within a week card.
/// Entire card is tappable; [onTap] is called on tap (handle locked state in parent).
class LessonItem extends StatelessWidget {
  const LessonItem({
    required this.lesson,
    required this.onTap,
    super.key,
  });

  final LessonData lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isStart = lesson.status == LessonStatus.start;
    final isCompleted = lesson.status == LessonStatus.completed;
    final isLocked = lesson.isLocked;

    return Semantics(
      label: 'Open lesson ${lesson.title}',
      button: true,
      child: Material(
        color: isStart ? colorScheme.primary.withAlpha(13) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: isStart
                ? Border(
                    left: BorderSide(
                      color: colorScheme.primary,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Status icon
              _buildStatusIcon(isStart, isCompleted, isLocked, colorScheme),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day badge and category
                    Row(
                      children: [
                        if (isStart)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.journeyDayLabel(lesson.dayNumber),
                              style: AppTypography.caption(color: colorScheme.onPrimary)
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.journeyDayLabel(lesson.dayNumber),
                            style: AppTypography.caption(
                              color: isLocked
                                  ? colorScheme.onSurface.withValues(alpha: 0.7)
                                  : colorScheme.onSurface,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.tag,
                                size: 10,
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lesson.category == 'Lesson'
                                    ? AppLocalizations.of(context)!.journeyLessonLabel
                                    : lesson.category,
                                style: AppTypography.caption(
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isStart) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentCoral.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.zap,
                                  size: 10,
                                  color: AppColors.accentCoral,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.journeyStart,
                                  style: AppTypography.caption(
                                    color: AppColors.accentCoral,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      lesson.title,
                      style: AppTypography.body(
                        color: isLocked
                            ? colorScheme.onSurface.withValues(alpha: 0.7)
                            : colorScheme.onSurface,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                    // Unlock info or duration
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _clockRowText(context),
                            style: AppTypography.caption(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow for start/completed
              if (isStart || isCompleted)
                Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: isStart ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// Duration (unlocked) or lock hint (localized); uses [AppLocalizations] + [toLocaleDigits].
  String _clockRowText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    if (lesson.isLocked) {
      final kind = lesson.lockedSubtitle ?? JourneyLessonLockedSubtitle.completePrevious;
      switch (kind) {
        case JourneyLessonLockedSubtitle.completePrevious:
          return l10n.journeyLessonLockedHint;
        case JourneyLessonLockedSubtitle.unlocksTomorrow:
          return l10n.journeyUnlocksTomorrow;
        case JourneyLessonLockedSubtitle.unlocksInDays:
          final d = lesson.unlockInDays ?? 0;
          final safe = d < 0 ? 0 : d;
          return toLocaleDigits(l10n.journeyUnlocksInDays(safe), lang);
      }
    }
    final minutes = lesson.durationMinutes;
    if (minutes != null && minutes > 0) {
      return toLocaleDigits(l10n.journeyDurationMinRead(minutes), lang);
    }
    return '—';
  }

  Widget _buildStatusIcon(bool isStart, bool isCompleted, bool isLocked, ColorScheme colorScheme) {
    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.accentGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          LucideIcons.check,
          size: 18,
          color: colorScheme.onPrimary,
        ),
      );
    }

    if (isStart) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          LucideIcons.bookOpen,
          size: 18,
          color: colorScheme.onPrimary,
        ),
      );
    }

    // Locked
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        LucideIcons.lock,
        size: 16,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}





