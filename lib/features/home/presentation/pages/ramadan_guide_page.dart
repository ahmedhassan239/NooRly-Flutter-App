import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/home/presentation/widgets/home_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Icon colors for Ramadan accordion (warm yellow/orange per design).
class _RamadanIconColors {
  _RamadanIconColors._();
  static const Color moonSun = Color(0xFFE8A317);
  static const Color warning = Color(0xFFF5A623);
  static const Color prayingHands = Color(0xFFE8B923);
  static const Color sparkles = Color(0xFFF7E5A3);
}

/// Ramadan Guide screen: app bar with title + subtitle, 5 accordion cards, dotted background.
class RamadanGuidePage extends StatefulWidget {
  const RamadanGuidePage({super.key});

  @override
  State<RamadanGuidePage> createState() => _RamadanGuidePageState();
}

class _RamadanGuidePageState extends State<RamadanGuidePage> {
  int? _expandedIndex;
  static bool _debugChecklistPrinted = false;

  static const String _assetMoon = 'assets/icons/ramadan/icon_crescent_moon.svg';
  static const String _assetSun = 'assets/icons/ramadan/icon_sun.svg';
  static const String _assetWarning = 'assets/icons/ramadan/icon_warning.svg';
  static const String _assetHands = 'assets/icons/ramadan/icon_praying_hands.svg';
  static const String _assetSparkles = 'assets/icons/ramadan/icon_sparkles.svg';

  static List<_AccordionItem> get _items => [
    _AccordionItem(
      title: 'What is Ramadan?',
      subtitle: 'Understanding the blessed month',
      svgAsset: _assetMoon,
      iconColor: _RamadanIconColors.moonSun,
      body:
          'Ramadan is the ninth month of the Islamic calendar, observed by Muslims worldwide as a month of fasting, prayer, reflection, and community. It commemorates the first revelation of the Quran to the Prophet Muhammad (peace be upon him). Fasting from dawn until sunset is one of the Five Pillars of Islam.',
    ),
    _AccordionItem(
      title: 'How to Fast',
      subtitle: 'A step-by-step guide to fasting',
      svgAsset: _assetSun,
      iconColor: _RamadanIconColors.moonSun,
      body:
          'Intention (niyyah): Make the intention to fast before dawn. Suhoor: Eat a pre-dawn meal before Fajr. Abstain: Do not eat, drink, or engage in marital relations from dawn until sunset. Iftar: Break the fast at sunset, traditionally with dates and water. Maintain good conduct and avoid backbiting and arguments.',
    ),
    _AccordionItem(
      title: 'What Breaks the Fast',
      subtitle: 'Clear list of what invalidates fasting',
      svgAsset: _assetWarning,
      iconColor: _RamadanIconColors.warning,
      body:
          'Eating or drinking intentionally breaks the fast. Injections that provide nutrition, smoking, and marital relations during fasting hours also invalidate the fast. Vomiting intentionally breaks the fast; unintentional vomiting does not. Unintentional eating or drinking (e.g., forgetting) does not break the fast according to many scholars.',
    ),
    _AccordionItem(
      title: 'Ramadan Duas',
      subtitle: 'Essential supplications for Ramadan',
      svgAsset: _assetHands,
      iconColor: _RamadanIconColors.prayingHands,
      body:
          'Dua for breaking fast: "Allahumma laka sumtu wa bika aamantu wa alayka tawakkaltu wa ala rizqika aftartu." (O Allah, I fasted for You, I believe in You, I put my trust in You, and I break my fast with Your provision.) Seek Laylatul Qadr and increase dhikr and Quran recitation throughout the month.',
    ),
    _AccordionItem(
      title: 'Laylatul Qadr',
      subtitle: 'The Night of Power',
      svgAsset: _assetSparkles,
      iconColor: _RamadanIconColors.sparkles,
      body:
          'Laylatul Qadr is the night when the Quran was first revealed. It is better than a thousand months in reward. It is commonly sought in the last ten nights of Ramadan, on the odd nights (21st, 23rd, 25th, 27th, 29th). Spend the night in prayer, supplication, and remembrance of Allah.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('RamadanGuideScreen build');
      if (!_debugChecklistPrinted) {
        _debugChecklistPrinted = true;
        _printDebugChecklist();
      }
    }
    final colorScheme = Theme.of(context).colorScheme;
    final bg = colorScheme.surface;

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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          HomeLayout.contentPaddingHorizontal,
                          AppSpacing.md,
                          HomeLayout.contentPaddingHorizontal,
                          AppSpacing.xl2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (int i = 0; i < _items.length; i++) ...[
                              if (i > 0) const SizedBox(height: AppSpacing.sm),
                              _RamadanAccordionCard(
                                item: _items[i],
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
                  'Ramadan Guide',
                  style: AppTypography.h2(color: colorScheme.onSurface),
                ),
                Text(
                  'Prepare for the blessed month',
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

  void _printDebugChecklist() {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('CHECKLIST:');
    debugPrint('  [ ] Home CTA opens /ramadan');
    debugPrint('  [ ] Ramadan UI matches screenshot (appbar + 5 accordions + dotted bg)');
    debugPrint('  [ ] Icons match screenshot (moon/sun/warning/hands/sparkles)');
    debugPrint('  [ ] No exceptions/overflows on Web');
    debugPrint('  [ ] Back works');
    debugPrint('FILES CHANGED:');
    debugPrint('  - lib/features/home/presentation/pages/ramadan_guide_page.dart');
    debugPrint('  - lib/app/router.dart');
    debugPrint('  - lib/features/home/presentation/pages/home_dashboard_page.dart');
    debugPrint('  - pubspec.yaml');
    debugPrint('ASSETS ADDED:');
    debugPrint('  - assets/icons/ramadan/icon_crescent_moon.svg');
    debugPrint('  - assets/icons/ramadan/icon_sun.svg');
    debugPrint('  - assets/icons/ramadan/icon_warning.svg');
    debugPrint('  - assets/icons/ramadan/icon_praying_hands.svg');
    debugPrint('  - assets/icons/ramadan/icon_sparkles.svg');
    debugPrint('SEARCH RESULTS:');
    debugPrint('  Keywords: ramadan, RamadanGuidePage, /ramadan, icons, assets,');
    debugPrint('            flutter_svg, moon, sun, warning, praying hands, sparkles');
    debugPrint('  Files opened: router.dart, home_dashboard_page.dart, home_layout.dart,');
    debugPrint('    pubspec.yaml, ramadan_guide_page.dart');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');
  }
}

class _AccordionItem {
  const _AccordionItem({
    required this.title,
    required this.subtitle,
    required this.svgAsset,
    required this.iconColor,
    required this.body,
  });
  final String title;
  final String subtitle;
  final String svgAsset;
  final Color iconColor;
  final String body;
}

class _RamadanAccordionCard extends StatelessWidget {
  const _RamadanAccordionCard({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  final _AccordionItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                        color: item.iconColor.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                      child: SvgPicture.asset(
                        item.svgAsset,
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          item.iconColor,
                          BlendMode.srcIn,
                        ),
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
                            item.subtitle,
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
                    item.body,
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
