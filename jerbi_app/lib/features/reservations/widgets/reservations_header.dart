import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/page_header.dart';

class ReservationsHeader extends StatelessWidget {
  const ReservationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: AppStrings.reservationsTitle,
    );
  }
}