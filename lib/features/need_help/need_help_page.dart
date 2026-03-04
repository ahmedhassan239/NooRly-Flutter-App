import 'package:flutter/material.dart';
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
// Help section (title + icon + tiles)
// -----------------------------------------------------------------------------

class HelpSection extends StatelessWidget {
  const HelpSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.tiles,
    super.key,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<HelpTileData> tiles;

  @override
  Widget build(BuildContext context) {
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
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: NeedHelpTokens.s12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: NeedHelpTokens.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: NeedHelpTokens.s12),
        ...tiles.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: NeedHelpTokens.s12),
            child: HelpTile(
              label: t.label,
              onTap: () => context.push(t.route),
            ),
          ),
        ),
      ],
    );
  }
}

class HelpTileData {
  const HelpTileData({required this.label, required this.route});
  final String label;
  final String route;
}

// -----------------------------------------------------------------------------
// Need Help page
// -----------------------------------------------------------------------------

class NeedHelpPage extends StatefulWidget {
  const NeedHelpPage({super.key});

  static const String routeName = '/need-help';

  @override
  State<NeedHelpPage> createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage>
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

  static const List<HelpTileData> _prayerTiles = [
    HelpTileData(
      label: "I don't know how to pray yet",
      route: '/help/prayer/how-to-pray',
    ),
    HelpTileData(label: 'I missed a prayer', route: '/help/prayer/missed'),
    HelpTileData(
      label: 'I made a mistake in prayer',
      route: '/help/prayer/mistake',
    ),
  ];

  static const List<HelpTileData> _emotionalTiles = [
    HelpTileData(label: 'I feel overwhelmed', route: '/help/emotional/overwhelmed'),
    HelpTileData(
      label: 'I have doubts about Islam',
      route: '/help/emotional/doubts',
    ),
    HelpTileData(
      label: 'I feel guilty about my past',
      route: '/help/emotional/guilty',
    ),
    HelpTileData(
      label: 'My family is against Islam',
      route: '/help/emotional/family',
    ),
  ];

  static const List<HelpTileData> _practicalTiles = [
    HelpTileData(label: 'Is this halal?', route: '/help/practical/halal'),
    HelpTileData(
      label: 'What do I say in this situation?',
      route: '/help/practical/what-to-say',
    ),
    HelpTileData(
      label: 'Quick duas I need',
      route: '/help/practical/quick-duas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'How Can We Help?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: NeedHelpTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "You're not alone. We're here for you.",
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                NeedHelpTokens.s16,
                0,
                NeedHelpTokens.s16,
                NeedHelpTokens.s28,
              ),
              children: [
                const SizedBox(height: NeedHelpTokens.s24),
                HelpSection(
                  title: 'Prayer Support',
                  icon: LucideIcons.landmark,
                  iconColor: NeedHelpTokens.iconGold,
                  tiles: _prayerTiles,
                ),
                const SizedBox(height: NeedHelpTokens.s28),
                HelpSection(
                  title: 'Emotional Support',
                  icon: LucideIcons.heart,
                  iconColor: NeedHelpTokens.iconGreen,
                  tiles: _emotionalTiles,
                ),
                const SizedBox(height: NeedHelpTokens.s28),
                HelpSection(
                  title: 'Practical Help',
                  icon: LucideIcons.clipboardList,
                  iconColor: NeedHelpTokens.textPrimary,
                  tiles: _practicalTiles,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Help route → title (for placeholder screens)
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

// -----------------------------------------------------------------------------
// Placeholder screen for help sub-routes
// -----------------------------------------------------------------------------

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
