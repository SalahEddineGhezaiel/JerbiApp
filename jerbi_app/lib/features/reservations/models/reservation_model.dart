class Reservation {
  final String id;
  final String clientName;
  final DateTime date;
  final String activity;
  final String? status;
  final String? phoneNumber;
  final String? email;

  Reservation({
    required this.id,
    required this.clientName,
    required this.date,
    required this.activity,
    this.status,
    this.phoneNumber,
    this.email,
  });

  // Format date for display
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Format date with time
  String get formattedDateTime {
    return '${formattedDate} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Create from JSON (for future API integration)
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      activity: json['activity'] ?? '',
      status: json['status'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'date': date.toIso8601String(),
      'activity': activity,
      'status': status,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  // Copy with method for updates
  Reservation copyWith({
    String? id,
    String? clientName,
    DateTime? date,
    String? activity,
    String? status,
    String? phoneNumber,
    String? email,
  }) {
    return Reservation(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      activity: activity ?? this.activity,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'Reservation(id: $id, clientName: $clientName, date: $date, activity: $activity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}