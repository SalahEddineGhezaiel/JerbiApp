import 'package:flutter/material.dart';

class StatisticsContent extends StatefulWidget {
  const StatisticsContent({super.key});

  @override
  State<StatisticsContent> createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<StatisticsContent> {
  String _selectedPeriod = 'Cette semaine';
  
  // Mock data - will be replaced with API calls later
  final Map<String, dynamic> _mockStats = {
    'totalReservations': 156,
    'confirmedReservations': 142,
    'pendingReservations': 8,
    'cancelledReservations': 6,
    'totalRevenue': 45600,
    'totalCustomers': 89,
  };

  final List<String> _periods = [
    'Aujourd\'hui',
    'Cette semaine', 
    'Ce mois',
    'Cette année'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 12),
                  _buildStatsCards(),
                  const SizedBox(height: 16),
                  _buildChartsSection(),
                  const SizedBox(height: 16),
                  _buildActivityBreakdown(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF061138),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Statistiques',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          // Removed the back arrow button
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final isSelected = period == _selectedPeriod;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF061138) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF061138) : const Color(0xFFE9ECEF),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF6C757D),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.9,
      children: [
        _buildStatCard(
          'Total Réservations',
          '${_mockStats['totalReservations']}',
          Icons.event_note,
          const Color(0xFF4CAF50),
        ),
        _buildStatCard(
          'Confirmées',
          '${_mockStats['confirmedReservations']}',
          Icons.check_circle,
          const Color(0xFF2196F3),
        ),
        _buildStatCard(
          'En Attente',
          '${_mockStats['pendingReservations']}',
          Icons.schedule,
          const Color(0xFFFF9800),
        ),
        _buildStatCard(
          'Annulées',
          '${_mockStats['cancelledReservations']}',
          Icons.cancel,
          const Color(0xFFF44336),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF061138),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Évolution des Réservations',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF061138),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 36,
                    color: Color(0xFF6C757D),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Graphique à implémenter',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBreakdown() {
    final activities = [
      {'name': 'Balade en mer avec kayak', 'count': 45, 'color': const Color(0xFF4CAF50)},
      {'name': 'Sortie bateau à Haouaria', 'count': 32, 'color': const Color(0xFF2196F3)},
      {'name': 'Plongée sous marine', 'count': 28, 'color': const Color(0xFFFF9800)},
      {'name': 'Camping', 'count': 25, 'color': const Color(0xFF9C27B0)},
      {'name': 'Journée crique', 'count': 18, 'color': const Color(0xFFF44336)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Répartition par Activité',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF061138),
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map((activity) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: activity['color'] as Color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activity['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
                Text(
                  '${activity['count']}',
                  style: const TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF061138),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}