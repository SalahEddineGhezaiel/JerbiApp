import 'package:flutter/material.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/utils.dart';
import '../models/reservation_model.dart';

class AddReservationDialog extends StatefulWidget {
  final Function(Reservation) onReservationAdded;

  const AddReservationDialog({
    super.key,
    required this.onReservationAdded,
  });

  @override
  State<AddReservationDialog> createState() => _AddReservationDialogState();
}

class _AddReservationDialogState extends State<AddReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomPrenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _nombreAdultesController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedActivity;
  String _selectedStatus = 'pending'; // Default to pending
  bool _isLoading = false;

  // Validation error messages
  String? _dateError;
  String? _activityError;

  // Age ranges for children
  final Map<String, int> _enfantsParAge = {
    'moins_4': 0,
    '4_8': 0,
    '9_12': 0,
  };

  @override
  void dispose() {
    _nomPrenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _nombreAdultesController.dispose();
    super.dispose();
  }

  int get _totalEnfants {
    return _enfantsParAge.values.fold(0, (sum, count) => sum + count);
  }

  Future<void> _selectDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateError = null; // Clear error when user selects a date
      });
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  Future<void> _handleConfirm() async {
    // Clear previous errors
    setState(() {
      _dateError = null;
      _activityError = null;
    });

    // Validate form fields
    bool isValid = _formKey.currentState!.validate();

    // Validate date
    if (_selectedDate == null) {
      setState(() {
        _dateError = AppStrings.dateRequired;
      });
      isValid = false;
    }

    // Validate activity
    if (_selectedActivity == null) {
      setState(() {
        _activityError = AppStrings.activityRequired;
      });
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(AppConstants.loginDelay);

    // Generate new ID (in real app, this would come from backend)
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    final newReservation = Reservation(
      id: newId,
      nomPrenom: _nomPrenomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      nombreAdultes: int.parse(_nombreAdultesController.text),
      nombreEnfants: _totalEnfants,
      enfantsParAge: Map<String, int>.from(_enfantsParAge),
      date: _selectedDate!,
      activity: _selectedActivity!,
      status: _selectedStatus,
    );

    widget.onReservationAdded(newReservation);
    Navigator.of(context).pop();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceS),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.primary, width: AppDimensions.borderWidthThick),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingL, 
              horizontal: AppDimensions.paddingL
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.childrenLabel, style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceM),
        ...AppConstants.ageRanges.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(entry.value, style: AppTextStyles.bodyMedium),
                ),
                Container(
                  width: 120,
                  height: AppDimensions.inputHeight,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_enfantsParAge[entry.key]! > 0) {
                              _enfantsParAge[entry.key] = _enfantsParAge[entry.key]! - 1;
                            }
                          });
                        },
                        icon: Icon(Icons.remove, size: AppDimensions.iconSizeS),
                        color: AppColors.secondary,
                      ),
                      Expanded(
                        child: Text(
                          '${_enfantsParAge[entry.key]}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h6,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _enfantsParAge[entry.key] = _enfantsParAge[entry.key]! + 1;
                          });
                        },
                        icon: Icon(Icons.add, size: AppDimensions.iconSizeS),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (_totalEnfants > 0)
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primaryWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.child_care,
                  color: AppColors.primary,
                  size: AppDimensions.iconSizeS,
                ),
                SizedBox(width: AppDimensions.spaceS),
                Text(
                  '${AppStrings.childrenTotal} $_totalEnfants ${_totalEnfants > 1 ? AppStrings.childrenPlural : AppStrings.childrenSingular}',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dateLabel, style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceS),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingL,
              horizontal: AppDimensions.paddingL
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: _dateError != null ? AppColors.error : AppColors.border,
                width: _dateError != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.secondary,
                ),
                SizedBox(width: AppDimensions.spaceM),
                Text(
                  _selectedDate != null
                      ? DateFormatter.formatDate(_selectedDate!)
                      : AppStrings.dateHint,
                  style: _selectedDate != null
                      ? AppTextStyles.inputText
                      : AppTextStyles.inputHint,
                ),
              ],
            ),
          ),
        ),
        if (_dateError != null) ...[
          SizedBox(height: AppDimensions.spaceXS),
          Text(
            _dateError!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statut', style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceS),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue ?? 'pending';
            });
          },
          decoration: InputDecoration(
            prefixIcon: _getStatusIcon(_selectedStatus),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: AppTextStyles.inputText,
          items: Reservation.statusOptions.map<DropdownMenuItem<String>>((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                Reservation.statusLabels[status] ?? status,
                style: AppTextStyles.inputText,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getStatusIcon(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
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

    return Icon(statusIcon, color: statusColor, size: 16);
  }

  Widget _buildActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.activityLabel, style: AppTextStyles.inputLabel),
        SizedBox(height: AppDimensions.spaceS),
        DropdownButtonFormField<String>(
          value: _selectedActivity,
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedActivity = newValue;
              _activityError = null; // Clear error when user selects
            });
          },
          decoration: InputDecoration(
            hintText: AppStrings.activityHint,
            prefixIcon: Icon(
              Icons.waves,
              color: AppColors.secondary,
            ),
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(
                color: _activityError != null ? AppColors.error : AppColors.border,
                width: _activityError != null ? 2 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(
                color: _activityError != null ? AppColors.error : AppColors.border,
                width: _activityError != null ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.primary, width: AppDimensions.borderWidthThick),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingL, 
              horizontal: AppDimensions.paddingL
            ),
          ),
          style: AppTextStyles.inputText,
          items: AppConstants.activities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.inputText,
                ),
              ),
            );
          }).toList(),
        ),
        if (_activityError != null) ...[
          SizedBox(height: AppDimensions.spaceXS),
          Text(
            _activityError!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
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
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
                    Icons.add_circle_outline,
                    color: AppColors.textOnPrimary,
                    size: AppDimensions.iconSize + 4,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      AppStrings.addReservation,
                      style: AppTextStyles.h4.copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleCancel,
                    icon: Icon(Icons.close, color: AppColors.textOnPrimary),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingXXL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client Information Section
                      Text(AppStrings.clientInfo, style: AppTextStyles.h5),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildTextField(
                        controller: _nomPrenomController,
                        label: AppStrings.nameLabel,
                        hint: AppStrings.nameHint,
                        icon: Icons.person,
                        validator: Validators.validateName,
                      ),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildTextField(
                        controller: _emailController,
                        label: AppStrings.emailLabel,
                        hint: AppStrings.emailHint,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildTextField(
                        controller: _telephoneController,
                        label: AppStrings.phoneLabel,
                        hint: AppStrings.phoneHint,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      SizedBox(height: AppDimensions.spaceXXL),

                      // Reservation Details Section
                      Text(AppStrings.reservationInfo, style: AppTextStyles.h5),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildTextField(
                        controller: _nombreAdultesController,
                        label: AppStrings.adultsLabel,
                        hint: AppStrings.adultsHint,
                        icon: Icons.person,
                        keyboardType: TextInputType.number,
                        validator: Validators.validateAdults,
                      ),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildChildrenAgeSection(),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildDateField(),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildActivityDropdown(),
                      SizedBox(height: AppDimensions.spaceL),

                      _buildStatusDropdown(),
                    ],
                  ),
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
                      ),
                      child: Text(
                        AppStrings.cancel,
                        style: AppTextStyles.buttonMedium.copyWith(color: AppColors.secondary),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceL),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: AppDimensions.iconSizeS,
                              height: AppDimensions.iconSizeS,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                              ),
                            )
                          : Text(AppStrings.confirm, style: AppTextStyles.buttonMedium),
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