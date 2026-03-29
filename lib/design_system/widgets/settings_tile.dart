import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Reusable tile widget for Settings items
/// Ensures consistent height, alignment, and styling
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    this.leading,
    this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    super.key,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Leading icon/widget
          if (leading != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: Center(child: leading!),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          // Title and subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTypography.bodySm(
                      color: titleColor ?? colorScheme.onSurface,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTypography.caption(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Trailing: Switches need intrinsic width; Icons stay in a tight box for
          // vertical alignment with the title row. Other widgets (time text, dropdown
          // chips, etc.) must not be forced into 24×24 — that clips content.
          if (trailing != null)
            if (trailing is Switch)
              trailing!
            else if (trailing is Icon)
              SizedBox(
                width: 24,
                height: 24,
                child: Center(child: trailing!),
              )
            else
              Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
                child: trailing!,
              ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            if (showDivider)
              Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outline.withAlpha(128),
                indent: leading != null ? 48 : AppSpacing.md,
              ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outline.withAlpha(128),
            indent: leading != null ? 48 : AppSpacing.md,
          ),
      ],
    );
  }
}

/// Settings tile with switch
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
    super.key,
  });

  final IconData? icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsTile(
      leading: icon != null
          ? Icon(
              icon,
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            )
          : null,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
        activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
        inactiveThumbColor: colorScheme.onSurface.withValues(alpha: 0.4),
        inactiveTrackColor: colorScheme.outlineVariant,
      ),
      showDivider: showDivider,
    );
  }
}

/// Settings tile with dropdown
class SettingsDropdownTile extends StatelessWidget {
  const SettingsDropdownTile({
    this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
    this.optionLabels,
    this.showDivider = true,
    super.key,
  });

  final IconData? icon;
  final String title;
  final String subtitle;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  /// Optional map of option value → display label.
  /// When provided, uses the label for display; otherwise shows the raw option value.
  final Map<String, String>? optionLabels;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveValue = options.contains(value) ? value : (options.isNotEmpty ? options.first : value);
    final selectedLabel = optionLabels?[effectiveValue] ?? effectiveValue;

    return SettingsTile(
      leading: icon != null
          ? Icon(
              icon,
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            )
          : null,
      title: title,
      subtitle: subtitle,
      trailing: Container(
        constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: colorScheme.outline,
          ),
        ),
        child: DropdownButton<String>(
          value: effectiveValue,
          onChanged: onChanged,
          underline: const SizedBox(),
          isDense: true,
          isExpanded: true,
          icon: Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: colorScheme.onSurface,
          ),
          style: AppTypography.bodySm(color: colorScheme.onSurface),
          dropdownColor: colorScheme.surfaceContainerHighest,
          items: options.map((option) {
            final label = optionLabels?[option] ?? option;
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                label,
                style: AppTypography.bodySm(color: colorScheme.onSurface),
              ),
            );
          }).toList(),
        ),
      ),
      showDivider: showDivider,
    );
  }
}

/// Settings tile with navigation (chevron right)
class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.titleColor,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsTile(
      leading: icon != null
          ? Icon(
              icon,
              size: 20,
              color: iconColor ?? colorScheme.onSurface.withValues(alpha: 0.7),
            )
          : null,
      title: title,
      subtitle: subtitle,
      titleColor: titleColor,
      trailing: Icon(
        LucideIcons.chevronRight,
        size: 20,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      onTap: onTap,
      showDivider: showDivider,
    );
  }
}

/// Settings tile with info display (no interaction)
class SettingsInfoTile extends StatelessWidget {
  const SettingsInfoTile({
    required this.title,
    required this.value,
    this.showDivider = true,
    super.key,
  });

  final String title;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsTile(
      title: title,
      trailing: Text(
        value,
        style: AppTypography.bodySm(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      showDivider: showDivider,
    );
  }
}

/// Settings tile with external link icon
class SettingsExternalLinkTile extends StatelessWidget {
  const SettingsExternalLinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsTile(
      leading: Icon(
        icon,
        size: 20,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      title: title,
      trailing: Icon(
        LucideIcons.externalLink,
        size: 18,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      onTap: onTap,
      showDivider: showDivider,
    );
  }
}
