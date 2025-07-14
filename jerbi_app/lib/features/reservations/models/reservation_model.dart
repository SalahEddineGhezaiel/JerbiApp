class Reservation {
  final String id;
  final String nomPrenom;
  final String email;
  final String telephone;
  final int nombreAdultes;
  final int nombreEnfants;
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
    required this.date,
    required this.activity,
    this.status,
  });

  // Format date for display
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Format date with time
  String get formattedDateTime {
    return '${formattedDate} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Get total number of people
  int get totalPersonnes => nombreAdultes + nombreEnfants;

  // Get formatted people count
  String get formattedPersonnes {
    if (nombreEnfants == 0) {
      return '$nombreAdultes adulte${nombreAdultes > 1 ? 's' : ''}';
    } else if (nombreAdultes == 0) {
      return '$nombreEnfants enfant${nombreEnfants > 1 ? 's' : ''}';
    } else {
      return '$nombreAdultes adulte${nombreAdultes > 1 ? 's' : ''}, $nombreEnfants enfant${nombreEnfants > 1 ? 's' : ''}';
    }
  }

  // Create from JSON (for future API integration)
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      nomPrenom: json['nomPrenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      nombreAdultes: json['nombreAdultes'] ?? 0,
      nombreEnfants: json['nombreEnfants'] ?? 0,
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