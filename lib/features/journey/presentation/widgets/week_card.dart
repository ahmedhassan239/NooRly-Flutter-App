import 'package:flutter/material.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/widgets/backend_remote_icon.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/journey/presentation/journey_mock_data.dart';
import 'package:flutter_app/features/journey/presentation/widgets/lesson_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Collapsible week card showing lessons
class WeekCard extends StatefulWidget {
  const WeekCard({
    required this.week,
    required this.onLessonTap,
    super.key,
    this.initiallyExpanded = false,
  });

  final WeekData week;
  final void Function(LessonData lesson) onLessonTap;
  final bool initiallyExpanded;

  @override
  State<WeekCard> createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(WeekCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
      if (_isExpanded) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final week = widget.week;
    final isCurrent = week.isCurrent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isCurrent ? colorScheme.primary.withAlpha(77) : colorScheme.outline.withAlpha(128),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.card - 1),
                bottom: _isExpanded ? Radius.zero : Radius.circular(AppRadius.card - 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? colorScheme.primary.withAlpha(25)
                            : colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _buildWeekIcon(week, colorScheme, isCurrent),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title and week number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? colorScheme.primary.withAlpha(25)
                                      : colorScheme.outlineVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.journeyWeekLabel(week.weekNumber),
                                  style: AppTypography.caption(
                                    color: isCurrent
                                        ? colorScheme.primary
                                        : colorScheme.onSurface.withValues(alpha: 0.7),
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGreen.withAlpha(25),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.zap,
                                        size: 10,
                                        color: AppColors.accentGreen,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(context)!.journeyStatCurrent,
                                        style: AppTypography.caption(
                                          color: AppColors.accentGreen,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            week.title,
                            style: AppTypography.body(color: colorScheme.onSurface)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    // Progress and expand icon
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${week.completedCount}/${week.totalCount}',
                          style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 4),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            LucideIcons.chevronDown,
                            size: 20,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lessons (collapsible) – when expanded show content directly so it’s visible after reload
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    key: ValueKey('lessons_${week.weekId ?? week.weekNumber}_${week.lessons.length}'),
                    children: [
                      Divider(
                        height: 1,
                        color: colorScheme.outline.withAlpha(128),
                      ),
                      ...week.lessons.map((lesson) {
                        return LessonItem(
                          key: ValueKey(lesson.id),
                          lesson: lesson,
                          onTap: () => widget.onLessonTap(lesson),
                        );
                      }),
                      if (week.lessons.isEmpty && week.totalCount > 0)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.journeyNoLessonsLoaded,
                              style: AppTypography.caption(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Builds the appropriate icon widget for the week (from backend iconKey/iconUrl or fallback).
  Widget _buildWeekIcon(WeekData week, ColorScheme colorScheme, bool isCurrentWeek) {
    if (week.iconUrl != null && week.iconUrl!.trim().isNotEmpty) {
      final url =
          ApiConfig.resolvePublicUrl(week.iconUrl!.trim()) ?? week.iconUrl!.trim();
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackendRemoteIcon(
          url: url,
          size: 24,
          fallback: Icon(
            LucideIcons.bookOpen,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }
    if (week.weekNumber == 13) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/brand/flock_logo.svg',
          fit: BoxFit.contain,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
            isCurrentWeek ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
            BlendMode.srcIn,
          ),
          width: 24,
          height: 24,
        ),
      );
    }
    if (week.icon.isNotEmpty) {
      return Text(week.icon, style: const TextStyle(fontSize: 20));
    }
    return Icon(
      LucideIcons.bookOpen,
      size: 20,
      color: colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }
}






