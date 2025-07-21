import 'package:flutter/material.dart';
import '../../shared/constants/constants.dart';
import '../../shared/widgets/page_header.dart';

class StatisticsContent extends StatefulWidget {
  const StatisticsContent({super.key});

  @override
  State<StatisticsContent> createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<StatisticsContent> {
  String _selectedPeriod = AppStrings.thisWeek;
  
  // Mock data - will be replaced with API calls later
  final Map<String, dynamic> _mockStats = {
    'totalReservations': 156,
    'confirmedReservations': 142,
    'paidReservations': 8,
    'cancelledReservations': 6,
    'totalRevenue': 45600,
    'totalCustomers': 89,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PageHeader(title: AppStrings.statisticsTitle),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildStatsCards(),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildChartsSection(),
                  SizedBox(height: AppDimensions.spaceL),
                  _buildActivityBreakdown(),
                  SizedBox(height: AppDimensions.spaceXXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.timePeriods.length,
        itemBuilder: (context, index) {
          final period = AppConstants.timePeriods[index];
          final isSelected = period == _selectedPeriod;
          
          return Padding(
            padding: EdgeInsets.only(right: AppDimensions.spaceM),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL, 
                  vertical: AppDimensions.paddingS
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    period,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on available space
        final cardWidth = (constraints.maxWidth - AppDimensions.spaceM) / 2;
        final cardHeight = cardWidth * 0.8; // Aspect ratio of 0.8
        
        return Wrap(
          spacing: AppDimensions.spaceM,
          runSpacing: AppDimensions.spaceM,
          children: [
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _buildStatCard(
                AppStrings.totalReservations,
                '${_mockStats['totalReservations']}',
                Icons.event_note,
                AppColors.chartGreen,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _buildStatCard(
                AppStrings.confirmedReservations,
                '${_mockStats['confirmedReservations']}',
                Icons.check_circle,
                AppColors.chartBlue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _buildStatCard(
                AppStrings.paidReservations,
                '${_mockStats['paidReservations']}',
                Icons.payment,
                AppColors.chartOrange,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _buildStatCard(
                AppStrings.cancelledReservations,
                '${_mockStats['cancelledReservations']}',
                Icons.cancel,
                AppColors.chartRed,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimensions.spaceXS),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.reservationEvolution,
            style: AppTextStyles.h6.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppDimensions.spaceS),
                  Text(
                    AppStrings.chartPlaceholder,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
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
      {'name': AppStrings.activityKayak, 'count': 45, 'color': AppColors.chartGreen},
      {'name': AppStrings.activityBoatHaouaria, 'count': 32, 'color': AppColors.chartBlue},
      {'name': AppStrings.activityDiving, 'count': 28, 'color': AppColors.chartOrange},
      {'name': AppStrings.activityCamping, 'count': 25, 'color': AppColors.chartPurple},
      {'name': AppStrings.activityCrique, 'count': 18, 'color': AppColors.chartRed},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.activityBreakdown,
            style: AppTextStyles.h6.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          ...activities.map((activity) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: activity['color'] as Color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Text(
                    activity['name'] as String,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${activity['count']}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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