import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../models/reservation_model.dart';

class ReservationDetailsDialog extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReservationDetailsDialog({
    super.key,
    required this.reservation,
    required this.onEdit,
    required this.onDelete,
  });

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppDimensions.iconSizeS,
          color: AppColors.primary,
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelMedium),
              SizedBox(height: AppDimensions.spaceXS),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with client name and action buttons
            Row(
              children: [
                // Client Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.reservationDetails, style: AppTextStyles.labelMedium),
                      SizedBox(height: AppDimensions.spaceXS),
                      Text(reservation.nomPrenom, style: AppTextStyles.h4),
                    ],
                  ),
                ),
                
                // Action Buttons
                Row(
                  children: [
                    // Edit Button
                    Container(
                      width: AppDimensions.iconButtonSizeS,
                      height: AppDimensions.iconButtonSizeS,
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.info,
                          size: AppDimensions.iconSizeS,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onEdit();
                        },
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceS),
                    // Delete Button
                    Container(
                      width: AppDimensions.iconButtonSizeS,
                      height: AppDimensions.iconButtonSizeS,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: AppDimensions.iconSizeS,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: AppDimensions.spaceXXL),
            
            // Reservation Details
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(AppStrings.emailDetail, reservation.email, Icons.email),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildDetailRow(AppStrings.phoneDetail, reservation.telephone, Icons.phone),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildDetailRow(
                    AppStrings.adultsDetail, 
                    '${reservation.nombreAdultes} ${reservation.nombreAdultes > 1 ? AppStrings.adultPlural : AppStrings.adultSingular}', 
                    Icons.person
                  ),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildDetailRow(AppStrings.childrenDetail, reservation.formattedEnfants, Icons.child_care),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildDetailRow(AppStrings.activityDetail, reservation.activity, Icons.waves),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildDetailRow(AppStrings.dateDetail, reservation.formattedDate, Icons.calendar_today),
                ],
              ),
            ),
            
            SizedBox(height: AppDimensions.spaceXXL),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightM,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  elevation: 0,
                ),
                child: Text(AppStrings.close, style: AppTextStyles.buttonMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}