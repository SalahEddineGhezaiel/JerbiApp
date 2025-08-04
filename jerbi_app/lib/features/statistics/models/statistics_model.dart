class StatisticsOverview {
  final int total;
  final int pending;
  final int confirmed;
  final int paid;
  final int cancelled;

  StatisticsOverview({
    required this.total,
    required this.pending,
    required this.confirmed,
    required this.paid,
    required this.cancelled,
  });

  factory StatisticsOverview.fromJson(Map<String, dynamic> json) {
    return StatisticsOverview(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      paid: json['paid'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pending': pending,
      'confirmed': confirmed,
      'paid': paid,
      'cancelled': cancelled,
    };
  }
}

class ActivityStats {
  final String activity;
  final int count;
  final int totalAdults;
  final int totalChildren;

  ActivityStats({
    required this.activity,
    required this.count,
    required this.totalAdults,
    required this.totalChildren,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) {
    return ActivityStats(
      activity: json['_id'] ?? '',
      count: json['count'] ?? 0,
      totalAdults: json['totalAdults'] ?? 0,
      totalChildren: json['totalChildren'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'count': count,
      'totalAdults': totalAdults,
      'totalChildren': totalChildren,
    };
  }

  int get totalPeople => totalAdults + totalChildren;
}

class MonthlyStats {
  final int year;
  final int month;
  final int count;
  final int totalPeople;

  MonthlyStats({
    required this.year,
    required this.month,
    required this.count,
    required this.totalPeople,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] ?? {};
    return MonthlyStats(
      year: id['year'] ?? 0,
      month: id['month'] ?? 0,
      count: json['count'] ?? 0,
      totalPeople: json['totalPeople'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'count': count,
      'totalPeople': totalPeople,
    };
  }

  String get monthName {
    const months = [
      '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month] ?? '';
  }

  String get displayName => '$monthName $year';
}

class ReservationStatistics {
  final StatisticsOverview overview;
  final List<ActivityStats> activities;
  final List<MonthlyStats> monthly;

  ReservationStatistics({
    required this.overview,
    required this.activities,
    required this.monthly,
  });

  factory ReservationStatistics.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return ReservationStatistics(
      overview: StatisticsOverview.fromJson(data['overview'] ?? {}),
      activities: (data['activities'] as List<dynamic>? ?? [])
          .map((item) => ActivityStats.fromJson(item))
          .toList(),
      monthly: (data['monthly'] as List<dynamic>? ?? [])
          .map((item) => MonthlyStats.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overview': overview.toJson(),
      'activities': activities.map((item) => item.toJson()).toList(),
      'monthly': monthly.map((item) => item.toJson()).toList(),
    };
  }
}