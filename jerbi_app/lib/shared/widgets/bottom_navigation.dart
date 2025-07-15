import 'package:flutter/material.dart';
import '../constants/constants.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.08),
            blurRadius: AppDimensions.elevationXL,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL, 
            vertical: AppDimensions.paddingS
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.event_note_outlined,
                activeIcon: Icons.event_note,
                label: AppStrings.navReservations,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: AppStrings.navStatistics,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: AppStrings.navSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: AppDimensions.navIconContainer,
                  height: AppDimensions.navIconContainer,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryWithOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected 
                        ? AppColors.primary
                        : AppColors.secondary,
                    size: AppDimensions.iconSizeS,
                  ),
                ),
                
                SizedBox(height: AppDimensions.spaceXS),
                
                // Label
                Text(
                  label,
                  style: isSelected 
                      ? AppTextStyles.navLabelSelected.copyWith(color: AppColors.primary)
                      : AppTextStyles.navLabel.copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}