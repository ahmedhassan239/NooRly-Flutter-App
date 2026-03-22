/// Notification Settings Page
///
/// Full settings screen for all notification preferences.
/// Saves to API and reschedules local notifications on save.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/notifications/schedulers/prayer_reminder_scheduler.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/settings_card.dart';
import 'package:flutter_app/design_system/widgets/settings_section_header.dart';
import 'package:flutter_app/design_system/widgets/settings_tile.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import 'package:flutter_app/features/notifications/providers/notification_preferences_providers.dart';
import 'package:flutter_app/features/prayer/providers/prayer_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  static const routeName = '/settings/notifications';

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  NotificationPreferencesEntity? _prefs;
  bool _loading = true;
  bool _saving = false;
  // Cached future for permission banner — recreated only when needed, not on every build.
  late Future<bool> _notificationsEnabledFuture;

  @override
  void initState() {
    super.initState();
    _notificationsEnabledFuture = NotificationService.instance.areNotificationsEnabled();
    _loadPrefs();
  }

  void _refreshPermissionBanner() {
    if (mounted) {
      setState(() {
        _notificationsEnabledFuture =
            NotificationService.instance.areNotificationsEnabled();
      });
    }
  }

  Future<void> _loadPrefs() async {
    final repo =
        ref.read(notificationPreferencesRepositoryProvider);
    final loaded = await repo.getLocalPreferences();
    if (mounted) {
      setState(() {
        _prefs = loaded;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final prefs = _prefs;
    if (prefs == null) return;

    setState(() => _saving = true);

    try {
      final notifier = ref.read(notificationPreferencesNotifierProvider.notifier);
      await notifier.update(prefs);

      if (!kIsWeb) {
        // Build prayer inputs from the live prayer times provider
        final prayerAsync = ref.read(todayPrayerListProvider);
        final prayerList = prayerAsync.valueOrNull ?? [];
        final prayerInputs = prayerList
            .where((p) => p.timeAsDateTime != null)
            .map((p) => PrayerScheduleInput(
                  name: _normalizePrayerName(p.name),
                  time: p.timeAsDateTime!,
                ))
            .where((i) => i.name.isNotEmpty)
            .toList();

        if (kDebugMode) {
          debugPrint('');
          debugPrint('══════════════════════════════════════════════');
          debugPrint('[NotificationSettings] ── SAVING PREFERENCES ──');
          debugPrint('[NotificationSettings] prayerEnabled       : ${prefs.prayerEnabled}');
          debugPrint('[NotificationSettings] prayer inputs found : ${prayerInputs.length}');
          debugPrint('[NotificationSettings] lessonEnabled       : ${prefs.lessonEnabled}');
          debugPrint('[NotificationSettings] morningAdhkar       : ${prefs.morningAdhkarEnabled}');
          debugPrint('[NotificationSettings] eveningAdhkar       : ${prefs.eveningAdhkarEnabled}');
          debugPrint('[NotificationSettings] sleepAdhkar         : ${prefs.sleepAdhkarEnabled}');
          debugPrint('[NotificationSettings] randomDhikr         : ${prefs.randomDhikrEnabled} (×${prefs.randomDhikrFrequency})');
          debugPrint('[NotificationSettings] specialOccasions    : ${prefs.specialOccasionsEnabled}');
          debugPrint('[NotificationSettings] calling rescheduleAll()...');
          debugPrint('══════════════════════════════════════════════');
        }

        final appLocale = ref.read(localeControllerProvider).languageCode;
        await NotificationService.instance.rescheduleAll(
          prefs,
          prayerInputs: prayerInputs.isNotEmpty ? prayerInputs : null,
          appLocale: appLocale,
        );

        if (kDebugMode) {
          final status = await NotificationService.instance.debugStatus();
          final totalPending = status['pending_count'] as int;
          debugPrint('');
          debugPrint('══════════════════════════════════════════════');
          debugPrint('[NotificationSettings] ── POST-SAVE RESULT ──');
          debugPrint('[NotificationSettings] rescheduleAll() completed');
          debugPrint('[NotificationSettings] total pending scheduled: $totalPending');
          debugPrint('══════════════════════════════════════════════');
          debugPrint('');
        }
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.notificationsSaveSuccess)),
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[NotificationSettings] Save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save settings')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _normalizePrayerName(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('fajr') || lower.contains('فجر')) return 'fajr';
    if (lower.contains('dhuhr') || lower.contains('ظهر') || lower.contains('zuhr')) return 'dhuhr';
    if (lower.contains('asr') || lower.contains('عصر')) return 'asr';
    if (lower.contains('maghrib') || lower.contains('مغرب')) return 'maghrib';
    if (lower.contains('isha') || lower.contains('عشاء')) return 'isha';
    return '';
  }

  void _update(NotificationPreferencesEntity updated) {
    setState(() => _prefs = updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/settings'),
          icon: Directionality.of(context) == TextDirection.rtl
              ? const Icon(LucideIcons.arrowRight)
              : const Icon(LucideIcons.arrowLeft),
        ),
        title: Text(l10n.notificationSettings),
        centerTitle: false,
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!kIsWeb) _buildPermissionBanner(l10n, colorScheme),
                        _buildInAppInboxCard(l10n, colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildPrayerSection(l10n),
                        const SizedBox(height: AppSpacing.lg),
                        _buildLessonSection(l10n),
                        const SizedBox(height: AppSpacing.lg),
                        _buildDhikrSection(l10n),
                        const SizedBox(height: AppSpacing.lg),
                        _buildMilestonesSection(l10n),
                        const SizedBox(height: AppSpacing.lg),
                        _buildQuietHoursSection(l10n),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSoundSection(l10n),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInAppInboxCard(
      AppLocalizations l10n, ColorScheme colorScheme) {
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.push('/notifications/inbox'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(LucideIcons.inbox, color: colorScheme.primary, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notificationInboxOpen,
                      style: AppTypography.h3(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.notificationInboxSubtitle,
                      style: AppTypography.bodySm(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? LucideIcons.chevronLeft
                    : LucideIcons.chevronRight,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionBanner(
      AppLocalizations l10n, ColorScheme colorScheme) {
    // Uses _notificationsEnabledFuture cached in initState / _refreshPermissionBanner()
    // so it does NOT create a new Future on every widget rebuild.
    return FutureBuilder<bool>(
      future: _notificationsEnabledFuture,
      builder: (ctx, snap) {
        if (snap.data == true) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.bellOff,
                  color: colorScheme.onErrorContainer, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l10n.notificationsPermissionRequired,
                  style: AppTypography.bodySm(
                      color: colorScheme.onErrorContainer),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.tonal(
                onPressed: () async {
                  await NotificationService.instance.requestPermission();
                  _refreshPermissionBanner();
                },
                child: Text(l10n.notificationsEnableButton),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // Prayer section
  // =========================================================================

  Widget _buildPrayerSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsPrayer),
        SettingsCard(
          children: [
            SettingsTile(
              leading: const Icon(LucideIcons.bell),
              title: l10n.notificationsPrayerAll,
              subtitle: l10n.notificationsPrayerDesc,
              trailing: Switch(
                value: prefs.prayerEnabled,
                onChanged: (v) => _update(prefs.copyWith(prayerEnabled: v)),
              ),
            ),
            if (prefs.prayerEnabled) ...[
              _switchTile(
                icon: LucideIcons.sun,
                title: l10n.notificationsFajr,
                value: prefs.fajrEnabled,
                onChanged: (v) => _update(prefs.copyWith(fajrEnabled: v)),
              ),
              _switchTile(
                icon: LucideIcons.sun,
                title: l10n.notificationsDhuhr,
                value: prefs.dhuhrEnabled,
                onChanged: (v) => _update(prefs.copyWith(dhuhrEnabled: v)),
              ),
              _switchTile(
                icon: LucideIcons.sun,
                title: l10n.notificationsAsr,
                value: prefs.asrEnabled,
                onChanged: (v) => _update(prefs.copyWith(asrEnabled: v)),
              ),
              _switchTile(
                icon: LucideIcons.sunset,
                title: l10n.notificationsMaghrib,
                value: prefs.maghribEnabled,
                onChanged: (v) => _update(prefs.copyWith(maghribEnabled: v)),
              ),
              _switchTile(
                icon: LucideIcons.moon,
                title: l10n.notificationsIsha,
                value: prefs.ishaEnabled,
                onChanged: (v) => _update(prefs.copyWith(ishaEnabled: v)),
              ),
              _buildTimingMode(l10n, prefs),
              if (prefs.prayerTimingMode != PrayerTimingMode.at)
                _buildOffsetSlider(l10n, prefs),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTimingMode(AppLocalizations l10n, NotificationPreferencesEntity prefs) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.notificationsTimingMode,
              style: AppTypography.bodySm(
                  color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<PrayerTimingMode>(
            segments: [
              ButtonSegment(
                value: PrayerTimingMode.before,
                label: Text(l10n.notificationsTimingBefore,
                    style: const TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: PrayerTimingMode.at,
                label: Text(l10n.notificationsTimingAt,
                    style: const TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: PrayerTimingMode.after,
                label: Text(l10n.notificationsTimingAfter,
                    style: const TextStyle(fontSize: 12)),
              ),
            ],
            selected: {prefs.prayerTimingMode},
            onSelectionChanged: (s) =>
                _update(prefs.copyWith(prayerTimingMode: s.first)),
          ),
        ],
      ),
    );
  }

  Widget _buildOffsetSlider(AppLocalizations l10n, NotificationPreferencesEntity prefs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Text(
            l10n.notificationsOffsetMinutes(prefs.prayerOffsetMinutes),
            style: AppTypography.bodySm(
                color: Theme.of(context).colorScheme.onSurface),
          ),
          Expanded(
            child: Slider(
              min: 5,
              max: 30,
              divisions: 5,
              value: prefs.prayerOffsetMinutes.clamp(5, 30).toDouble(),
              label: '${prefs.prayerOffsetMinutes} min',
              onChanged: (v) =>
                  _update(prefs.copyWith(prayerOffsetMinutes: v.round())),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Lesson section
  // =========================================================================

  Widget _buildLessonSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsLesson),
        SettingsCard(
          children: [
            _switchTile(
              icon: LucideIcons.bookOpen,
              title: l10n.notificationsLessonMorning,
              subtitle: l10n.notificationsLessonDesc,
              value: prefs.lessonEnabled,
              onChanged: (v) => _update(prefs.copyWith(lessonEnabled: v)),
            ),
            if (prefs.lessonEnabled) ...[
              SettingsTile(
                leading: const Icon(LucideIcons.clock),
                title: l10n.notificationsLessonTime,
                trailing: Text(
                  _formatTime(prefs.effectiveLessonTime),
                  style: AppTypography.body(
                      color:
                          Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _pickTime(
                  initial: prefs.effectiveLessonTime,
                  onPicked: (t) => _update(prefs.copyWith(lessonTime: t)),
                ),
              ),
              _switchTile(
                icon: LucideIcons.clock,
                title: l10n.notificationsLessonEvening,
                value: prefs.lessonEveningReminderEnabled,
                onChanged: (v) =>
                    _update(prefs.copyWith(lessonEveningReminderEnabled: v)),
              ),
              _switchTile(
                icon: LucideIcons.flame,
                title: l10n.notificationsStreak,
                value: prefs.streakReminderEnabled,
                onChanged: (v) =>
                    _update(prefs.copyWith(streakReminderEnabled: v)),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Dhikr section
  // =========================================================================

  Widget _buildDhikrSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsDhikr),
        SettingsCard(
          children: [
            _switchTile(
              icon: LucideIcons.sun,
              title: l10n.notificationsMorningAdhkar,
              subtitle: l10n.notificationsDhikrDesc,
              value: prefs.morningAdhkarEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(morningAdhkarEnabled: v)),
            ),
            _switchTile(
              icon: LucideIcons.moon,
              title: l10n.notificationsEveningAdhkar,
              value: prefs.eveningAdhkarEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(eveningAdhkarEnabled: v)),
            ),
            _switchTile(
              icon: LucideIcons.bed,
              title: l10n.notificationsSleepAdhkar,
              value: prefs.sleepAdhkarEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(sleepAdhkarEnabled: v)),
            ),
            if (prefs.sleepAdhkarEnabled)
              SettingsTile(
                leading: const Icon(LucideIcons.clock),
                title: l10n.notificationsSleepAdhkarTime,
                trailing: Text(
                  _formatTime(prefs.effectiveSleepAdhkarTime),
                  style: AppTypography.body(
                      color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _pickTime(
                  initial: prefs.effectiveSleepAdhkarTime,
                  onPicked: (t) => _update(prefs.copyWith(sleepAdhkarTime: t)),
                ),
              ),
            _switchTile(
              icon: LucideIcons.heart,
              title: l10n.notificationsRandomDhikr,
              value: prefs.randomDhikrEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(randomDhikrEnabled: v)),
            ),
            if (prefs.randomDhikrEnabled)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      '${l10n.notificationsRandomDhikrFrequency}: ${prefs.randomDhikrFrequency}x',
                      style: AppTypography.bodySm(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 5,
                        divisions: 4,
                        value: prefs.randomDhikrFrequency.toDouble(),
                        label: '${prefs.randomDhikrFrequency}',
                        onChanged: (v) => _update(
                            prefs.copyWith(randomDhikrFrequency: v.round())),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Milestones & Occasions
  // =========================================================================

  Widget _buildMilestonesSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsMilestones),
        SettingsCard(
          children: [
            _switchTile(
              icon: LucideIcons.trophy,
              title: l10n.notificationsAchievements,
              subtitle: l10n.notificationsMilestonesDesc,
              value: prefs.milestoneEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(milestoneEnabled: v)),
            ),
            _switchTile(
              icon: LucideIcons.star,
              title: l10n.notificationsOccasions,
              value: prefs.specialOccasionsEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(specialOccasionsEnabled: v)),
            ),
            _switchTile(
              icon: LucideIcons.heart,
              title: l10n.notificationsSupportReminders,
              value: prefs.supportRemindersEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(supportRemindersEnabled: v)),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Quiet Hours
  // =========================================================================

  Widget _buildQuietHoursSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsQuietHours),
        SettingsCard(
          children: [
            _switchTile(
              icon: LucideIcons.moonStar,
              title: l10n.notificationsQuietHoursEnable,
              subtitle: l10n.notificationsQuietHoursDesc,
              value: prefs.quietHoursEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(quietHoursEnabled: v)),
            ),
            if (prefs.quietHoursEnabled) ...[
              SettingsTile(
                leading: const Icon(LucideIcons.moon),
                title: l10n.notificationsQuietStart,
                trailing: Text(
                  _formatTime(prefs.effectiveQuietStart),
                  style: AppTypography.body(
                      color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _pickTime(
                  initial: prefs.effectiveQuietStart,
                  onPicked: (t) =>
                      _update(prefs.copyWith(quietHoursStart: t)),
                ),
              ),
              SettingsTile(
                leading: const Icon(LucideIcons.sun),
                title: l10n.notificationsQuietEnd,
                trailing: Text(
                  _formatTime(prefs.effectiveQuietEnd),
                  style: AppTypography.body(
                      color: Theme.of(context).colorScheme.primary),
                ),
                onTap: () => _pickTime(
                  initial: prefs.effectiveQuietEnd,
                  onPicked: (t) =>
                      _update(prefs.copyWith(quietHoursEnd: t)),
                ),
                showDivider: false,
              ),
            ],
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Sound & Vibration + Language
  // =========================================================================

  Widget _buildSoundSection(AppLocalizations l10n) {
    final prefs = _prefs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.notificationsSoundVibration),
        SettingsCard(
          children: [
            _switchTile(
              icon: LucideIcons.volume2,
              title: l10n.notificationsSound,
              value: prefs.notificationSound != 'none',
              onChanged: (v) => _update(
                  prefs.copyWith(notificationSound: v ? null : 'none')),
            ),
            _switchTile(
              icon: LucideIcons.vibrate,
              title: l10n.notificationsVibration,
              value: prefs.vibrationEnabled,
              onChanged: (v) =>
                  _update(prefs.copyWith(vibrationEnabled: v)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SettingsSectionHeader(title: l10n.notificationsLanguage),
        SettingsCard(
          children: [
            _buildLanguageTile(
                l10n, prefs, NotificationLanguageMode.appLocale,
                l10n.notificationsLangAppLocale),
            _buildLanguageTile(
                l10n, prefs, NotificationLanguageMode.arabic,
                l10n.notificationsLangArabic),
            _buildLanguageTile(
                l10n, prefs, NotificationLanguageMode.english,
                l10n.notificationsLangEnglish),
            _buildLanguageTile(
                l10n, prefs, NotificationLanguageMode.both,
                l10n.notificationsLangBoth, isLast: true),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageTile(
    AppLocalizations l10n,
    NotificationPreferencesEntity prefs,
    NotificationLanguageMode mode,
    String label, {
    bool isLast = false,
  }) {
    return SettingsTile(
      title: label,
      trailing: prefs.languageMode == mode
          ? Icon(LucideIcons.check,
              color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () => _update(prefs.copyWith(languageMode: mode)),
      showDivider: !isLast,
    );
  }

  // =========================================================================
  // Helpers
  // =========================================================================

  Widget _switchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SettingsTile(
      leading: Icon(icon),
      title: title,
      subtitle: subtitle,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _pickTime({
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) onPicked(picked);
  }
}
