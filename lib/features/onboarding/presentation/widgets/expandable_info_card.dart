import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/onboarding/presentation/theme/onboarding_colors.dart';

/// Collapsible card: icon + title + subtitle + chevron. Expanded area is [expandedChild].
class ExpandableInfoCard extends StatefulWidget {
  const ExpandableInfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.expandedChild,
  });

  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? expandedChild;

  @override
  State<ExpandableInfoCard> createState() => _ExpandableInfoCardState();
}

class _ExpandableInfoCardState extends State<ExpandableInfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: OnboardingColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OnboardingColors.border),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: OnboardingColors.iconBadgeBeige,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: widget.icon,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: AppTypography.body(color: OnboardingColors.textPrimary).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                style: AppTypography.bodySm(color: OnboardingColors.textMuted),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                        color: OnboardingColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (_expanded && widget.expandedChild != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: widget.expandedChild,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
