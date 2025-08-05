import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/token_manager.dart';
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

  Widget _buildStatusRow(String statusLabel, String? statusValue) {
    // Get status color based on status value
    Color statusColor;
    IconData statusIcon;

    switch (statusValue) {
      case 'pending':
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
        break;
      case 'confirmed':
        statusColor = AppColors.info;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'paid':
        statusColor = AppColors.success;
        statusIcon = Icons.payment;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help_outline;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          statusIcon,
          size: AppDimensions.iconSizeS,
          color: statusColor,
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statut', style: AppTextStyles.labelMedium),
              SizedBox(height: AppDimensions.spaceXS),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: AppDimensions.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext confirmContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Supprimer la réservation',
            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer la réservation de ${reservation.nomPrenom} ?\n\nCette action est irréversible.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(confirmContext),
              child: const Text('Annuler', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                // Close confirmation dialog
                Navigator.pop(confirmContext);
                // Close details dialog
                Navigator.pop(context);
                // Show success message immediately
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Réservation supprimée'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
                // Call delete function
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Supprimer', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
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
                          // Check permission first
                          if (!TokenManager.canEditReservations()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vous n\'avez pas la permission de modifier des réservations'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          
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
                          // Check permission first
                          if (!TokenManager.canDeleteReservations()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vous ne pouvez pas supprimer les réservations'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          
                          // Show confirmation dialog
                          _showDeleteConfirmation(context);
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
                  SizedBox(height: AppDimensions.spaceL),
                  _buildStatusRow(reservation.formattedStatus, reservation.status),
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