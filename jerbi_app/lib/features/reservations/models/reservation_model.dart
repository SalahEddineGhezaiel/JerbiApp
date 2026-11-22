class Reservation {
  final String id;
  final String nomPrenom;
  final String email;
  final String telephone;
  final int nombreAdultes;
  final int nombreEnfants;
  final Map<String, int> enfantsParAge; // New field for children age ranges
  final DateTime date;
  final String activity;
  final String? status;

  Reservation({
    required this.id,
    required this.nomPrenom,
    required this.email,
    required this.telephone,
    required this.nombreAdultes,
    required this.nombreEnfants,
    required this.enfantsParAge,
    required this.date,
    required this.activity,
    this.status,
  });

  // Static age ranges
  static const Map<String, String> ageRanges = {
    'moins_4': 'Moins de 4 ans',
    '4_8': 'De 4 à 8 ans',
    '9_12': 'De 9 à 12 ans',
  };

  // Static status options
  static const Map<String, String> statusLabels = {
    'pending': 'En attente',
    'confirmed': 'Confirmée',
    'paid': 'Payée',
    'cancelled': 'Annulée',
  };

  static const List<String> statusOptions = [
    'pending',
    'confirmed',
    'paid',
    'cancelled',
  ];

  // Format date for display
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Format date with time
  String get formattedDateTime {
    return '${formattedDate} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Get formatted status
  String get formattedStatus {
    return statusLabels[status] ?? status ?? 'En attente';
  }

  // Get total number of people
  int get totalPersonnes => nombreAdultes + nombreEnfants;

  // Get formatted people count with age details
  String get formattedPersonnes {
    List<String> parts = [];
    
    if (nombreAdultes > 0) {
      parts.add('$nombreAdultes adulte${nombreAdultes > 1 ? 's' : ''}');
    }
    
    if (nombreEnfants > 0) {
      List<String> enfantsParts = [];
      enfantsParAge.forEach((ageKey, count) {
        if (count > 0) {
          String ageLabel = ageRanges[ageKey] ?? ageKey;
          enfantsParts.add('$count enfant${count > 1 ? 's' : ''} ($ageLabel)');
        }
      });
      
      if (enfantsParts.isNotEmpty) {
        parts.addAll(enfantsParts);
      } else {
        parts.add('$nombreEnfants enfant${nombreEnfants > 1 ? 's' : ''}');
      }
    }
    
    return parts.join(', ');
  }

  // Get formatted children details only
  String get formattedEnfants {
    if (nombreEnfants == 0) return 'Aucun enfant';
    
    List<String> enfantsParts = [];
    enfantsParAge.forEach((ageKey, count) {
      if (count > 0) {
        String ageLabel = ageRanges[ageKey] ?? ageKey;
        enfantsParts.add('$count × $ageLabel');
      }
    });
    
    return enfantsParts.isNotEmpty ? enfantsParts.join(', ') : '$nombreEnfants enfant${nombreEnfants > 1 ? 's' : ''}';
  }

  // Create from JSON (for future API integration)
  factory Reservation.fromJson(Map<String, dynamic> json) {
    Map<String, int> enfantsParAge = {};
    if (json['enfantsParAge'] != null) {
      Map<String, dynamic> enfantsData = json['enfantsParAge'];
      enfantsData.forEach((key, value) {
        enfantsParAge[key] = value is int ? value : int.tryParse(value.toString()) ?? 0;
      });
    }

    return Reservation(
      id: json['_id'] ?? json['id'] ?? '',
      nomPrenom: json['nomPrenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      nombreAdultes: json['nombreAdultes'] ?? 0,
      nombreEnfants: json['nombreEnfants'] ?? 0,
      enfantsParAge: enfantsParAge,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      activity: json['activity'] ?? '',
      status: json['status'],
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomPrenom': nomPrenom,
      'email': email,
      'telephone': telephone,
      'nombreAdultes': nombreAdultes,
      'nombreEnfants': nombreEnfants,
      'enfantsParAge': enfantsParAge,
      'date': date.toIso8601String(),
      'activity': activity,
      'status': status,
    };
  }

  // Copy with method for updates
  Reservation copyWith({
    String? id,
    String? nomPrenom,
    String? email,
    String? telephone,
    int? nombreAdultes,
    int? nombreEnfants,
    Map<String, int>? enfantsParAge,
    DateTime? date,
    String? activity,
    String? status,
  }) {
    return Reservation(
      id: id ?? this.id,
      nomPrenom: nomPrenom ?? this.nomPrenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      nombreAdultes: nombreAdultes ?? this.nombreAdultes,
      nombreEnfants: nombreEnfants ?? this.nombreEnfants,
      enfantsParAge: enfantsParAge ?? Map<String, int>.from(this.enfantsParAge),
      date: date ?? this.date,
      activity: activity ?? this.activity,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Reservation(id: $id, nomPrenom: $nomPrenom, date: $date, activity: $activity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}