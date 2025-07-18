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
}