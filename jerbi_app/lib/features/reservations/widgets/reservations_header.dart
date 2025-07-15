import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/page_header.dart';

class ReservationsHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const ReservationsHeader({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: AppStrings.reservationsTitle,
      onActionPressed: onAddPressed,
      actionIcon: Icons.add,
    );
  }
}