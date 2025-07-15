import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';

class SearchFilterSection extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilter;
  final bool hasActiveFilters;

  const SearchFilterSection({
    super.key,
    required this.onSearch,
    required this.onFilter,
    this.hasActiveFilters = false,
  });

  @override
  State<SearchFilterSection> createState() => _SearchFilterSectionState();
}

class _SearchFilterSectionState extends State<SearchFilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      color: AppColors.surface,
      child: Row(
        children: [
          // Filter Button
          Material(
            color: widget.hasActiveFilters 
                ? AppColors.primaryWithOpacity(0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: InkWell(
              onTap: widget.onFilter,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
          
          // Search Bar
          Expanded(
            child: Container(
              height: AppDimensions.inputHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: AppTextStyles.inputHint.copyWith(
                    color: AppColors.secondaryWithOpacity(0.7),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: AppDimensions.paddingL, 
                      right: AppDimensions.paddingM
                    ),
                    child: Icon(
                      Icons.search,
                      color: AppColors.secondary,
                      size: AppDimensions.iconSizeS,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: AppDimensions.iconButtonSize,
                    minHeight: AppDimensions.iconButtonSize,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.secondary,
                            size: AppDimensions.iconSizeS,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearch('');
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 0,
                    right: AppDimensions.paddingL,
                    top: 14,
                    bottom: AppDimensions.paddingM,
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