import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../shared/constants/constants.dart';
import '../../shared/utils/token_manager.dart';
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
  // Data state
  List<Reservation> _allReservations = [];
  List<Reservation> _filteredReservations = [];
  String _searchQuery = '';
  
  // Loading and error state
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filter state
  DateTime? _selectedFilterStartDate;
  DateTime? _selectedFilterEndDate;
  String? _selectedFilterActivity;
  bool _hasActiveFilters = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  // Get API URL based on platform
  String _getApiUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }

  // Get headers with authentication using TokenManager
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (TokenManager.isAuthenticated()) 
        'Authorization': 'Bearer ${TokenManager.getToken()}',
    };
  }

  // Load reservations from backend
  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiUrl = '${_getApiUrl()}/reservations';
      print('🔗 Loading reservations from: $apiUrl');
      print('🔐 Authenticated: ${TokenManager.isAuthenticated()}');
      if (TokenManager.isAuthenticated()) {
        print('👤 Admin: ${TokenManager.getAdminUsername()}');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final reservationsData = responseData['data']['reservations'] as List;
          
          setState(() {
            _allReservations = reservationsData
                .map((item) => Reservation.fromJson(item))
                .toList();
            _applyFilters();
            _isLoading = false;
          });
          
          print('✅ Loaded ${_allReservations.length} reservations');
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Erreur lors du chargement';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          _isLoading = false;
        });
        // Clear token and redirect to login
        TokenManager.clearAll();
      } else {
        setState(() {
          _errorMessage = 'Erreur serveur: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading reservations: $e');
      setState(() {
        if (e.toString().contains('TimeoutException')) {
          _errorMessage = 'Timeout: Le serveur met trop de temps à répondre';
        } else if (e.toString().contains('SocketException') || 
                   e.toString().contains('Connection refused')) {
          _errorMessage = 'Impossible de se connecter au serveur.\n\nVérifiez que:\n• Le serveur backend est démarré\n• Il fonctionne sur le port 5000';
        } else {
          _errorMessage = 'Erreur de connexion: ${e.toString()}';
        }
        _isLoading = false;
      });
    }
  }

  // Create reservation in backend
  Future<Reservation> _createReservationInBackend(Reservation reservation) async {
    try {
      final apiUrl = '${_getApiUrl()}/reservations';
      print('➕ Creating reservation: $apiUrl');

      final requestBody = {
        'nomPrenom': reservation.nomPrenom,
        'email': reservation.email,
        'telephone': reservation.telephone,
        'nombreAdultes': reservation.nombreAdultes,
        'nombreEnfants': reservation.nombreEnfants,
        'enfantsParAge': reservation.enfantsParAge,
        'totalPersonnes': reservation.totalPersonnes,
        'date': reservation.date.toIso8601String(),
        'activity': reservation.activity,
      };

      print('📤 Create request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      print('📡 Create response status: ${response.statusCode}');
      print('📄 Create response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Successfully created in backend, return the created reservation with backend ID
          final createdReservationData = responseData['data'];
          final createdReservation = Reservation.fromJson(createdReservationData);
          
          // Add to local lists
          setState(() {
            _allReservations.add(createdReservation);
            _applyFilters();
          });
          
          print('✅ Reservation created successfully with ID: ${createdReservation.id}');
          return createdReservation;
        } else {
          throw Exception(responseData['message'] ?? 'Erreur lors de la création');
        }
      } else if (response.statusCode == 401) {
        // Authentication error
        TokenManager.clearAll();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode == 403) {
        // Permission error
        throw Exception('Vous n\'avez pas la permission de créer des réservations');
      } else if (response.statusCode == 400) {
        // Validation error
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Données invalides');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating reservation: $e');
      rethrow; // Re-throw to handle in the calling method
    }
  }

  // Delete reservation from backend
  Future<void> _deleteReservationFromBackend(String reservationId) async {
    try {
      final apiUrl = '${_getApiUrl()}/reservations/$reservationId';
      print('🗑️ Deleting reservation: $apiUrl');

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      print('📡 Delete response status: ${response.statusCode}');
      print('📄 Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Successfully deleted from backend, now remove from local lists
          setState(() {
            _allReservations.removeWhere((r) => r.id == reservationId);
            _applyFilters(); // This will update _filteredReservations
          });
          
          print('✅ Reservation deleted successfully');
        } else {
          throw Exception(responseData['message'] ?? 'Erreur lors de la suppression');
        }
      } else if (response.statusCode == 401) {
        // Authentication error
        TokenManager.clearAll();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode == 404) {
        // Reservation not found - remove from local list anyway
        setState(() {
          _allReservations.removeWhere((r) => r.id == reservationId);
          _applyFilters();
        });
        throw Exception('Réservation non trouvée (déjà supprimée)');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting reservation: $e');
      rethrow; // Re-throw to handle in the calling method
    }
  }

  // Update reservation in backend
  Future<void> _updateReservationInBackend(Reservation reservation) async {
    try {
      final apiUrl = '${_getApiUrl()}/reservations/${reservation.id}';
      print('✏️ Updating reservation: $apiUrl');

      final requestBody = {
        'nomPrenom': reservation.nomPrenom,
        'email': reservation.email,
        'telephone': reservation.telephone,
        'nombreAdultes': reservation.nombreAdultes,
        'nombreEnfants': reservation.nombreEnfants,
        'enfantsParAge': reservation.enfantsParAge,
        'totalPersonnes': reservation.totalPersonnes,
        'date': reservation.date.toIso8601String(),
        'activity': reservation.activity,
      };

      print('📤 Update request body: ${json.encode(requestBody)}');

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      print('📡 Update response status: ${response.statusCode}');
      print('📄 Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Successfully updated in backend, now update local lists
          setState(() {
            final index = _allReservations.indexWhere((r) => r.id == reservation.id);
            if (index != -1) {
              _allReservations[index] = reservation;
            }
            _applyFilters();
          });
          
          print('✅ Reservation updated successfully');
        } else {
          throw Exception(responseData['message'] ?? 'Erreur lors de la mise à jour');
        }
      } else if (response.statusCode == 401) {
        // Authentication error
        TokenManager.clearAll();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode == 403) {
        // Permission error
        throw Exception('Vous n\'avez pas la permission de modifier des réservations');
      } else if (response.statusCode == 404) {
        // Reservation not found
        throw Exception('Réservation non trouvée');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating reservation: $e');
      rethrow; // Re-throw to handle in the calling method
    }
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
    // Check permission first
    if (!TokenManager.canCreateReservations()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez pas la permission de créer des réservations'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddReservationDialog(
          onReservationAdded: (Reservation newReservation) async {
            try {
              // Create in backend
              final createdReservation = await _createReservationInBackend(newReservation);
              
              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${AppStrings.reservationDetails} ${createdReservation.nomPrenom} ${AppStrings.reservationAdded}'),
                    backgroundColor: AppColors.success,
                    duration: AppConstants.snackBarDuration,
                  ),
                );
              }
            } catch (e) {
              // Show error message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: AppColors.error,
                    duration: AppConstants.snackBarDuration,
                  ),
                );
              }
            }
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EditReservationDialog(
          reservation: reservation,
          onReservationUpdated: (Reservation updatedReservation) async {
            try {
              // Update in backend
              await _updateReservationInBackend(updatedReservation);
              
              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${AppStrings.reservationDetails} ${updatedReservation.nomPrenom} ${AppStrings.reservationUpdated}'),
                    backgroundColor: AppColors.success,
                    duration: AppConstants.snackBarDuration,
                  ),
                );
              }
            } catch (e) {
              // Show error message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${e.toString()}'),
                    backgroundColor: AppColors.error,
                    duration: AppConstants.snackBarDuration,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  // Handle delete reservation - simple backend deletion only
  void _handleDeleteReservation(Reservation reservation) async {
    try {
      // Delete from backend silently
      await _deleteReservationFromBackend(reservation.id);
    } catch (e) {
      // Show error if deletion fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Refresh reservations
  Future<void> _handleRefresh() async {
    await _loadReservations();
  }

  // Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconSize * 2,
              color: AppColors.error,
            ),
            SizedBox(height: AppDimensions.spaceM),
            Text(
              'Erreur de chargement',
              style: AppTextStyles.h6.copyWith(color: AppColors.error),
            ),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              _errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppDimensions.spaceL),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build loading widget
  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Chargement des réservations...',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
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
            
            // Main Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingWidget()
                  : _errorMessage != null
                      ? _buildErrorWidget()
                      : RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: ReservationsTable(
                            reservations: _filteredReservations,
                            onViewDetails: _handleViewDetails,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}