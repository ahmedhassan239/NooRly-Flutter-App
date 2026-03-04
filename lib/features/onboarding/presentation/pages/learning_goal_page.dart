import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LearningGoalPage extends ConsumerStatefulWidget {
  const LearningGoalPage({super.key});

  @override
  ConsumerState<LearningGoalPage> createState() => _LearningGoalPageState();
}

class _LearningGoalPageState extends ConsumerState<LearningGoalPage> {
  final List<String> _selectedGoalIds = [];
  bool _isSaving = false;

  final List<Map<String, dynamic>> _goals = [
    {'id': 'salah', 'icon': '🕌', 'title': 'Learn Salah', 'description': 'Understand prayer steps'},
    {'id': 'quran', 'icon': '📖', 'title': 'Quran Basics', 'description': 'Start reading the Quran'},
    {'id': 'faith', 'icon': '🌙', 'title': 'Faith Essentials', 'description': 'Core beliefs & pillars'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromBackend());
  }

  void _loadFromBackend() {
    final auth = ref.read(authProvider);
    final onboarding = auth.onboarding as OnboardingEntity?;
    if (onboarding != null && onboarding.goals.isNotEmpty) {
      setState(() => _selectedGoalIds.addAll(onboarding.goals));
    }
  }

  void _toggleGoal(String id) {
    setState(() {
      if (_selectedGoalIds.contains(id)) {
        _selectedGoalIds.remove(id);
      } else {
        _selectedGoalIds.add(id);
      }
    });
  }

  Future<void> _handleContinue() async {
    if (_selectedGoalIds.isEmpty) return;
    final isAuth = ref.read(authProvider).isAuthenticated;
    if (isAuth) {
      setState(() => _isSaving = true);
      try {
        final repo = ref.read(onboardingRepositoryProvider);
        await repo.updateOnboarding(goals: _selectedGoalIds);
        await ref.read(authProvider.notifier).refreshOnboarding();
      } catch (e) {
        if (mounted) setState(() => _isSaving = false);
        return;
      }
    }
    if (mounted) context.go('/onboarding/summary');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
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
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Step 2 of 3', style: AppTypography.caption().copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
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
                  onPressed: () => context.go('/onboarding/shahada-date'),
                   style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    hoverColor: colorScheme.outlineVariant,
                  ),
                ),
              ).animate().fadeIn().moveX(begin: -20, end: 0),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(LucideIcons.target, color: colorScheme.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  'What would you like to learn first?',
                                  style: AppTypography.h1(color: colorScheme.onSurface),
                                ),
                              const SizedBox(height: 8),
                                Text(
                                  'Choose one to start your journey',
                                  style: AppTypography.body(color: colorScheme.onSurface),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ).animate(delay: 100.ms).fadeIn().moveY(begin: 20, end: 0),

                    const SizedBox(height: 40),

                    // Goals List
                    ..._goals.asMap().entries.map((entry) {
                      final index = entry.key;
                      final goal = entry.value;
                      final id = goal['id'] as String;
                      final isSelected = _selectedGoalIds.contains(id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _toggleGoal(id),
                          child: AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                            color: isSelected ? colorScheme.primary.withValues(alpha: 0.05) : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : colorScheme.outline,
                                width: 2,
                              ),
                             // boxShadow: isSelected ? AppShadows.sm : [], // shadows not constant
                            ),
                            child: Row(
                              children: [
                                Text(
                                  goal['icon'] as String,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                          goal['title'] as String,
                                          style: AppTypography.body(color: colorScheme.onSurface).copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                        Text(
                                          goal['description'] as String,
                                          style: AppTypography.bodySm(color: colorScheme.onSurface),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? colorScheme.primary : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
                                      : null,
                                ).animate(target: isSelected ? 1 : 0)
                                 .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), curve: Curves.elasticOut),
                              ],
                            ),
                          ),
                        ),
                      ).animate(delay: (200 + (index * 100)).ms).fadeIn().moveY(begin: 20, end: 0);
                    }),

                    const Spacer(),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: AppButton(
                        text: _isSaving ? 'Saving...' : 'Continue',
                        onPressed: (_selectedGoalIds.isNotEmpty && !_isSaving) ? _handleContinue : null,
                        icon: _isSaving ? null : Icon(LucideIcons.arrowRight, color: colorScheme.onPrimary),
                      ),
                    ).animate(delay: 500.ms).fadeIn().moveY(begin: 20, end: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
