import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';

class StatisticsFilterSection extends StatefulWidget {
  final VoidCallback onFilter;
  final VoidCallback? onClearFilter;
  final Function(String)? onQuickFilter;
  final bool hasActiveFilters;
  final String? customPeriodLabel;

  const StatisticsFilterSection({
    super.key,
    required this.onFilter,
    this.onClearFilter,
    this.onQuickFilter,
    this.hasActiveFilters = false,
    this.customPeriodLabel,
  });

  @override
  State<StatisticsFilterSection> createState() => _StatisticsFilterSectionState();
}

class _StatisticsFilterSectionState extends State<StatisticsFilterSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      color: AppColors.surface,
      child: Row(
        children: [
          // Filter Button with Dropdown
          Material(
            color: widget.hasActiveFilters
                ? AppColors.primaryWithOpacity(0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'clear') {
                  widget.onClearFilter?.call();
                } else {
                  widget.onQuickFilter?.call(value);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              elevation: 8,
              offset: const Offset(0, 8),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'today',
                  child: Row(
                    children: [
                      Icon(Icons.today, size: 16, color: AppColors.secondary),
                      SizedBox(width: AppDimensions.spaceM),
                      Text(
                        'Aujourd\'hui',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'thisMonth',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: AppColors.secondary),
                      SizedBox(width: AppDimensions.spaceM),
                      Text(
                        'Ce mois',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'thisYear',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppColors.secondary),
                      SizedBox(width: AppDimensions.spaceM),
                      Text(
                        'Cette année',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'allTime',
                  child: Row(
                    children: [
                      Icon(Icons.all_inclusive, size: 16, color: AppColors.secondary),
                      SizedBox(width: AppDimensions.spaceM),
                      Text(
                        'Tout le temps',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.hasActiveFilters) ...[
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear, size: 16, color: AppColors.error),
                        SizedBox(width: AppDimensions.spaceM),
                        Text(
                          'Effacer les filtres',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
              child: Container(
                width: AppDimensions.iconButtonSize,
                height: AppDimensions.iconButtonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: widget.hasActiveFilters
                        ? AppColors.primary
                        : AppColors.border,
                    width: widget.hasActiveFilters
                        ? AppDimensions.borderWidthThick
                        : AppDimensions.borderWidthThin,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.filter_list,
                        color: widget.hasActiveFilters
                            ? AppColors.primary
                            : AppColors.secondary,
                        size: AppDimensions.iconSizeS,
                      ),
                    ),
                    if (widget.hasActiveFilters)
                      Positioned(
                        top: AppDimensions.spaceS,
                        right: AppDimensions.spaceS,
                        child: Container(
                          width: AppDimensions.spaceS,
                          height: AppDimensions.spaceS,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spaceM),
          
          // Filter Info Display - Make it clickable
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onFilter,
                onLongPress: widget.hasActiveFilters && widget.onClearFilter != null
                    ? widget.onClearFilter
                    : null,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                splashColor: AppColors.primary.withValues(alpha: 0.1),
                highlightColor: AppColors.primary.withValues(alpha: 0.05),
                child: Container(
                  height: AppDimensions.inputHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingM,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: widget.hasActiveFilters ? AppColors.primary : AppColors.border,
                      width: widget.hasActiveFilters
                          ? AppDimensions.borderWidthThick
                          : AppDimensions.borderWidthThin,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: widget.hasActiveFilters ? AppColors.primary : AppColors.secondary,
                        size: AppDimensions.iconSizeS,
                      ),
                      SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Text(
                          widget.hasActiveFilters && widget.customPeriodLabel != null
                              ? widget.customPeriodLabel!
                              : 'Filtrer par période',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: widget.hasActiveFilters
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: widget.hasActiveFilters
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.hasActiveFilters)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: AppDimensions.iconSizeS,
                        )
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconSizeS,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
