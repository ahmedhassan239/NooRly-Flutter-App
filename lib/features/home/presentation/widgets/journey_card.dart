import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/dotted_card_background.dart';
import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 2: YOUR JOURNEY card. Label chip, title, subtitle, "Continue Reading →".
class JourneyCard extends StatelessWidget {
  const JourneyCard({
    this.lesson,
    super.key,
    this.isGuest = false,
    this.isEmpty = false,
  });

  final LessonEntity? lesson;
  final bool isGuest;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isGuest) {
      return DottedCard(
        padding: const EdgeInsets.all(20),
        onTap: () => context.go('/login'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelChip(context, colorScheme),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue your lessons',
              style: AppTypography.body(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign In'),
              ),
            ),
          ],
        ),
      );
    }

    if (isEmpty || lesson == null) {
      return DottedCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelChip(context, colorScheme),
            const SizedBox(height: 8),
            Text(
              'No lesson right now',
              style: AppTypography.body(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/journey'),
              child: const Text('View Journey'),
            ),
          ],
        ),
      );
    }

    final l = lesson!;
    final durationStr =
        l.duration != null ? '${l.duration} min read' : '';

    return DottedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelChip(context, colorScheme),
          const SizedBox(height: 8),
          Text(
            l.title,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          if (durationStr.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  LucideIcons.clock,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  durationStr,
                  style: AppTypography.bodySm(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
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
              label: const Text('Continue Reading →'),
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

  Widget _labelChip(BuildContext context, ColorScheme colorScheme) {
    return Text(
      'YOUR JOURNEY',
      style: AppTypography.caption(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}
