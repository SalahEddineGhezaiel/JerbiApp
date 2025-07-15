import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
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
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.marginXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL, 
              vertical: AppDimensions.paddingL
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                topRight: Radius.circular(AppDimensions.radiusL),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.reservationsTitle,
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.secondary),
                  ),
                ),
                SizedBox(width: AppDimensions.iconButtonSize), // Space for eye icon
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
                    separatorBuilder: (context, index) => Divider(
                      height: AppDimensions.borderWidthThin,
                      color: AppColors.border,
                      indent: AppDimensions.paddingXL,
                      endIndent: AppDimensions.paddingXL,
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
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL, 
            vertical: AppDimensions.paddingL
          ),
          child: Row(
            children: [
              // Client Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client Name
                    Text(
                      reservation.nomPrenom,
                      style: AppTextStyles.h6.copyWith(color: AppColors.textPrimary),
                    ),
                    SizedBox(height: AppDimensions.spaceXS),
                    // Phone Number
                    Text(
                      reservation.telephone,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: AppDimensions.spaceXS / 2),
                    // Activity
                    Text(
                      reservation.activity,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Eye Icon
              Container(
                width: AppDimensions.iconButtonSizeS,
                height: AppDimensions.iconButtonSizeS,
                decoration: BoxDecoration(
                  color: AppColors.primaryWithOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(
                  Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: AppDimensions.iconSizeXS,
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
            color: AppColors.secondaryWithOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            AppStrings.reservationsEmpty,
            style: AppTextStyles.h5.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            AppStrings.reservationsEmptySubtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}