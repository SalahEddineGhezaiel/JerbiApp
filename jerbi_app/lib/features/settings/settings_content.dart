import 'package:flutter/material.dart';
import '../../shared/constants/constants.dart';
import '../../shared/widgets/page_header.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PageHeader(title: AppStrings.settingsTitle),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  SizedBox(height: AppDimensions.spaceXXL),
                  _buildUserManagementSection(),
                  SizedBox(height: AppDimensions.spaceXXL),
                  _buildDataSection(),
                  SizedBox(height: AppDimensions.spaceXXL),
                  _buildAboutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSection(
      title: AppStrings.profileSection,
      children: [
        _buildProfileCard(),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.profileAvatarSize,
            height: AppDimensions.profileAvatarSize,
            decoration: BoxDecoration(
              color: AppColors.primaryWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.profileAvatarSize / 2),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: AppDimensions.iconSize + 6,
            ),
          ),
          SizedBox(width: AppDimensions.spaceL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.adminProfile,
                  style: AppTextStyles.h5.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  AppStrings.adminEmail,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  AppStrings.adminRole,
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagementSection() {
    return _buildSection(
      title: AppStrings.userManagementSection,
      children: [
        _buildSettingsTile(
          icon: Icons.group_outlined,
          title: AppStrings.manageAdmins,
          subtitle: AppStrings.manageAdminsSubtitle,
          onTap: () => _showUserManagementPage(),
        ),
        _buildSettingsTile(
          icon: Icons.admin_panel_settings_outlined,
          title: AppStrings.permissions,
          subtitle: AppStrings.permissionsSubtitle,
          onTap: () => _showPermissionsPage(),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      title: AppStrings.dataSection,
      children: [
        _buildSettingsTile(
          icon: Icons.file_download_outlined,
          title: AppStrings.exportData,
          subtitle: AppStrings.exportDataSubtitle,
          onTap: () => _showExportDialog(),
        ),
        _buildSettingsTile(
          icon: Icons.backup_outlined,
          title: AppStrings.backup,
          subtitle: AppStrings.backupSubtitle,
          onTap: () => _showBackupDialog(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: AppStrings.aboutSection,
      children: [
        _buildSettingsTile(
          icon: Icons.info_outlined,
          title: AppStrings.appVersionLabel,
          subtitle: AppStrings.appVersion,
        ),
        _buildSettingsTile(
          icon: Icons.logout_outlined,
          title: AppStrings.logout,
          subtitle: AppStrings.logoutSubtitle,
          titleColor: AppColors.error,
          onTap: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppDimensions.spaceXS, bottom: AppDimensions.spaceM),
          child: Text(
            title,
            style: AppTextStyles.h5.copyWith(color: AppColors.primary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackWithOpacity(0.05),
                blurRadius: AppDimensions.elevationL,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(AppDimensions.paddingS),
        decoration: BoxDecoration(
          color: AppColors.primaryWithOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(
          icon, 
          color: AppColors.primary, 
          size: AppDimensions.iconSizeS
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.h6.copyWith(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  // Dialog methods (placeholder implementations)
  void _showUserManagementPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.userManagementPlaceholder)),
    );
  }

  void _showPermissionsPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.permissionsPlaceholder)),
    );
  }

  void _showExportDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.exportPlaceholder)),
    );
  }

  void _showBackupDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.backupPlaceholder)),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          title: Text(
            AppStrings.logout,
            style: AppTextStyles.h6.copyWith(color: AppColors.error),
          ),
          content: Text(
            AppStrings.logoutConfirmation,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.cancel,
                style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.logoutPlaceholder)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
              ),
              child: Text(AppStrings.logout, style: AppTextStyles.buttonMedium),
            ),
          ],
        );
      },
    );
  }
}