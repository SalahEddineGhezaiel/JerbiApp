import 'package:flutter/material.dart';
import '../constants/constants.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;

  const PageHeader({
    super.key,
    required this.title,
    this.onActionPressed,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL, 
        vertical: AppDimensions.paddingL
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          ),
          
          // Action Button (optional)
          if (onActionPressed != null && actionIcon != null)
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: InkWell(
                onTap: onActionPressed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Container(
                  width: AppDimensions.iconButtonSize,
                  height: AppDimensions.iconButtonSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(
                    actionIcon,
                    color: AppColors.textOnPrimary,
                    size: AppDimensions.iconSize,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}