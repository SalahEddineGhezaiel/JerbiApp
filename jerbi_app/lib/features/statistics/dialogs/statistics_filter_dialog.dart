import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/utils.dart';

class StatisticsFilterDialog extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onApplyFilters;

  const StatisticsFilterDialog({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApplyFilters,
  });

  @override
  State<StatisticsFilterDialog> createState() => _StatisticsFilterDialogState();
}

class _StatisticsFilterDialogState extends State<StatisticsFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDateRange = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _isDateRange = widget.initialStartDate != null && widget.initialEndDate != null;
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If it's a single date selection, clear end date
        if (!_isDateRange) {
          _endDate = null;
        }
        // If end date is before start date, clear it
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez d\'abord sélectionner une date de début'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _isDateRange = false;
    });
  }

  void _applyFilters() {
    DateTime? startDate = _startDate;
    DateTime? endDate;

    if (_isDateRange) {
      // For date range, use the selected end date
      endDate = _endDate;
    } else if (_startDate != null) {
      // For single date, set end date to the same day at 23:59:59
      // This ensures we get statistics for just that specific day
      endDate = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        23,
        59,
        59,
      );
    }

    widget.onApplyFilters(startDate, endDate);
    Navigator.of(context).pop();
  }

  bool get _hasActiveFilters {
    return _startDate != null;
  }

  Widget _buildDateFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filtrer par période',
          style: AppTextStyles.h6.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: AppDimensions.spaceM),
        
        // Date filter type selector
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              RadioListTile<bool>(
                title: Text(
                  'Jour spécifique',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  'Statistiques pour une date précise',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: false,
                groupValue: _isDateRange,
                onChanged: (value) {
                  setState(() {
                    _isDateRange = value!;
                    if (!_isDateRange) {
                      _endDate = null;
                    }
                  });
                },
                activeColor: AppColors.primary,
              ),
              RadioListTile<bool>(
                title: Text(
                  'Période',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  'Statistiques pour une plage de dates',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: true,
                groupValue: _isDateRange,
                onChanged: (value) {
                  setState(() {
                    _isDateRange = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
        
        SizedBox(height: AppDimensions.spaceL),
        
        // Date selection
        if (!_isDateRange) ...[
          // Single date selection
          _buildDateField(
            label: 'Date spécifique',
            date: _startDate,
            onTap: _selectStartDate,
            hint: 'Sélectionner la date',
          ),
        ] else ...[
          // Date range selection
          _buildDateField(
            label: 'Date de début',
            date: _startDate,
            onTap: _selectStartDate,
            hint: 'Sélectionner début',
          ),
          SizedBox(height: AppDimensions.spaceM),
          _buildDateField(
            label: 'Date de fin',
            date: _endDate,
            onTap: _selectEndDate,
            hint: 'Sélectionner fin',
            enabled: _startDate != null,
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required String hint,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceS),
        InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingL,
              horizontal: AppDimensions.paddingL,
            ),
            decoration: BoxDecoration(
              color: enabled ? AppColors.surface : AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: enabled ? AppColors.border : AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: enabled ? AppColors.secondary : AppColors.secondary.withValues(alpha: 0.5),
                  size: AppDimensions.iconSizeS,
                ),
                SizedBox(width: AppDimensions.spaceM),
                Text(
                  date != null ? DateFormatter.formatDate(date) : hint,
                  style: date != null
                      ? AppTextStyles.inputText.copyWith(
                          color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                        )
                      : AppTextStyles.inputHint.copyWith(
                          color: enabled ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingXXL),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusXL),
                  topRight: Radius.circular(AppDimensions.radiusXL),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: AppColors.textOnPrimary,
                    size: AppDimensions.iconSize + 4,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      'Filtrer les statistiques',
                      style: AppTextStyles.h4.copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AppColors.textOnPrimary),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingXXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateFilterSection(),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingXXL),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusXL),
                  bottomRight: Radius.circular(AppDimensions.radiusXL),
                ),
              ),
              child: Row(
                children: [
                  // Clear Filters Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _hasActiveFilters ? _clearFilters : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _hasActiveFilters ? AppColors.secondary : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
                      ),
                      child: Text(
                        'Effacer',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: _hasActiveFilters ? AppColors.secondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceL),
                  // Apply Filters Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
                        elevation: 0,
                      ),
                      child: Text(
                        'Appliquer',
                        style: AppTextStyles.buttonMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
