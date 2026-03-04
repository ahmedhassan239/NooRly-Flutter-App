import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton Card
///
/// Loading placeholder card with shimmer effect
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    this.height = 200,
    this.showHeader = true,
    this.linesCount = 3,
    super.key,
  });

  final double height;
  final bool showHeader;
  final int linesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.muted,
        highlightColor: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header badge
            if (showHeader)
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),

            if (showHeader) const SizedBox(height: AppSpacing.md),

            // Content lines
            ...List.generate(
              linesCount,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Action buttons placeholder
            Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    height: 32,
                    margin: EdgeInsets.only(
                      right: index < 3 ? 8 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
