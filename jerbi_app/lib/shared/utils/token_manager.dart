import 'package:flutter/foundation.dart';

/// Simple in-memory token storage for authentication
class TokenManager {
  static String? _authToken;
  static Map<String, dynamic>? _adminData;

  /// Save authentication token
  static void saveToken(String token) {
    _authToken = token;
    if (kDebugMode) {
      print('🔐 Token saved: ${token.substring(0, 20)}...');
    }
  }

  /// Get current authentication token
  static String? getToken() {
    return _authToken;
  }

  /// Check if user is authenticated (has valid token)
  static bool isAuthenticated() {
    return _authToken != null && _authToken!.isNotEmpty;
  }

  /// Save admin user data
  static void saveAdminData(Map<String, dynamic> adminData) {
    _adminData = adminData;
    if (kDebugMode) {
      print('👤 Admin data saved: ${adminData['username'] ?? 'Unknown'}');
      print('🔑 Permissions: ${getPermissionsSummary()}');
    }
  }

  /// Get current admin data
  static Map<String, dynamic>? getAdminData() {
    return _adminData;
  }

  /// Get admin username
  static String? getAdminUsername() {
    return _adminData?['username'];
  }

  /// Get admin role
  static String? getAdminRole() {
    return _adminData?['role'];
  }

  /// Clear all authentication data
  static void clearAll() {
    _authToken = null;
    _adminData = null;
    if (kDebugMode) {
      print('🗑️ All authentication data cleared');
    }
  }

  /// Get headers with authentication token
  static Map<String, String> getAuthHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (isAuthenticated()) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Get headers without authentication (for public endpoints)
  static Map<String, String> getPublicHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Check if admin has specific permission
  static bool hasPermission(String permission) {
    final adminData = getAdminData();
    if (adminData == null) return false;
    
    final permissions = adminData['permissions'];
    if (permissions == null) return false;
    
    return permissions[permission] == true;
  }

  /// Check if admin can view reservations
  static bool canViewReservations() {
    return hasPermission('canViewReservations');
  }

  /// Check if admin can create reservations
  static bool canCreateReservations() {
    return hasPermission('canCreateReservations');
  }

  /// Check if admin can edit reservations
  static bool canEditReservations() {
    return hasPermission('canEditReservations');
  }

  /// Check if admin can delete reservations
  static bool canDeleteReservations() {
    return hasPermission('canDeleteReservations');
  }

  /// Check if admin can view statistics
  static bool canViewStatistics() {
    return hasPermission('canViewStatistics');
  }

  /// Check if admin can manage settings
  static bool canManageSettings() {
    return hasPermission('canManageSettings');
  }

  /// Check if admin can create other admins
  static bool canCreateAdmins() {
    return hasPermission('canCreateAdmins');
  }

  /// Check if admin can delete other admins
  static bool canDeleteAdmins() {
    return hasPermission('canDeleteAdmins');
  }

  /// Check if admin is super admin
  static bool isSuperAdmin() {
    return getAdminRole() == 'super-admin';
  }

  /// Get admin permissions summary for debugging
  static Map<String, bool> getPermissionsSummary() {
    return {
      'canViewReservations': canViewReservations(),
      'canCreateReservations': canCreateReservations(),
      'canEditReservations': canEditReservations(),
      'canDeleteReservations': canDeleteReservations(),
      'canViewStatistics': canViewStatistics(),
      'canManageSettings': canManageSettings(),
      'canCreateAdmins': canCreateAdmins(),
      'canDeleteAdmins': canDeleteAdmins(),
      'isSuperAdmin': isSuperAdmin(),
    };
  }
}