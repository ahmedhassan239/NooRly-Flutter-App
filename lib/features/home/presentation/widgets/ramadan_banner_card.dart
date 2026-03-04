import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Section 4: Ramadan banner – beige/tan card, crescent, title, subtitle, CTA, close (X).
/// Dismiss state is managed by parent (onDismiss).
class RamadanBannerCard extends StatelessWidget {
  const RamadanBannerCard({
    required this.onDismiss,
    this.onCta,
    super.key,
  });

  final VoidCallback onDismiss;
  final VoidCallback? onCta;

  static const Color _beigeBg = Color(0xFFF5E6D3);
  static const Color _beigeBorder = Color(0xFFE8D4B8);
  static const Color _titleColor = Color(0xFF5C4033);
  static const Color _subtitleColor = Color(0xFF7D6B5C);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 48, 16),
          decoration: BoxDecoration(
            color: _beigeBg,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: _beigeBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _titleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  LucideIcons.moon,
                  size: 22,
                  color: _titleColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ramadan is here',
                      style: AppTypography.h3(color: _titleColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prepare for the blessed month',
                      style: AppTypography.bodySm(color: _subtitleColor),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: onCta ?? () {},
                      child: const Text('Start Ramadan Guide'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            onPressed: onDismiss,
            style: IconButton.styleFrom(
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
