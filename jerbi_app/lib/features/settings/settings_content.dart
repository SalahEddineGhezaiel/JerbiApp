import 'package:flutter/material.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 24),
                  _buildPreferencesSection(),
                  const SizedBox(height: 24),
                  _buildUserManagementSection(),
                  const SizedBox(height: 24),
                  _buildDataSection(),
                  const SizedBox(height: 24),
                  _buildAboutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF061138),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Paramètres',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          // Removed the back arrow button
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSection(
      title: 'Profil Administrateur',
      children: [
        _buildProfileCard(),
        const SizedBox(height: 16),
        _buildSettingsTile(
          icon: Icons.edit_outlined,
          title: 'Modifier le profil',
          subtitle: 'Nom, email, mot de passe',
          onTap: () => _showEditProfileDialog(),
        ),
        _buildSettingsTile(
          icon: Icons.security_outlined,
          title: 'Sécurité',
          subtitle: 'Changer le mot de passe',
          onTap: () => _showChangePasswordDialog(),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF061138).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF061138),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Principal',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF061138),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'admin@jerbi-events.com',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6C757D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Super Administrateur',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF28A745),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Préférences',
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Recevoir les notifications push',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: 'Mode sombre',
          subtitle: 'Activer le thème sombre',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        _buildSettingsTile(
          icon: Icons.language_outlined,
          title: 'Langue',
          subtitle: _selectedLanguage,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(),
        ),
      ],
    );
  }

  Widget _buildUserManagementSection() {
    return _buildSection(
      title: 'Gestion des Utilisateurs',
      children: [
        _buildSettingsTile(
          icon: Icons.group_outlined,
          title: 'Gérer les administrateurs',
          subtitle: 'Ajouter, modifier, supprimer',
          onTap: () => _showUserManagementPage(),
        ),
        _buildSettingsTile(
          icon: Icons.admin_panel_settings_outlined,
          title: 'Permissions',
          subtitle: 'Gérer les droits d\'accès',
          onTap: () => _showPermissionsPage(),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      title: 'Données',
      children: [
        _buildSettingsTile(
          icon: Icons.file_download_outlined,
          title: 'Exporter les données',
          subtitle: 'Télécharger les réservations',
          onTap: () => _showExportDialog(),
        ),
        _buildSettingsTile(
          icon: Icons.backup_outlined,
          title: 'Sauvegarde',
          subtitle: 'Sauvegarder la base de données',
          onTap: () => _showBackupDialog(),
        ),
        _buildSettingsTile(
          icon: Icons.restore_outlined,
          title: 'Restaurer',
          subtitle: 'Restaurer depuis une sauvegarde',
          onTap: () => _showRestoreDialog(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'À propos',
      children: [
        _buildSettingsTile(
          icon: Icons.info_outlined,
          title: 'Version de l\'application',
          subtitle: '1.0.0',
        ),
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Aide et support',
          subtitle: 'Documentation et contact',
          onTap: () => _showHelpDialog(),
        ),
        _buildSettingsTile(
          icon: Icons.logout_outlined,
          title: 'Se déconnecter',
          subtitle: 'Quitter l\'application',
          titleColor: Colors.red,
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
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF061138),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF061138).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF061138), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor ?? const Color(0xFF212529),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'SFPro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6C757D),
              ),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF061138).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF061138), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF212529),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'SFPro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6C757D),
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF061138),
      ),
    );
  }

  // Dialog methods (placeholder implementations)
  void _showEditProfileDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modifier le profil - À implémenter')),
    );
  }

  void _showChangePasswordDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changer le mot de passe - À implémenter')),
    );
  }

  void _showLanguageDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sélection de langue - À implémenter')),
    );
  }

  void _showUserManagementPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gestion des utilisateurs - À implémenter')),
    );
  }

  void _showPermissionsPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gestion des permissions - À implémenter')),
    );
  }

  void _showExportDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export des données - À implémenter')),
    );
  }

  void _showBackupDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sauvegarde - À implémenter')),
    );
  }

  void _showRestoreDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restauration - À implémenter')),
    );
  }

  void _showHelpDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aide et support - À implémenter')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Se déconnecter'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion - À implémenter')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}