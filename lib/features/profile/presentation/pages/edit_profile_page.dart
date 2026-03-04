import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme_provider.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/profile/presentation/profile_mock_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shahadaDateController = TextEditingController();
  DateTime? _selectedShahadaDate;
  String _userInitial = ProfileMockData.userInitial;

  @override
  void initState() {
    super.initState();
    _nameController.text = ProfileMockData.userName;
    if (ProfileMockData.shahadaDate != null) {
      // If we had a date, we'd parse it here
      _shahadaDateController.text = '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shahadaDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        _buildProfilePictureSection(colorScheme),
                        const SizedBox(height: AppSpacing.xl),
                        _buildNameField(colorScheme),
                        const SizedBox(height: AppSpacing.lg),
                        _buildShahadaDateField(context, colorScheme),
                        const SizedBox(height: AppSpacing.xl),
                        _buildSaveButton(context, colorScheme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withAlpha(128)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/profile');
              }
            },
            child: Text(
              'Cancel',
              style: AppTypography.body(color: colorScheme.onSurface),
            ),
          ),
          Text(
            'Edit Profile',
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          TextButton(
            onPressed: () => _saveProfile(context),
            child: Text(
              'Save',
              style: AppTypography.body(color: colorScheme.primary)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(ColorScheme colorScheme) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Show image picker options
            _showImagePickerOptions(context, colorScheme);
          },
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _userInitial,
                    style: AppTypography.displayLg(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 3),
                  ),
                  child: Icon(
                    LucideIcons.camera,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Tap to change photo',
          style: AppTypography.bodySm(color: colorScheme.onSurface.withAlpha(150)),
        ),
      ],
    );
  }

  Widget _buildNameField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: AppTypography.bodySm(color: colorScheme.onSurface)
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameController,
          style: AppTypography.body(color: colorScheme.onSurface),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _userInitial = value[0].toUpperCase();
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: AppTypography.body(color: colorScheme.onSurface.withAlpha(100)),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }

  Widget _buildShahadaDateField(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shahada Date (Optional)',
          style: AppTypography.bodySm(color: colorScheme.onSurface)
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          'When did you take your shahada?',
          style: AppTypography.caption(color: colorScheme.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _shahadaDateController,
          readOnly: true,
          style: AppTypography.body(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Select date',
            hintStyle: AppTypography.body(color: colorScheme.onSurface.withAlpha(100)),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            suffixIcon: _selectedShahadaDate != null
                ? IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 18,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedShahadaDate = null;
                        _shahadaDateController.clear();
                      });
                    },
                  )
                : Icon(
                    LucideIcons.calendar,
                    size: 20,
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
          ),
          onTap: () => _selectShahadaDate(context, colorScheme),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _saveProfile(context),
        icon: const Icon(LucideIcons.check, size: 20),
        label: const Text('Save Changes'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTypography.body().copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: Icon(LucideIcons.camera, color: colorScheme.onSurface),
                title: Text('Take Photo', style: AppTypography.body(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Camera functionality coming soon'),
                      ),
                  );
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: colorScheme.onSurface),
                title: Text('Choose from Gallery', style: AppTypography.body(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  // Implement gallery picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Gallery picker coming soon'),
                      ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectShahadaDate(BuildContext context, ColorScheme colorScheme) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedShahadaDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedShahadaDate = picked;
        _shahadaDateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  void _saveProfile(BuildContext context) {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your name'),
          backgroundColor: Theme.of(context).colorScheme.error,
          ),
      );
      return;
    }

    // Save profile data (in a real app, this would save to a provider or backend)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile saved successfully! ✓'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted && context.canPop()) {
        context.pop();
      } else {
        context.go('/profile');
      }
    });
  }
}
