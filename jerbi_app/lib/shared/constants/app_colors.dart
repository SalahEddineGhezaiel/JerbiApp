import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF061138);
  static const Color primaryLight = Color(0xFF1A2B5C);
  static const Color primaryDark = Color(0xFF040B26);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF6C757D);
  static const Color secondaryLight = Color(0xFF8A9199);
  static const Color secondaryDark = Color(0xFF495057);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textOnPrimary = Colors.white;
  
  // Border Colors
  static const Color border = Color(0xFFE9ECEF);
  static const Color borderLight = Color(0xFFF1F3F4);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Chart Colors
  static const Color chartGreen = Color(0xFF4CAF50);
  static const Color chartBlue = Color(0xFF2196F3);
  static const Color chartOrange = Color(0xFFFF9800);
  static const Color chartRed = Color(0xFFF44336);
  static const Color chartPurple = Color(0xFF9C27B0);
  
  // Opacity Variants
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) => secondary.withValues(alpha: opacity);
  static Color blackWithOpacity(double opacity) => Colors.black.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) => Colors.white.withValues(alpha: opacity);
}