class AppConstants {
  // Available Activities
  static const List<String> activities = [
    'Balade en mer avec kayak',
    'Sortie bateau à Haouaria',
    'Balade en mer avec bateau',
    'Plongée sous marine',
    'Haouaria one day',
    'Camping',
    'Journée crique',
  ];
  
  // Age Ranges for Children
  static const Map<String, String> ageRanges = {
    'moins_4': 'Moins de 4 ans',
    '4_8': 'De 4 à 8 ans',
    '9_12': 'De 9 à 12 ans',
  };
  
  // Time Periods for Statistics
  static const List<String> timePeriods = [
    'Aujourd\'hui',
    'Cette semaine', 
    'Ce mois',
    'Cette année'
  ];
  
  // Reservation Status
  static const List<String> reservationStatuses = [
    'paid',
    'confirmed',
    'cancelled',
    'completed'
  ];
  
  // Default Login Credentials (for demo)
  static const String defaultUsername = 'admin';
  static const String defaultPassword = '123456';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Delays
  static const Duration loginDelay = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration shortSnackBarDuration = Duration(seconds: 2);
  
  // Limits
  static const int maxAdults = 20;
  static const int maxChildren = 15;
  static const int maxNotesLength = 500;
  static const int minNameLength = 2;
  static const int minPhoneLength = 8;
  static const int minPasswordLength = 6;
  
  // Asset Paths
  static const String logoAsset = 'assets/logo.png';
  static const String backgroundAsset = 'assets/bg1.png';
  
  // Font Family
  static const String fontFamily = 'SFPro';
  
  // API Endpoints (for future use)
  static const String baseUrl = 'http://localhost:5000/api';
  static const String authEndpoint = '/auth';
  static const String reservationsEndpoint = '/reservations';
  static const String adminEndpoint = '/admin';
}