import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/bottom_nav.dart';
import 'package:flutter_app/features/prayer/presentation/widgets/prayer_card.dart';
import 'package:flutter_app/features/prayer/presentation/widgets/prayer_header.dart';
import 'package:flutter_app/features/prayer/presentation/widgets/progress_card.dart';
import 'package:flutter_app/features/prayer/providers/notification_mute_provider.dart';
import 'package:flutter_app/features/prayer/providers/location_notifier.dart';
import 'package:flutter_app/core/utils/locale_digits.dart';
import 'package:flutter_app/features/prayer/providers/prayer_providers.dart';
import 'package:flutter_app/features/prayer/services/prayer_notifications_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PrayerTimesPage extends ConsumerStatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  ConsumerState<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends ConsumerState<PrayerTimesPage> {
  Timer? _timeTimer;
  final _addressController = TextEditingController();
  final _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _timeTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.read(currentTimeProvider.notifier).state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    _addressController.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleToggleNotifications() async {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrentlyMuted = ref.read(notificationMuteProvider);
    final notificationsService = PrayerNotificationsService.instance;

    final l10n = AppLocalizations.of(context)!;
    if (!isCurrentlyMuted) {
      await ref.read(notificationMuteProvider.notifier).toggleMute();
      await notificationsService.cancelAllPrayerReminders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.prayerNotificationsMuted),
            duration: const Duration(seconds: 2),
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        );
      }
    } else {
      final hasPermission = await notificationsService.requestPermission();
      if (hasPermission) {
        await ref.read(notificationMuteProvider.notifier).toggleMute();
        final prayerList = ref.read(todayPrayerListProvider).valueOrNull ?? [];
        await notificationsService.schedulePrayerReminders(
          prayerList: prayerList,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.prayerNotificationsEnabled),
              duration: const Duration(seconds: 2),
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.prayerNotificationPermissionRequired),
            duration: const Duration(seconds: 3),
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentTimeTickerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final now = ref.watch(currentTimeProvider);
    final address = ref.watch(effectiveAddressProvider);
    final locationAsync = ref.watch(locationNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(now, address, locationAsync),
                        const SizedBox(height: AppSpacing.lg),
                        if (address != null && address.isNotEmpty) ...[
                          _buildProgressSection(),
                          const SizedBox(height: AppSpacing.lg),
                          _buildTodaysPrayersSection(),
                        ] else if (locationAsync.isLoading) ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.xl),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ] else ...[
                          _buildAddressFallback(context, locationAsync),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeader(
    DateTime now,
    String? address,
    AsyncValue<LocationResult?> locationAsync,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final rawLocation = address ?? AppLocalizations.of(context)!.prayerGettingLocation;
    final locationLabel = toLocaleDigits(rawLocation, locale);
    final dateLabel = formatDateForDisplay(now, locale);
    final timeLabel = formatTimeForDisplay(now, locale);
    final isMuted = ref.watch(notificationMuteProvider);

    return PrayerHeader(
      locationLabel: locationLabel,
      dateLabel: dateLabel,
      currentTimeLabel: timeLabel,
      isMuted: isMuted,
      onMuteTap: _handleToggleNotifications,
    );
  }

  Widget _buildProgressSection() {
    final progressAsync = ref.watch(dailyProgressProvider);
    return progressAsync.when(
      data: (progress) => ProgressCard(progress: progress),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTodaysPrayersSection() {
    final listAsync = ref.watch(todayPrayerListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.prayerTodaysPrayers,
            style: AppTypography.caption(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          listAsync.when(
            data: (list) {
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      AppLocalizations.of(context)!.prayerNoPrayerTimesForLocation,
                      style: AppTypography.body(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list
                    .map((data) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: PrayerCard(data: data),
                        ))
                    .toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: AppTypography.body(
                        color: colorScheme.onSurface.withValues(alpha: 180),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () {
                        ref
                          ..invalidate(prayerTimingsTodayProvider)
                          ..invalidate(prayerTimingsTomorrowProvider);
                      },
                      child: Text(AppLocalizations.of(context)!.actionRetry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressFallback(
    BuildContext context,
    AsyncValue<LocationResult?> locationAsync,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: locationAsync.when(
        data: (_) => _buildNoLocationCard(context, colorScheme),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, _) => _buildNoLocationCard(context, colorScheme, errorText: e.toString()),
      ),
    );
  }

  Widget _buildNoLocationCard(
    BuildContext context,
    ColorScheme colorScheme, {
    String? errorText,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outline.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context)!.prayerLocationUnavailable,
            style: AppTypography.h3(color: colorScheme.onSurface),
          ),
          if (errorText != null && errorText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorText,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.prayerEnterCityHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                ref.read(manualAddressProvider.notifier).state = value.trim();
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final scheme = Theme.of(context).colorScheme;
              final result = await ref.read(locationNotifierProvider.notifier).requestLocation();
              if (!mounted) return;
              if (!mounted) return;
              final l10n = AppLocalizations.of(context)!;
              if (result == LocationRequestResult.permissionDeniedForever) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.prayerLocationPermissionDeniedForever),
                    action: SnackBarAction(
                      label: l10n.prayerOpenSettings,
                      onPressed: Geolocator.openAppSettings,
                    ),
                    duration: const Duration(seconds: 5),
                    backgroundColor: scheme.errorContainer,
                  ),
                );
              } else if (result == LocationRequestResult.permissionDenied) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.prayerLocationPermissionDenied),
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                );
              } else if (result == LocationRequestResult.serviceDisabled) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.prayerLocationServicesDisabled),
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                );
              } else if (result == LocationRequestResult.success && mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.prayerLocationUpdated),
                    duration: const Duration(seconds: 2),
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                );
              }
            },
            icon: const Icon(LucideIcons.mapPin, size: 18),
            label: Text(AppLocalizations.of(context)!.prayerUseCurrentLocation),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await ref.read(locationNotifierProvider.notifier).requestLocation();
              if (mounted && result == LocationRequestResult.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.prayerLocationRefreshed),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            label: Text(AppLocalizations.of(context)!.prayerRefreshLocation),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final v = _addressController.text.trim();
                    if (v.isNotEmpty) {
                      ref.read(manualAddressProvider.notifier).state = v;
                    }
                  },
                  icon: const Icon(LucideIcons.edit, size: 18),
                  label: Text(AppLocalizations.of(context)!.prayerUseAddress),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
