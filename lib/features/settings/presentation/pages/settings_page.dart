import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/settings_card.dart';
import 'package:flutter_app/design_system/widgets/settings_section_header.dart';
import 'package:flutter_app/design_system/widgets/settings_tile.dart';
import 'package:flutter_app/features/remote_config/providers/remote_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Notification toggles (local overrides; remote config provides defaults)
  bool _prayerReminders = true;
  bool _dailyLesson = true;
  bool _milestoneAlerts = true;

  // Appearance settings
  String _fontSize = 'Medium';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
          icon: Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Settings'),
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
                  _buildNotificationsSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAppearanceSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPrayerTimesSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPrivacyDataSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAboutSection(),
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

  Widget _buildNotificationsSection() {
    final notificationsMaster = ref.watch(notificationsEnabledConfigProvider);
    final prayerDefault = ref.watch(prayerNotificationsDefaultProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Notifications'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: LucideIcons.bell,
                title: 'Notifications',
                subtitle: 'Master switch from app config (notifications_enabled)',
                value: notificationsMaster,
                onChanged: (_) {}, // Read-only: set in admin
              ),
              SettingsSwitchTile(
                icon: LucideIcons.bell,
                title: 'Prayer Reminders',
                subtitle: 'Get notified before each prayer (default from config: ${prayerDefault ? "on" : "off"})',
                value: notificationsMaster ? _prayerReminders : false,
                onChanged: (value) {
                  if (!notificationsMaster) return;
                  setState(() => _prayerReminders = value);
                },
              ),
              SettingsSwitchTile(
                icon: LucideIcons.bell,
                title: 'Daily Lesson',
                subtitle: 'Reminder to complete daily lesson',
                value: _dailyLesson,
                onChanged: (value) => setState(() => _dailyLesson = value),
              ),
              SettingsSwitchTile(
                icon: LucideIcons.bell,
                title: 'Milestone Alerts',
                subtitle: 'Celebrate when you reach milestones',
                value: _milestoneAlerts,
                onChanged: (value) => setState(() => _milestoneAlerts = value),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final defaultLocaleFromConfig = ref.watch(defaultLocaleConfigProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentLocaleCode = currentLocale.languageCode;
    final localeOptions = supportedLocales.isEmpty ? ['en'] : supportedLocales;
    final displayLocale = currentLocaleCode.isEmpty ? defaultLocaleFromConfig : currentLocaleCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Appearance'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsDropdownTile(
                title: 'Language',
                subtitle: 'Supported: ${localeOptions.join(", ")} (default: $defaultLocaleFromConfig)',
                value: displayLocale,
                options: localeOptions,
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    ref.read(localeProvider.notifier).state = Locale(value);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language: $value'), duration: const Duration(seconds: 2)),
                      );
                    }
                  }
                },
              ),
              SettingsSwitchTile(
                icon: isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Dark mode enabled 🌙' : 'Light mode enabled ☀️',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              SettingsDropdownTile(
                title: 'Font Size',
                subtitle: 'Adjust text size',
                value: _fontSize,
                options: ['Small', 'Medium', 'Large'],
                onChanged: (value) {
                  if (value != null) setState(() => _fontSize = value);
                },
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimesSection() {
    final methodId = ref.watch(defaultPrayerMethodConfigProvider);
    final madhabId = ref.watch(defaultMadhabConfigProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Prayer Times'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsDropdownTile(
                icon: LucideIcons.clock,
                title: 'Calculation Method',
                subtitle: 'Default from app config (id: $methodId). User override via /me/settings when backend supports it.',
                value: _calculationMethod,
                options: _prayerMethodNames,
                onChanged: (value) {
                  if (value != null) setState(() => _calculationMethod = value);
                },
              ),
              SettingsInfoTile(
                title: 'Default Madhab',
                value: 'Id: $madhabId (0=Shafi, 1=Hanafi)',
              ),
              SettingsNavigationTile(
                title: 'Adjust Times',
                subtitle: 'Fine-tune prayer times ±5 min',
                onTap: () => _showAdjustTimesDialog(),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'Privacy & Data'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsNavigationTile(
                icon: LucideIcons.download,
                title: 'Export My Data',
                subtitle: 'Download all your progress',
                onTap: () => _showExportDataDialog(),
              ),
              SettingsNavigationTile(
                icon: LucideIcons.trash2,
                iconColor: AppColors.error,
                title: 'Delete All Data',
                titleColor: AppColors.error,
                subtitle: 'Permanently delete everything',
                onTap: () => _showDeleteConfirmation(),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    final appName = ref.watch(appNameConfigProvider);
    final appVersion = ref.watch(appVersionConfigProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: 'About'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SettingsCard(
            children: [
              SettingsInfoTile(
                title: 'App',
                value: appName,
              ),
              SettingsInfoTile(
                title: 'Version',
                value: appVersion,
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.shield,
                title: 'Privacy Policy',
                onTap: () => _openUrl('https://noorjourney.app/privacy'),
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.helpCircle,
                title: 'Help & Support',
                onTap: () => _openUrl('https://noorjourney.app/support'),
              ),
              SettingsExternalLinkTile(
                icon: LucideIcons.messageSquare,
                title: 'Send Feedback',
                onTap: () => _showFeedbackDialog(),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          'Delete All Data',
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Text(
          'This will permanently delete all your progress, reflections, and saved content. This action cannot be undone.',
          style: AppTypography.bodySm(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('All data deleted successfully');
              context.go('/');
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdjustTimesDialog() {
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
                'Adjust Prayer Times',
                style: AppTypography.h3(color: colorScheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Fine-tune individual prayer times by ±5 minutes',
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
                    _showSnackBar('Prayer times adjusted');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Save Changes'),
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
                  icon: Icon(LucideIcons.minus, size: 16),
                  color: colorScheme.onSurface,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                Text(
                  '${adjustment >= 0 ? '+' : ''}$adjustment min',
                  style: AppTypography.bodySm(color: colorScheme.onSurface),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(LucideIcons.plus, size: 16),
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

  void _showExportDataDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          'Export My Data',
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your data export will include:',
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
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Preparing your data export...');
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  _showSnackBar('Data exported successfully! Check your downloads.');
                }
              });
            },
            child: Text(
              'Export',
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

  void _showFeedbackDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    final feedbackController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          'Send Feedback',
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "We'd love to hear from you! Share your thoughts, suggestions, or report issues.",
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
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
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (feedbackController.text.isNotEmpty) {
                _showSnackBar('Thank you for your feedback! 💚');
              }
            },
            child: Text(
              'Send',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        title: Text(
          'External Link',
          style: AppTypography.h3(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will open in your browser:',
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
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Opening in browser...');
            },
            child: Text(
              'Open',
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
