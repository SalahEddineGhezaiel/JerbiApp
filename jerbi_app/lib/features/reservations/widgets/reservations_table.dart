import 'package:flutter/material.dart';
import '../models/reservation_model.dart';

class ReservationsTable extends StatelessWidget {
  final List<Reservation> reservations;
  final Function(Reservation) onViewDetails;

  const ReservationsTable({
    super.key,
    required this.reservations,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Réservations',
                    style: const TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C757D),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Space for eye icon
              ],
            ),
          ),
          
          // Table Content
          Expanded(
            child: reservations.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: reservations.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Color(0xFFE9ECEF),
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];
                      return _buildReservationRow(reservation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationRow(Reservation reservation) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onViewDetails(reservation),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Client Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.nomPrenom,
                      style: const TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212529),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reservation.activity,
                      style: const TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6C757D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Eye Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF061138).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.visibility_outlined,
                  color: Color(0xFF061138),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: const Color(0xFF6C757D).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune réservation trouvée',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6C757D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Les réservations apparaîtront ici',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }
}