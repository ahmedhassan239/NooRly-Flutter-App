import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/page_background.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_app/features/onboarding/presentation/widgets/journey_timeline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JourneySummaryPage extends ConsumerStatefulWidget {
  const JourneySummaryPage({super.key});

  @override
  ConsumerState<JourneySummaryPage> createState() => _JourneySummaryPageState();
}

class _JourneySummaryPageState extends ConsumerState<JourneySummaryPage> with TickerProviderStateMixin {
  bool _isStarting = false;
  bool _showConfetti = false;

  final List<Map<String, dynamic>> _weekBlocks = [
    {
      'icon': LucideIcons.bookOpen,
      'weeks': 'Weeks 1-4',
      'title': 'Faith Basics',
      'description': 'Learn core beliefs, pillars of Islam, and Shahada meaning',
      'color': AppColors.primary,
      'bgColor': AppColors.primary.withValues(alpha: 0.1),
    },
    {
      'icon': LucideIcons.calendar,
      'weeks': 'Weeks 5-8',
      'title': 'Learning Salah',
      'description': 'Master Wudu, prayer positions, and daily prayers',
      'color': AppColors.accentGreen,
      'bgColor': AppColors.accentGreen.withValues(alpha: 0.1),
    },
    {
      'icon': LucideIcons.trophy,
      'weeks': 'Weeks 9-12',
      'title': 'Building Habits',
      'description': 'Quran reading, daily Dhikr, and Islamic etiquette',
      'color': AppColors.accentGold,
      'bgColor': AppColors.accentGold.withValues(alpha: 0.1),
    },
  ];

  Future<void> _handleStartJourney() async {
    setState(() {
      _isStarting = true;
      _showConfetti = true;
    });

    final isAuth = ref.read(authProvider).isAuthenticated;
    if (isAuth) {
      try {
        final repo = ref.read(onboardingRepositoryProvider);
        await repo.updateOnboarding(summaryCompleted: true);
        await ref.read(authProvider.notifier).refreshOnboarding();
      } catch (_) {
        if (mounted) setState(() => _isStarting = false);
        return;
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          const PageBackground(theme: PageTheme.journey),
          
          if (_showConfetti) _buildConfetti(),

          SafeArea(
            child: Column(
              children: [
                // Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                           Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2)))),
                           const SizedBox(width: 8),
                           Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2)))),
                           const SizedBox(width: 8),
                           Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2)))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Step 3 of 3', style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7))),
                    ],
                  ),
                ),

                // Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Align(
                     alignment: Alignment.centerLeft,
                     child: IconButton(
                       icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
                       onPressed: _isStarting ? null : () => context.go('/onboarding/goals'),
                        style: IconButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         hoverColor: colorScheme.outlineVariant,
                       ),
                     ),
                   ).animate().fadeIn().moveX(begin: -20, end: 0),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                         // Header
                         Column(
                           children: [
                             Container(
                               width: 64,
                               height: 64,
                               decoration: BoxDecoration(
                                 color: colorScheme.primary.withValues(alpha: 0.1),
                                 borderRadius: BorderRadius.circular(16),
                               ),
                               child: Icon(LucideIcons.bird, color: colorScheme.primary, size: 32),
                             ),
                             const SizedBox(height: 16),
                             Text(
                               'Your 90-Day Journey',
                               style: AppTypography.h1(color: colorScheme.onSurface).copyWith(fontSize: 28), // Slight adjustment
                               textAlign: TextAlign.center,
                             ),
                             const SizedBox(height: 8),
                             Text(
                               "Here's what we'll cover together",
                               style: AppTypography.body(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                               textAlign: TextAlign.center,
                             ),
                           ],
                         ).animate(delay: 200.ms).fadeIn().moveY(begin: 20, end: 0),

                         const SizedBox(height: 32),

                         // Timeline Visual
                         const JourneyTimeline(
                           currentWeek: 0, // Start of journey
                           showTitle: false, // Title already shown above
                         ).animate(delay: 400.ms).fadeIn().moveY(begin: 20, end: 0),

                         const SizedBox(height: 32),

                         // Blocks
                         ..._weekBlocks.asMap().entries.map((entry) {
                           final index = entry.key;
                           final block = entry.value;
                           return Padding(
                             padding: const EdgeInsets.only(bottom: 12),
                             child: Container(
                               padding: const EdgeInsets.all(20),
                               decoration: BoxDecoration(
                                 color: colorScheme.surfaceContainerHighest,
                                 borderRadius: BorderRadius.circular(16),
                                 border: Border.all(color: colorScheme.outline),
                               ),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     width: 48,
                                     height: 48,
                                     decoration: BoxDecoration(
                                       color: block['bgColor'] as Color,
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                     child: Icon(block['icon'] as IconData, color: block['color'] as Color, size: 24),
                                   ),
                                   const SizedBox(width: 16),
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                          Text(
                                            block['weeks'] as String,
                                            style: AppTypography.caption(color: block['color'] as Color).copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            block['title'] as String,
                                            style: AppTypography.body(color: colorScheme.onSurface).copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            block['description'] as String,
                                            style: AppTypography.caption(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                                          ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ).animate(delay: (500 + (index * 150)).ms).fadeIn().moveY(begin: 20, end: 0),
                           );
                         }),

                         const SizedBox(height: 24),

                         SizedBox(
                           width: double.infinity,
                           height: 56,
                           child: AppButton(
                             text: _isStarting ? 'Starting...' : 'Start My Journey',
                             onPressed: _isStarting ? null : _handleStartJourney,
                             isLoading: _isStarting,
                             icon: _isStarting ? null : Icon(LucideIcons.bird, color: colorScheme.onPrimary, size: 20),
                           ),
                         ).animate(delay: 800.ms).fadeIn().moveY(begin: 20, end: 0),
                         
                         const SizedBox(height: 32),
                      ],
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


  Widget _buildConfetti() {
     final colorScheme = Theme.of(context).colorScheme;
     return IgnorePointer(
       child: Stack(
         children: List.generate(20, (index) {
           final colors = [
             colorScheme.tertiary,
             colorScheme.primary,
             AppColors.accentGold, // Keep accent colors as they're semantic
           ];
           return Positioned(
             left: (index * 20).toDouble() % MediaQuery.of(context).size.width,
             top: -20,
             child: Container(
               width: 8,
               height: 8,
               color: colors[index % 3],
             ).animate(onPlay: (controller) => controller.repeat())
              .moveY(begin: 0, end: MediaQuery.of(context).size.height, duration: (1500 + (index * 100)).ms)
              .rotate(end: 2)
              .fadeOut(delay: 1000.ms),
           );
         }),
       ),
     );
  }
}
