import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/content_icon_mapper.dart';
import 'package:flutter_app/features/help_now/data/help_now_models.dart';
import 'package:flutter_app/features/help_now/providers/help_now_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

// -----------------------------------------------------------------------------
// Design tokens (Need Help screen – match spec exactly)
// -----------------------------------------------------------------------------

abstract final class NeedHelpTokens {
  NeedHelpTokens._();

  static const Color background = Color(0xFFF7F8FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE9ECF2);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color iconGold = Color(0xFFD97706);
  static const Color iconGreen = Color(0xFF059669);

  static const double cardRadius = 15.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;

  static const double tileHeight = 58.0;
  static const double dotSpacing = 24.0;
  static const double dotRadius = 1.2;
  static const double dotOpacity = 0.06;
}

// -----------------------------------------------------------------------------
// Dotted background (safe for bounded layout)
// -----------------------------------------------------------------------------

class _NeedHelpDotsPainter extends CustomPainter {
  _NeedHelpDotsPainter({
    required this.color,
    this.spacing = NeedHelpTokens.dotSpacing,
    this.radius = NeedHelpTokens.dotRadius,
  });

  final Color color;
  final double spacing;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 ||
        !size.width.isFinite || !size.height.isFinite) return;
    final paint = Paint()..color = color;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeedHelpDottedBackground extends StatelessWidget {
  const NeedHelpDottedBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth.isFinite && constraints.maxHeight.isFinite) {
                return CustomPaint(
                  painter: _NeedHelpDotsPainter(
                    color: NeedHelpTokens.textPrimary
                        .withValues(alpha: NeedHelpTokens.dotOpacity),
                    spacing: NeedHelpTokens.dotSpacing,
                    radius: NeedHelpTokens.dotRadius,
                  ),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        child,
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Help tile (white card, chevron)
// -----------------------------------------------------------------------------

class HelpTile extends StatelessWidget {
  const HelpTile({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NeedHelpTokens.card,
      borderRadius: BorderRadius.circular(NeedHelpTokens.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NeedHelpTokens.cardRadius),
        child: Container(
          height: NeedHelpTokens.tileHeight,
          padding: const EdgeInsets.symmetric(horizontal: NeedHelpTokens.s16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NeedHelpTokens.cardRadius),
            border: Border.all(color: NeedHelpTokens.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: NeedHelpTokens.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: NeedHelpTokens.textSecondary.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Help section (title + icon + tiles) – from API category
// -----------------------------------------------------------------------------

class HelpSectionFromCategory extends StatelessWidget {
  const HelpSectionFromCategory({
    required this.category,
    super.key,
  });

  final HelpCategoryModel category;

  @override
  Widget build(BuildContext context) {
    final iconColor = _iconColorForCategory(category.icon);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconDataFromKey(category.icon),
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: NeedHelpTokens.s12),
            Text(
              category.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: NeedHelpTokens.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: NeedHelpTokens.s12),
        ...category.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: NeedHelpTokens.s12),
            child: HelpTile(
              label: item.title,
              onTap: () => context.push('/help-now/item/${item.slug}'),
            ),
          ),
        ),
      ],
    );
  }

  static Color _iconColorForCategory(String iconKey) {
    final k = iconKey.trim().toLowerCase();
    if (k == 'heart' || k == 'support') return NeedHelpTokens.iconGreen;
    if (k == 'clipboard' || k == 'question') return NeedHelpTokens.textPrimary;
    return NeedHelpTokens.iconGold;
  }
}

// -----------------------------------------------------------------------------
// Need Help page – data from API
// -----------------------------------------------------------------------------

class NeedHelpPage extends ConsumerStatefulWidget {
  const NeedHelpPage({super.key});

  static const String routeName = '/need-help';

  @override
  ConsumerState<NeedHelpPage> createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends ConsumerState<NeedHelpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animOpacity;
  late Animation<Offset> _animSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _animOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animSlide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(helpNowCategoriesProvider);

    return Scaffold(
      backgroundColor: NeedHelpTokens.background,
      appBar: AppBar(
        backgroundColor: NeedHelpTokens.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          color: NeedHelpTokens.textPrimary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.howCanWeHelp,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: NeedHelpTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.helpNowSubtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: NeedHelpTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: NeedHelpDottedBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: _animOpacity.value,
                child: SlideTransition(
                  position: _animSlide,
                  child: child,
                ),
              );
            },
            child: categoriesAsync.when(
              data: (List<HelpCategoryModel> categories) {
                if (categories.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(NeedHelpTokens.s24),
                      child: Text(
                        l10n.helpNowEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: NeedHelpTokens.textSecondary,
                        ),
                      ),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    NeedHelpTokens.s16,
                    0,
                    NeedHelpTokens.s16,
                    NeedHelpTokens.s28,
                  ),
                  children: [
                    const SizedBox(height: NeedHelpTokens.s24),
                    ...categories.asMap().entries.map((entry) {
                      final isFirst = entry.key == 0;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isFirst) const SizedBox(height: NeedHelpTokens.s28),
                          HelpSectionFromCategory(category: entry.value),
                        ],
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(NeedHelpTokens.s24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(NeedHelpTokens.s24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.alertCircle,
                        size: 48,
                        color: NeedHelpTokens.textSecondary,
                      ),
                      const SizedBox(height: NeedHelpTokens.s16),
                      Text(
                        l10n.helpNowError,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: NeedHelpTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: NeedHelpTokens.s16),
                      FilledButton.icon(
                        onPressed: () =>
                            ref.invalidate(helpNowCategoriesProvider),
                        icon: const Icon(LucideIcons.refreshCw, size: 18),
                        label: Text(l10n.actionRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Legacy placeholder for /help/:category/:topic (kept for backwards compatibility)
// -----------------------------------------------------------------------------

const Map<String, String> _helpRouteTitles = {
  '/help/prayer/how-to-pray': "I don't know how to pray yet",
  '/help/prayer/missed': 'I missed a prayer',
  '/help/prayer/mistake': 'I made a mistake in prayer',
  '/help/emotional/overwhelmed': 'I feel overwhelmed',
  '/help/emotional/doubts': 'I have doubts about Islam',
  '/help/emotional/guilty': 'I feel guilty about my past',
  '/help/emotional/family': 'My family is against Islam',
  '/help/practical/halal': 'Is this halal?',
  '/help/practical/what-to-say': 'What do I say in this situation?',
  '/help/practical/quick-duas': 'Quick duas I need',
};

String helpPlaceholderTitle(String path) {
  return _helpRouteTitles[path] ?? 'Help';
}

class HelpPlaceholderScreen extends StatelessWidget {
  const HelpPlaceholderScreen({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedHelpTokens.background,
      appBar: AppBar(
        backgroundColor: NeedHelpTokens.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
          color: NeedHelpTokens.textPrimary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: NeedHelpTokens.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(NeedHelpTokens.s24),
          child: Text(
            'Content coming soon.',
            style: TextStyle(
              fontSize: 16,
              color: NeedHelpTokens.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
