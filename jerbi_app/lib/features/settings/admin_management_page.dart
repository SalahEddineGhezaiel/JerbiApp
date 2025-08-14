import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../shared/constants/constants.dart';
import '../../shared/utils/token_manager.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  List<Map<String, dynamic>> _admins = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  String _getApiUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000/api'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api'; // iOS simulator
    } else {
      return 'http://localhost:5000/api'; // Desktop
    }
  }

  Future<void> _loadAdmins() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiUrl = '${_getApiUrl()}/admin/list';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: TokenManager.getAuthHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> adminsJson = responseData['data']['admins'];
          setState(() {
            _admins = adminsJson.cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Failed to get admins';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          _errorMessage = 'Vous n\'avez pas les permissions nécessaires pour voir les administrateurs.';
          _isLoading = false;
        });
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Erreur lors de la récupération des administrateurs';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('TimeoutException')) {
          _errorMessage = 'Timeout: Le serveur met trop de temps à répondre';
        } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
          _errorMessage = 'Impossible de se connecter au serveur';
        } else {
          _errorMessage = 'Erreur de connexion: ${e.toString()}';
        }
        _isLoading = false;
      });
    }
  }

  String _formatLastLogin(String? lastLogin) {
    if (lastLogin == null) return 'Jamais connecté';
    
    try {
      final loginDate = DateTime.parse(lastLogin);
      final now = DateTime.now();
      final difference = now.difference(loginDate);
      
      if (difference.inDays > 0) {
        return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'À l\'instant';
      }
    } catch (e) {
      return 'Jamais connecté';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL, 
        vertical: AppDimensions.paddingL
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          // Title
          Expanded(
            child: Text(
              'Gestion des Administrateurs',
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppDimensions.spaceL),
          // Back button (left arrow on the right)
          Material(
            color: AppColors.primaryWithOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Container(
                width: AppDimensions.iconButtonSize,
                height: AppDimensions.iconButtonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: AppDimensions.iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Chargement des administrateurs...',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Erreur de chargement',
              style: AppTextStyles.h5.copyWith(color: AppColors.error),
            ),
            SizedBox(height: AppDimensions.spaceS),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: _loadAdmins,
              icon: Icon(Icons.refresh),
              label: Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (_admins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Aucun administrateur',
              style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              'Aucun autre administrateur trouvé',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAdmins,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        itemCount: _admins.length,
        itemBuilder: (context, index) {
          final admin = _admins[index];
          return _buildAdminCard(admin);
        },
      ),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> admin) {
    final bool isActive = admin['isActive'] ?? false;
    final String username = admin['username'] ?? '';
    final String email = admin['email'] ?? '';
    final String? lastLogin = admin['lastLogin'];

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
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
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryWithOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: AppDimensions.iconSize + 6,
              ),
            ),
            SizedBox(width: AppDimensions.spaceL),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    username,
                    style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                  ),
                  SizedBox(height: AppDimensions.spaceXS),
                  // Email
                  Text(
                    email,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: AppDimensions.spaceS),
                  // Status and Last Login
                  Row(
                    children: [
                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingS,
                          vertical: AppDimensions.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                          border: Border.all(
                            color: isActive
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.error.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.success : AppColors.error,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: AppDimensions.spaceXS),
                            Text(
                              isActive ? 'Actif' : 'Inactif',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isActive ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spaceS),
                  // Last Login
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppDimensions.iconSizeS,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppDimensions.spaceXS),
                      Text(
                        'Dernière connexion: ${_formatLastLogin(lastLogin)}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Modify button
            IconButton(
              onPressed: () => _showModifyAdminDialog(admin),
              icon: Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconSize,
              ),
              tooltip: 'Modifier',
            ),
          ],
        ),
      ),
    );
  }

  void _showModifyAdminDialog(Map<String, dynamic> admin) {
    showDialog(
      context: context,
      builder: (context) => ModifyAdminDialog(
        admin: admin,
        onAdminUpdated: _loadAdmins,
      ),
    );
  }
}

class ModifyAdminDialog extends StatefulWidget {
  final Map<String, dynamic> admin;
  final VoidCallback onAdminUpdated;

  const ModifyAdminDialog({
    super.key,
    required this.admin,
    required this.onAdminUpdated,
  });

  @override
  State<ModifyAdminDialog> createState() => _ModifyAdminDialogState();
}

class _ModifyAdminDialogState extends State<ModifyAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _changePassword = false;

  // Permissions
  bool _canCreateAdmins = false;
  bool _canDeleteAdmins = false;
  bool _canViewReservations = true;
  bool _canCreateReservations = true;
  bool _canEditReservations = true;
  bool _canDeleteReservations = false;
  bool _canViewStatistics = true;
  bool _canManageSettings = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.admin['username'] ?? '';
    _emailController.text = widget.admin['email'] ?? '';
    
    // Load current permissions
    final permissions = widget.admin['permissions'] ?? {};
    _canCreateAdmins = permissions['canCreateAdmins'] ?? false;
    _canDeleteAdmins = permissions['canDeleteAdmins'] ?? false;
    _canViewReservations = permissions['canViewReservations'] ?? true;
    _canCreateReservations = permissions['canCreateReservations'] ?? true;
    _canEditReservations = permissions['canEditReservations'] ?? true;
    _canDeleteReservations = permissions['canDeleteReservations'] ?? false;
    _canViewStatistics = permissions['canViewStatistics'] ?? true;
    _canManageSettings = permissions['canManageSettings'] ?? false;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getApiUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000/api'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api'; // iOS simulator
    } else {
      return 'http://localhost:5000/api'; // Desktop
    }
  }

  Future<void> _updateAdminPermissions() async {
    try {
      final apiUrl = '${_getApiUrl()}/admin/${widget.admin['_id']}/permissions';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: TokenManager.getAuthHeaders(),
        body: json.encode({
          'permissions': {
            'canCreateAdmins': _canCreateAdmins,
            'canDeleteAdmins': _canDeleteAdmins,
            'canViewReservations': _canViewReservations,
            'canCreateReservations': _canCreateReservations,
            'canEditReservations': _canEditReservations,
            'canDeleteReservations': _canDeleteReservations,
            'canViewStatistics': _canViewStatistics,
            'canManageSettings': _canManageSettings,
          }
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to update permissions');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des permissions: ${e.toString()}');
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update permissions
      await _updateAdminPermissions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Administrateur modifié avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        widget.onAdminUpdated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusL),
                  topRight: Radius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.textOnPrimary,
                    size: AppDimensions.iconSize,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      'Modifier l\'Administrateur',
                      style: AppTextStyles.h6.copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Basic Information Section
                      Text(
                        'Informations de base',
                        style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                      ),
                      SizedBox(height: AppDimensions.spaceM),
                      
                      // Username field (read-only for now)
                      TextFormField(
                        controller: _usernameController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          helperText: 'Le nom d\'utilisateur ne peut pas être modifié',
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceM),
                      
                      // Email field (read-only for now)
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          helperText: 'L\'email ne peut pas être modifié',
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceL),

                      // Password Section
                      Row(
                        children: [
                          Text(
                            'Changer le mot de passe',
                            style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                          ),
                          Spacer(),
                          Switch(
                            value: _changePassword,
                            onChanged: (value) {
                              setState(() {
                                _changePassword = value;
                                if (!value) {
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                }
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.spaceM),

                      if (_changePassword) ...[
                        // New password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Nouveau mot de passe',
                            hintText: 'Minimum 6 caractères',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            ),
                          ),
                          validator: _changePassword ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le nouveau mot de passe est requis';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          } : null,
                        ),
                        SizedBox(height: AppDimensions.spaceM),
                        
                        // Confirm new password field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirmer le nouveau mot de passe',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            ),
                          ),
                          validator: _changePassword ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez confirmer le nouveau mot de passe';
                            }
                            if (value != _passwordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          } : null,
                        ),
                        SizedBox(height: AppDimensions.spaceL),
                      ],

                      // Permissions Section
                      Text(
                        'Permissions',
                        style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                      ),
                      SizedBox(height: AppDimensions.spaceM),
                      
                      _buildPermissionSection('Gestion des Administrateurs', [
                        _buildPermissionTile(
                          'Créer des administrateurs',
                          'Peut ajouter de nouveaux administrateurs',
                          _canCreateAdmins,
                          (value) => setState(() => _canCreateAdmins = value),
                        ),
                        _buildPermissionTile(
                          'Supprimer des administrateurs',
                          'Peut désactiver/supprimer des administrateurs',
                          _canDeleteAdmins,
                          (value) => setState(() => _canDeleteAdmins = value),
                        ),
                      ]),
                      
                      _buildPermissionSection('Réservations', [
                        _buildPermissionTile(
                          'Voir les réservations',
                          'Peut consulter la liste des réservations',
                          _canViewReservations,
                          (value) => setState(() => _canViewReservations = value),
                        ),
                        _buildPermissionTile(
                          'Créer des réservations',
                          'Peut ajouter de nouvelles réservations',
                          _canCreateReservations,
                          (value) => setState(() => _canCreateReservations = value),
                        ),
                        _buildPermissionTile(
                          'Modifier des réservations',
                          'Peut modifier les réservations existantes',
                          _canEditReservations,
                          (value) => setState(() => _canEditReservations = value),
                        ),
                        _buildPermissionTile(
                          'Supprimer des réservations',
                          'Peut supprimer des réservations',
                          _canDeleteReservations,
                          (value) => setState(() => _canDeleteReservations = value),
                        ),
                      ]),
                      
                      _buildPermissionSection('Autres', [
                        _buildPermissionTile(
                          'Voir les statistiques',
                          'Peut accéder aux rapports et statistiques',
                          _canViewStatistics,
                          (value) => setState(() => _canViewStatistics = value),
                        ),
                        _buildPermissionTile(
                          'Gérer les paramètres',
                          'Peut modifier les paramètres de l\'application',
                          _canManageSettings,
                          (value) => setState(() => _canManageSettings = value),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusL),
                  bottomRight: Radius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: Text(
                        'Annuler',
                        style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                              ),
                            )
                          : Text(
                              'Enregistrer',
                              style: AppTextStyles.buttonMedium,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionSection(String title, List<Widget> permissions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryWithOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceS),
        ...permissions,
        SizedBox(height: AppDimensions.spaceL),
      ],
    );
  }

  Widget _buildPermissionTile(String title, String description, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
        ),
        subtitle: Text(
          description,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingXS,
        ),
      ),
    );
  }
}