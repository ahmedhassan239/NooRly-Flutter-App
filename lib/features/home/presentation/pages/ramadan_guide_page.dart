import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_layout.dart';
import 'package:flutter_app/features/ramadan_guide/data/ramadan_guide_models.dart';
import 'package:flutter_app/features/ramadan_guide/providers/ramadan_guide_providers.dart';
import 'package:flutter_app/core/utils/content_icon_mapper.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Ramadan Guide screen: app bar, list of accordion cards from API, dotted background.
class RamadanGuidePage extends ConsumerStatefulWidget {
  const RamadanGuidePage({super.key});

  @override
  ConsumerState<RamadanGuidePage> createState() => _RamadanGuidePageState();
}

class _RamadanGuidePageState extends ConsumerState<RamadanGuidePage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = colorScheme.surface;
    final listAsync = ref.watch(ramadanGuideListProvider);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DottedBackgroundPainter(
                dotColor: colorScheme.outline.withValues(alpha: 0.08),
                spacing: 24,
                dotRadius: 1.2,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: bg.withValues(alpha: 0.6),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppBar(context, colorScheme),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: HomeLayout.maxContentWidth,
                      ),
                      child: listAsync.when(
                        data: (List<RamadanGuideItemModel> items) {
                          if (items.isEmpty) {
                            return _buildEmpty(context);
                          }
                          return SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(
                              HomeLayout.contentPaddingHorizontal,
                              AppSpacing.md,
                              HomeLayout.contentPaddingHorizontal,
                              AppSpacing.xl2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int i = 0; i < items.length; i++) ...[
                                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                                  _RamadanAccordionCard(
                                    item: items[i],
                                    isExpanded: _expandedIndex == i,
                                    onTap: () {
                                      setState(() {
                                        _expandedIndex =
                                            _expandedIndex == i ? null : i;
                                      });
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.xl),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (err, st) => _buildError(context, err),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.ramadanGuideTitle,
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  l10n.prepareForTheBlessedMonth,
                  style: AppTypography.caption(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.bookOpen,
                size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.ramadanGuideEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.body(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object err) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.alertCircle,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.ramadanGuideError,
              textAlign: TextAlign.center,
              style: AppTypography.body(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => ref.invalidate(ramadanGuideListProvider),
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: Text(l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _RamadanAccordionCard extends StatelessWidget {
  const _RamadanAccordionCard({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  final RamadanGuideItemModel item;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final svgPath = ramadanSvgAssetFromKey(item.icon);
    final iconColor = ramadanIconColorFromKey(item.icon);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                      child: svgPath != null
                          ? SvgPicture.asset(
                              svgPath,
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                            )
                          : Icon(
                              iconDataFromKey(item.icon),
                              size: 22,
                              color: iconColor,
                            ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTypography.h3(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.description,
                            style: AppTypography.bodySm(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  Divider(
                    height: 24,
                    color: colorScheme.outline.withValues(alpha: 0.12),
                  ),
                  Text(
                    item.content,
                    style: AppTypography.body(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
