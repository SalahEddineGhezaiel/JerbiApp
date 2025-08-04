import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../shared/utils/token_manager.dart';
import '../models/statistics_model.dart';

class StatisticsService {
  // Get API URL based on platform
  static String _getApiUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }

  // Get headers with authentication
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (TokenManager.isAuthenticated()) 
        'Authorization': 'Bearer ${TokenManager.getToken()}',
    };
  }

  // Get statistics with optional date filtering
  static Future<ReservationStatistics> getStatistics({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      
      if (dateFrom != null) {
        queryParams['dateFrom'] = dateFrom.toIso8601String();
      }
      
      if (dateTo != null) {
        queryParams['dateTo'] = dateTo.toIso8601String();
      }

      // Build URL with query parameters
      final uri = Uri.parse('${_getApiUrl()}/reservations/stats')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(
        uri,
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          return ReservationStatistics.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Erreur lors du chargement des statistiques');
        }
      } else if (response.statusCode == 401) {
        // Authentication error
        TokenManager.clearAll();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode == 403) {
        // Permission error
        throw Exception('Vous n\'avez pas la permission de voir les statistiques');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: Le serveur met trop de temps à répondre');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Connection refused')) {
        throw Exception('Impossible de se connecter au serveur.\n\nVérifiez que:\n• Le serveur backend est démarré\n• Il fonctionne sur le port 5000');
      } else {
        rethrow;
      }
    }
  }

  // Get statistics for today
  static Future<ReservationStatistics> getTodayStats() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    return getStatistics(
      dateFrom: startOfDay,
      dateTo: endOfDay,
    );
  }

  // Get statistics for this week
  static Future<ReservationStatistics> getThisWeekStats() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return getStatistics(
      dateFrom: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      dateTo: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    );
  }

  // Get statistics for this month
  static Future<ReservationStatistics> getThisMonthStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    return getStatistics(
      dateFrom: startOfMonth,
      dateTo: endOfMonth,
    );
  }

  // Get statistics for this year
  static Future<ReservationStatistics> getThisYearStats() async {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
    
    return getStatistics(
      dateFrom: startOfYear,
      dateTo: endOfYear,
    );
  }

  // Get statistics for last 30 days
  static Future<ReservationStatistics> getLast30DaysStats() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    return getStatistics(
      dateFrom: DateTime(thirtyDaysAgo.year, thirtyDaysAgo.month, thirtyDaysAgo.day),
      dateTo: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  // Get all time statistics
  static Future<ReservationStatistics> getAllTimeStats() async {
    return getStatistics(); // No date filters = all time
  }
}