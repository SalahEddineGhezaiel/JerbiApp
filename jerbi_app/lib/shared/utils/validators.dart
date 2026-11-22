import '../constants/app_strings.dart';

class Validators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    
    return null;
  }
  
  /// Validates required text fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }
  
  /// Validates name with minimum length
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    
    if (value.trim().length < 2) {
      return AppStrings.nameMinLength;
    }
    
    return null;
  }
  
  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    
    if (value.trim().length < 8) {
      return AppStrings.phoneMinLength;
    }
    
    return null;
  }
  
  /// Validates password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    
    if (value.length < 6) {
      return AppStrings.passwordMinLength;
    }
    
    return null;
  }
  
  /// Validates number of adults
  static String? validateAdults(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.adultsRequired;
    }
    
    final number = int.tryParse(value);
    if (number == null || number < 1) {
      return AppStrings.adultsMinimum;
    }
    
    return null;
  }
  
  /// Validates that a value is selected from dropdown
  static String? validateSelection(dynamic value, String fieldName) {
    if (value == null) {
      return 'Veuillez sélectionner $fieldName';
    }
    return null;
  }
  
  /// Validates that a date is selected
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return AppStrings.dateRequired;
    }
    return null;
  }
  
  /// Validates that an activity is selected
  static String? validateActivity(String? activity) {
    if (activity == null || activity.isEmpty) {
      return AppStrings.activityRequired;
    }
    return null;
  }
}