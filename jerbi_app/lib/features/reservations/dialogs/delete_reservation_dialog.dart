import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../models/reservation_model.dart';

class DeleteReservationDialog extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onConfirm;

  const DeleteReservationDialog({
    super.key,
    required this.reservation,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      title: Text(
        AppStrings.deleteReservation,
        style: AppTextStyles.h6.copyWith(color: AppColors.error),
      ),
      content: Text(
        '${AppStrings.deleteConfirmation} ${reservation.nomPrenom} ?\n\n${AppStrings.deleteWarning}',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel,
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          child: Text(AppStrings.delete, style: AppTextStyles.buttonMedium),
        ),
      ],
    );
  }
}