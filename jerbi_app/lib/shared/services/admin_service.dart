import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class AdminService {
  /// Get the correct API base URL for different platforms
  static String _getApiBaseUrl() {
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

  /// Get current admin profile from backend
  static Future<Map<String, dynamic>> getAdminProfile() async {
    try {
      final apiUrl = '${_getApiBaseUrl()}/admin/profile';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: TokenManager.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          return responseData['data']['admin'];
        } else {
          throw Exception(responseData['message'] ?? 'Failed to get admin profile');
        }
      } else if (response.statusCode == 401) {
        // Authentication error
        TokenManager.clearAll();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Erreur lors de la récupération du profil');
      }
    } catch (e) {
      if (e.toString().contains('Session expirée')) {
        rethrow;
      }
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  /// Update admin profile data in TokenManager
  static Future<void> refreshAdminProfile() async {
    try {
      final adminProfile = await getAdminProfile();
      TokenManager.saveAdminData(adminProfile);
    } catch (e) {
      // If refresh fails, we'll use cached data
      debugPrint('Failed to refresh admin profile: $e');
    }
  }

  /// Logout admin from backend
  static Future<void> logout() async {
    try {
      final apiUrl = '${_getApiBaseUrl()}/auth/logout';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: TokenManager.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // Clear local authentication data
          TokenManager.clearAll();
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to logout');
        }
      } else {
        // Even if backend fails, clear local data
        TokenManager.clearAll();
        throw Exception('Erreur lors de la déconnexion');
      }
    } catch (e) {
      // Always clear local data even if backend call fails
      TokenManager.clearAll();
      if (e.toString().contains('Session expirée')) {
        return; // Already logged out
      }
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }
}
