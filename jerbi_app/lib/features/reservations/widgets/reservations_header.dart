import 'package:flutter/material.dart';

class ReservationsHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const ReservationsHeader({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          const Text(
            'Réservations',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF061138),
              letterSpacing: -0.5,
            ),
          ),
          
          // Add Button
          Material(
            color: const Color(0xFF061138),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onAddPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}