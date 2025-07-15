import 'package:flutter/material.dart';
import '../../shared/constants/constants.dart';
import 'widgets/reservations_header.dart';
import 'widgets/search_filter_section.dart';
import 'widgets/reservations_table.dart';
import 'models/reservation_model.dart';
import 'dialogs/dialogs.dart';

class ReservationsContent extends StatefulWidget {
  const ReservationsContent({super.key});

  @override
  State<ReservationsContent> createState() => _ReservationsContentState();
}

class _ReservationsContentState extends State<ReservationsContent> {
  // Sample data for demonstration
  final List<Reservation> _allReservations = [
    Reservation(
      id: '1', 
      nomPrenom: 'Ahmed Ben Ali', 
      email: 'ahmed.benali@email.com',
      telephone: '+216 98 123 456',
      nombreAdultes: 2,
      nombreEnfants: 1,
      enfantsParAge: {'4_8': 1},
      date: DateTime.now(), 
      activity: 'Balade en mer avec kayak'
    ),
    Reservation(
      id: '2', 
      nomPrenom: 'Fatima Zahra', 
      email: 'fatima.zahra@email.com',
      telephone: '+216 97 234 567',
      nombreAdultes: 4,
      nombreEnfants: 2,
      enfantsParAge: {'moins_4': 1, '9_12': 1},
      date: DateTime.now().add(const Duration(days: 1)), 
      activity: 'Sortie bateau à Haouaria'
    ),
    Reservation(
      id: '3', 
      nomPrenom: 'Mohamed Salah', 
      email: 'mohamed.salah@email.com',
      telephone: '+216 96 345 678',
      nombreAdultes: 3,
      nombreEnfants: 0,
      enfantsParAge: {},
      date: DateTime.now().add(const Duration(days: 2)), 
      activity: 'Balade en mer avec bateau'
    ),
    Reservation(
      id: '4', 
      nomPrenom: 'Leila Mansouri', 
      email: 'leila.mansouri@email.com',
      telephone: '+216 95 456 789',
      nombreAdultes: 2,
      nombreEnfants: 0,
      enfantsParAge: {},
      date: DateTime.now().add(const Duration(days: 3)), 
      activity: 'Plongée sous marine'
    ),
    Reservation(
      id: '5', 
      nomPrenom: 'Karim Bouazizi', 
      email: 'karim.bouazizi@email.com',
      telephone: '+216 94 567 890',
      nombreAdultes: 6,
      nombreEnfants: 3,
      enfantsParAge: {'moins_4': 1, '4_8': 1, '9_12': 1},
      date: DateTime.now().add(const Duration(days: 4)), 
      activity: 'Haouaria one day'
    ),
    Reservation(
      id: '6', 
      nomPrenom: 'Nadia Trabelsi', 
      email: 'nadia.trabelsi@email.com',
      telephone: '+216 93 678 901',
      nombreAdultes: 4,
      nombreEnfants: 2,
      enfantsParAge: {'4_8': 2},
      date: DateTime.now().add(const Duration(days: 5)), 
      activity: 'Camping'
    ),
    Reservation(
      id: '7', 
      nomPrenom: 'Youssef Khelifi', 
      email: 'youssef.khelifi@email.com',
      telephone: '+216 92 789 012',
      nombreAdultes: 2,
      nombreEnfants: 1,
      enfantsParAge: {'9_12': 1},
      date: DateTime.now().add(const Duration(days: 6)), 
      activity: 'Journée crique'
    ),
    Reservation(
      id: '8', 
      nomPrenom: 'Amina Gharbi', 
      email: 'amina.gharbi@email.com',
      telephone: '+216 91 890 123',
      nombreAdultes: 5,
      nombreEnfants: 0,
      enfantsParAge: {},
      date: DateTime.now().add(const Duration(days: 7)), 
      activity: 'Balade en mer avec kayak'
    ),
    Reservation(
      id: '9', 
      nomPrenom: 'Sami Jebali', 
      email: 'sami.jebali@email.com',
      telephone: '+216 90 901 234',
      nombreAdultes: 3,
      nombreEnfants: 2,
      enfantsParAge: {'moins_4': 2},
      date: DateTime.now().add(const Duration(days: 8)), 
      activity: 'Sortie bateau à Haouaria'
    ),
    Reservation(
      id: '10', 
      nomPrenom: 'Rim Sassi', 
      email: 'rim.sassi@email.com',
      telephone: '+216 99 012 345',
      nombreAdultes: 2,
      nombreEnfants: 1,
      enfantsParAge: {'4_8': 1},
      date: DateTime.now().add(const Duration(days: 9)), 
      activity: 'Plongée sous marine'
    ),
  ];

  List<Reservation> _filteredReservations = [];
  String _searchQuery = '';
  
  // Filter state
  DateTime? _selectedFilterStartDate;
  DateTime? _selectedFilterEndDate;
  String? _selectedFilterActivity;
  bool _hasActiveFilters = false;

  @override
  void initState() {
    super.initState();
    _filteredReservations = _allReservations;
  }

  // Handle search functionality
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  // Apply all filters (search, date, activity)
  void _applyFilters() {
    List<Reservation> filtered = List.from(_allReservations);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((reservation) =>
              reservation.nomPrenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              reservation.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              reservation.telephone.contains(_searchQuery))
          .toList();
    }

    // Apply date filter
    if (_selectedFilterStartDate != null) {
      if (_selectedFilterEndDate != null) {
        // Date range filter - inclusive of both start and end dates
        filtered = filtered
            .where((reservation) {
              // Compare only the date part (year, month, day) ignoring time
              final reservationDate = DateTime(reservation.date.year, reservation.date.month, reservation.date.day);
              final startDate = DateTime(_selectedFilterStartDate!.year, _selectedFilterStartDate!.month, _selectedFilterStartDate!.day);
              final endDate = DateTime(_selectedFilterEndDate!.year, _selectedFilterEndDate!.month, _selectedFilterEndDate!.day);
              
              // Check if reservation date is within the range (inclusive)
              return (reservationDate.isAtSameMomentAs(startDate) || reservationDate.isAfter(startDate)) &&
                     (reservationDate.isAtSameMomentAs(endDate) || reservationDate.isBefore(endDate));
            })
            .toList();
      } else {
        // Single date filter
        filtered = filtered
            .where((reservation) =>
                reservation.date.year == _selectedFilterStartDate!.year &&
                reservation.date.month == _selectedFilterStartDate!.month &&
                reservation.date.day == _selectedFilterStartDate!.day)
            .toList();
      }
    }

    // Apply activity filter
    if (_selectedFilterActivity != null) {
      filtered = filtered
          .where((reservation) => reservation.activity == _selectedFilterActivity)
          .toList();
    }

    _filteredReservations = filtered;
    _hasActiveFilters = _selectedFilterStartDate != null || _selectedFilterActivity != null;
  }

  // Handle filter button press
  void _handleFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterReservationsDialog(
          initialStartDate: _selectedFilterStartDate,
          initialEndDate: _selectedFilterEndDate,
          initialActivity: _selectedFilterActivity,
          onApplyFilters: (DateTime? startDate, DateTime? endDate, String? activity) {
            setState(() {
              _selectedFilterStartDate = startDate;
              _selectedFilterEndDate = endDate;
              _selectedFilterActivity = activity;
              _applyFilters();
            });
          },
        );
      },
    );
  }

  // Handle add new reservation
  void _handleAddReservation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddReservationDialog(
          onReservationAdded: (Reservation newReservation) {
            setState(() {
              _allReservations.add(newReservation);
              _applyFilters();
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppStrings.reservationDetails} ${newReservation.nomPrenom} ${AppStrings.reservationAdded}'),
                backgroundColor: AppColors.success,
                duration: AppConstants.snackBarDuration,
              ),
            );
          },
        );
      },
    );
  }

  // Handle reservation details view
  void _handleViewDetails(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReservationDetailsDialog(
          reservation: reservation,
          onEdit: () => _handleEditReservation(reservation),
          onDelete: () => _handleDeleteReservation(reservation),
        );
      },
    );
  }

  // Handle edit reservation
  void _handleEditReservation(Reservation reservation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EditReservationDialog(
          reservation: reservation,
          onReservationUpdated: (Reservation updatedReservation) {
            setState(() {
              // Find and update the reservation in the main list
              final index = _allReservations.indexWhere((r) => r.id == updatedReservation.id);
              if (index != -1) {
                _allReservations[index] = updatedReservation;
              }
              _applyFilters();
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppStrings.reservationDetails} ${updatedReservation.nomPrenom} ${AppStrings.reservationUpdated}'),
                backgroundColor: AppColors.info,
                duration: AppConstants.snackBarDuration,
              ),
            );
          },
        );
      },
    );
  }

  // Handle delete reservation
  void _handleDeleteReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteReservationDialog(
          reservation: reservation,
          onConfirm: () {
            setState(() {
              _allReservations.removeWhere((r) => r.id == reservation.id);
              _filteredReservations.removeWhere((r) => r.id == reservation.id);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppStrings.reservationDetails} ${reservation.nomPrenom} ${AppStrings.reservationDeleted}'),
                backgroundColor: AppColors.error,
                duration: AppConstants.snackBarDuration,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping anywhere outside the search field
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            ReservationsHeader(
              onAddPressed: _handleAddReservation,
            ),
            
            // Search & Filter Section
            SearchFilterSection(
              onSearch: _handleSearch,
              onFilter: _handleFilter,
              hasActiveFilters: _hasActiveFilters,
            ),
            
            // Main Content - Reservations Table
            Expanded(
              child: ReservationsTable(
                reservations: _filteredReservations,
                onViewDetails: _handleViewDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}