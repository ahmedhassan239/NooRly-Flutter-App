import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 2: YOUR JOURNEY card. Dynamic: current lesson from backend or empty/error state.
class JourneyCard extends ConsumerWidget {
  const JourneyCard({
    this.lesson,
    super.key,
    this.isGuest = false,
    this.isEmpty = false,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onSignIn,
  });

  final LessonEntity? lesson;
  final bool isGuest;
  final bool isEmpty;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isGuest) return _buildGuestCard(context, colorScheme);
    if (isLoading) return _buildLoadingCard(context, colorScheme);
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return _buildErrorCard(context, colorScheme);
    }
    if (isEmpty || lesson == null) return _buildEmptyCard(context, colorScheme);
    final locale = ref.watch(localeControllerProvider).languageCode;
    return _buildLessonCard(context, colorScheme, lesson!, locale);
  }

  Widget _buildGuestCard(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return DottedCard(
      padding: const EdgeInsets.all(20),
      onTap: () => context.go('/login'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 8),
          Text(
            l10n.signInToContinueLessons,
            style: AppTypography.body(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.actionSignIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context, ColorScheme colorScheme) {
    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 12),
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 14,
            width: 120,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            style: AppTypography.body(
                color: colorScheme.onSurface.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (onSignIn != null)
                TextButton(
                  onPressed: onSignIn,
                  child: Text(l10n.actionSignIn),
                ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: Text(l10n.actionRetry),
                ),
              TextButton(
                onPressed: () => context.go('/journey'),
                child: Text(l10n.viewJourney),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return DottedCard(
      padding: const EdgeInsets.all(20),
      onTap: () => context.go('/journey'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 8),
          Text(l10n.noLessonRightNow,
              style: AppTypography.body(color: colorScheme.onSurface)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/journey'),
            child: Text(l10n.viewJourney),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    ColorScheme colorScheme,
    LessonEntity l,
    String locale,
  ) {
    final loc = AppLocalizations.of(context)!;
    final rawDurationStr = l.duration != null
        ? loc.journeyDurationMinRead(l.duration!)
        : '';
    final rawWeekDayStr = l.weekNumber != null
        ? loc.journeyWeekDayLabel(l.weekNumber!, l.dayNumber)
        : loc.journeyDayLabel(l.dayNumber);
    final durationStr = toLocaleDigits(rawDurationStr, locale);
    final weekDayStr = toLocaleDigits(rawWeekDayStr, locale);
    final title = _localizedLessonTitle(l, locale);

    return DottedCard(
      padding: const EdgeInsets.all(20),
      onTap: () => context.push('/lessons/${l.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.h2(color: colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(
            weekDayStr,
            style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          if (durationStr.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(LucideIcons.clock, size: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  durationStr,
                  style: AppTypography.bodySm(
                      color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push('/lessons/${l.id}'),
              icon: const Icon(LucideIcons.arrowRight, size: 18),
              label: Text(loc.actionContinue),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Title with locale: entity titleAr when Arabic, else fallback map for known titles.
  static String _localizedLessonTitle(LessonEntity l, String locale) {
    if (locale == 'ar') {
      if (l.titleAr != null && l.titleAr!.trim().isNotEmpty) return l.titleAr!;
      final ar = _knownTitleAr[l.title.trim()];
      if (ar != null) return ar;
    }
    return l.title;
  }

  static const Map<String, String> _knownTitleAr = {
    'Welcome to Islam': 'مرحباً بالإسلام',
  };

  Widget _labelChip(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.yourJourney,
      style: AppTypography.caption(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}
