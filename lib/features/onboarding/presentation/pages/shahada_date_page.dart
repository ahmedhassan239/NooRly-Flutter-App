import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/app_button.dart';
import 'package:flutter_app/design_system/widgets/app_toast.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ShahadaDatePage extends ConsumerStatefulWidget {
  const ShahadaDatePage({super.key});

  @override
  ConsumerState<ShahadaDatePage> createState() => _ShahadaDatePageState();
}

class _ShahadaDatePageState extends ConsumerState<ShahadaDatePage> {
  DateTime? _selectedDate;
  String? _error;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromBackend());
  }

  void _loadFromBackend() {
    final auth = ref.read(authProvider);
    final onboarding = auth.onboarding as OnboardingEntity?;
    if (onboarding?.shahadaDate != null && _selectedDate == null) {
      setState(() => _selectedDate = onboarding!.shahadaDate);
    }
  }

  Future<void> _handleDateSelect() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (date.isAfter(now)) {
        setState(() {
          _error = 'Shahada date cannot be in the future';
          _selectedDate = null;
        });
      } else {
        setState(() {
          _selectedDate = date;
          _error = null;
        });
      }
    }
  }

  Future<void> _handleContinue() async {
    if (_selectedDate == null) return;
    final isAuth = ref.read(authProvider).isAuthenticated;
    if (isAuth) {
      setState(() => _isSaving = true);
      try {
        final repo = ref.read(onboardingRepositoryProvider);
        final dateStr = _selectedDate!.toIso8601String().split('T').first;
        await repo.updateOnboarding(shahadaDate: dateStr);
        await ref.read(authProvider.notifier).refreshOnboarding();
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          AppToast.show('Could not save. Try again.', context: context);
        }
        return;
      }
    }
    if (mounted) context.go('/onboarding/goals');
  }

  void _handleSkip() {
    AppToast.show('You can add this later in Profile', context: context);
    context.go('/onboarding/goals');
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
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 8),
                      Expanded(child: Container(height: 4, decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Step 1 of 3', style: AppTypography.caption().copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
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
                  onPressed: () => context.go('/'),
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
                          child: Icon(LucideIcons.bird, color: colorScheme.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  'When did you embrace Islam?',
                                  style: AppTypography.h1(color: colorScheme.onSurface),
                                ),
                              const SizedBox(height: 8),
                                Text(
                                  'This helps us celebrate your journey milestones',
                                  style: AppTypography.body().copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ).animate(delay: 100.ms).fadeIn().moveY(begin: 20, end: 0),

                    const SizedBox(height: 40),

                    // Date Picker Trigger
                    GestureDetector(
                      onTap: _handleDateSelect,
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: _error != null ? colorScheme.error : colorScheme.outline,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.calendar, color: colorScheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null
                                  ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                                  : 'Tap to select date',
                              style: _selectedDate != null
                                  ? AppTypography.body(color: colorScheme.onSurface).copyWith(fontWeight: FontWeight.w500)
                                  : AppTypography.body().copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: 200.ms).fadeIn().moveY(begin: 20, end: 0),

                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          _error!,
                          style: AppTypography.caption().copyWith(color: colorScheme.error),
                        ),
                      ).animate().fadeIn().moveY(begin: -10, end: 0),

                    const Spacer(),

                    // Actions
                    Column(
                      children: [
                        TextButton(
                          onPressed: _handleSkip,
                          child: Text(
                            'Skip for now',
                            style: AppTypography.bodySm().copyWith(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: AppButton(
                            text: _isSaving ? 'Saving...' : 'Continue',
                            onPressed: _isSaving ? null : _handleContinue,
                            icon: _isSaving ? null : Icon(LucideIcons.arrowRight, color: colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ).animate(delay: 300.ms).fadeIn().moveY(begin: 20, end: 0),
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
