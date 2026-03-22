import 'package:flutter/material.dart';
import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/settings_card.dart';
import 'package:flutter_app/design_system/widgets/settings_section_header.dart';
import 'package:flutter_app/design_system/widgets/settings_tile.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:flutter_app/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_app/features/settings/providers/settings_providers.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  /// Temporary: set to true to show Font Size in Appearance section.
  static const bool _showFontSizeSetting = false;
  /// Temporary: set to true to show Prayer Times section (Calculation Method, Madhab, Adjust Times).
  static const bool _showPrayerTimesSection = false;
  /// Temporary: set to true to show Privacy & Data section (Export, Delete All Data).
  static const bool _showPrivacyDataSection = false;

  // Notification toggles (local overrides; remote config provides defaults)
  bool _prayerReminders = true;
  bool _dailyLesson = true;
  bool _milestoneAlerts = true;

  // Prayer method display name (synced from remote default or user choice)
  String _calculationMethod = 'Egyptian General';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final id = ref.read(defaultPrayerMethodConfigProvider);
      final name = id < _prayerMethodNames.length ? _prayerMethodNames[id] : 'Egyptian General';
      setState(() => _calculationMethod = name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
          icon: Directionality.of(context) == TextDirection.rtl
              ? const Icon(LucideIcons.arrowRight)
              : const Icon(LucideIcons.arrowLeft),
        ),
        title: Text(l10n.settingsTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationsSection(l10n),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAppearanceSection(l10n),
                  if (_showPrayerTimesSection) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildPrayerTimesSection(l10n),
                  ],
                  if (_showPrivacyDataSection) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildPrivacyDataSection(l10n),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _buildAboutSection(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const List<String> _prayerMethodNames = [
    'Jafari', 'University of Islamic Sciences, Karachi', 'Muslim World League',
    'Umm Al-Qura', 'Egyptian General', 'Institute of Geophysics, Tehran',
    'ISNA', 'Gulf', 'Kuwait', 'Qatar', 'Singapore', 'Dubai', 'MoonsightingCommittee',
  ];

  Widget _buildNotificationsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsNotifications),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsTile(
                leading: const Icon(LucideIcons.bell),
                title: l10n.notificationSettings,
                subtitle: l10n.notificationsPrayerDesc,
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => context.push('/settings/notifications'),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(AppLocalizations l10n) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currentLocale = ref.watch(localeControllerProvider);
    final currentCode = currentLocale.languageCode;

    final languageLabels = {
      'en': l10n.languageEnglish,
      'ar': l10n.languageArabic,
    };
    final currentLabel = languageLabels[currentCode] ?? currentCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsAppearance),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsNavigationTile(
                icon: LucideIcons.languages,
                title: l10n.settingsLanguage,
                subtitle: currentLabel,
                onTap: () => _showLanguagePickerSheet(l10n, currentCode, languageLabels),
              ),
              SettingsSwitchTile(
                icon: isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                title: l10n.settingsDarkMode,
                subtitle: l10n.settingsUseDarkTheme,
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? l10n.darkModeEnabled : l10n.lightModeEnabled,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                showDivider: _showFontSizeSetting,
              ),
              if (_showFontSizeSetting)
                SettingsDropdownTile(
                  icon: LucideIcons.type,
                  title: l10n.settingsFontSize,
                  subtitle: l10n.settingsFontSizeSubtitle,
                  value: ref.watch(settingsNotifierProvider).fontSize.name,
                  options: FontSize.values.map((e) => e.name).toList(),
                  optionLabels: {
                    FontSize.small.name: l10n.settingsFontSizeSmall,
                    FontSize.medium.name: l10n.settingsFontSizeMedium,
                    FontSize.large.name: l10n.settingsFontSizeLarge,
                    FontSize.extraLarge.name: l10n.settingsFontSizeExtraLarge,
                  },
                  onChanged: (value) {
                    if (value != null) {
                      final size = FontSize.values.byName(value);
                      ref.read(settingsNotifierProvider.notifier).setFontSize(size);
                    }
                  },
                  showDivider: false,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimesSection(AppLocalizations l10n) {
    final methodId = ref.watch(defaultPrayerMethodConfigProvider);
    final madhabId = ref.watch(defaultMadhabConfigProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsPrayerTimes),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsDropdownTile(
                icon: LucideIcons.clock,
                title: l10n.settingsCalculationMethod,
                subtitle: 'Default from app config (id: $methodId). User override via /me/settings when backend supports it.',
                value: _calculationMethod,
                options: _prayerMethodNames,
                onChanged: (value) {
                  if (value != null) setState(() => _calculationMethod = value);
                },
              ),
              SettingsInfoTile(
                title: l10n.settingsDefaultMadhab,
                value: 'Id: $madhabId (0=Shafi, 1=Hanafi)',
              ),
              SettingsNavigationTile(
                title: l10n.settingsAdjustTimes,
                subtitle: l10n.settingsAdjustTimesSubtitle,
                onTap: () => _showAdjustTimesDialog(l10n),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyDataSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsPrivacyData),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsNavigationTile(
                icon: LucideIcons.download,
                title: l10n.settingsExportMyData,
                subtitle: l10n.settingsExportMyDataSubtitle,
                onTap: () => _showExportDataDialog(l10n),
              ),
              SettingsNavigationTile(
                icon: LucideIcons.trash2,
                iconColor: AppColors.error,
                title: l10n.settingsDeleteAllData,
                titleColor: AppColors.error,
                subtitle: l10n.settingsDeleteAllDataSubtitle,
                onTap: () => _showDeleteConfirmation(l10n),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations l10n) {
    final appName = ref.watch(appNameConfigProvider);
    final appVersion = ref.watch(appVersionConfigProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsAbout),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsInfoTile(
                title: l10n.settingsApp,
                value: appName,
              ),
              SettingsInfoTile(
                title: l10n.settingsVersion,
                value: appVersion,
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.shield,
                title: l10n.settingsPrivacyPolicy,
                onTap: () => _openUrl(l10n, 'https://noorjourney.app/privacy'),
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.helpCircle,
                title: l10n.settingsHelpSupport,
                onTap: () => _openUrl(l10n, 'https://noorjourney.app/support'),
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.messageSquare,
                title: l10n.settingsSendFeedback,
                onTap: () => _showFeedbackDialog(l10n),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLanguagePickerSheet(
    AppLocalizations l10n,
    String currentCode,
    Map<String, String> labels,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final options = [
      ('en', labels['en'] ?? 'English'),
      ('ar', labels['ar'] ?? 'العربية'),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.settingsLanguage,
                      style: AppTypography.h3(color: colorScheme.onSurface),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...options.map((entry) {
                  final (code, label) = entry;
                  final isSelected = code == currentCode;
                  return InkWell(
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      if (!isSelected) {
                        await ref
                            .read(localeControllerProvider.notifier)
                            .setLocale(Locale(code));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: AppTypography.body(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ).copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              LucideIcons.check,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          l10n.dialogDeleteAllDataTitle,
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Text(
          l10n.dialogDeleteAllDataContent,
          style: AppTypography.bodySm(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.actionCancel,
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(l10n.dialogDataDeletedSuccess);
              context.go('/');
            },
            child: Text(
              l10n.actionDelete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdjustTimesDialog(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.dialogAdjustTimesTitle,
                style: AppTypography.h3(color: colorScheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.dialogAdjustTimesContent,
                style: AppTypography.bodySm(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildPrayerAdjustRow('Fajr', 0, colorScheme),
              _buildPrayerAdjustRow('Dhuhr', 0, colorScheme),
              _buildPrayerAdjustRow('Asr', 0, colorScheme),
              _buildPrayerAdjustRow('Maghrib', 0, colorScheme),
              _buildPrayerAdjustRow('Isha', 0, colorScheme),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSnackBar(l10n.dialogPrayerTimesAdjusted);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(l10n.actionSaveChanges),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerAdjustRow(String prayer, int adjustment, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              prayer,
              style: AppTypography.bodySm(color: colorScheme.onSurface),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: colorScheme.outline.withAlpha(128),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.minus, size: 16),
                  color: colorScheme.onSurface,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                Text(
                  '${adjustment >= 0 ? '+' : ''}$adjustment min',
                  style: AppTypography.bodySm(color: colorScheme.onSurface),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.plus, size: 16),
                  color: colorScheme.onSurface,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          l10n.dialogExportTitle,
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dialogExportContent,
              style: AppTypography.bodySm(color: colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildExportItem('Journey progress', colorScheme),
            _buildExportItem('Lesson reflections', colorScheme),
            _buildExportItem('Saved duas and hadith', colorScheme),
            _buildExportItem('Prayer tracking history', colorScheme),
            _buildExportItem('Account settings', colorScheme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.actionCancel,
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(l10n.dialogExportPreparing);
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  _showSnackBar(l10n.dialogExportSuccess);
                }
              });
            },
            child: Text(
              l10n.actionExport,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportItem(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(LucideIcons.check, size: 14, color: AppColors.accentGreen),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.caption(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final feedbackController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          l10n.dialogFeedbackTitle,
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.dialogFeedbackContent,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.dialogFeedbackHint,
                hintStyle: AppTypography.bodySm(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withAlpha(128),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withAlpha(128),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.sm),
              ),
              style: AppTypography.bodySm(color: colorScheme.onSurface),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.actionCancel,
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (feedbackController.text.isNotEmpty) {
                _showSnackBar(l10n.dialogFeedbackThanks);
              }
            },
            child: Text(
              l10n.actionSend,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _openUrl(AppLocalizations l10n, String url) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          l10n.dialogExternalLinkTitle,
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dialogExternalLinkContent,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(128),
                ),
              ),
              child: Text(
                url,
                style: AppTypography.caption(color: colorScheme.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.actionCancel,
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(l10n.dialogOpeningInBrowser);
            },
            child: Text(
              l10n.actionOpen,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
