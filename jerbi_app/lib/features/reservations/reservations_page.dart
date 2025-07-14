import 'package:flutter/material.dart';
import '../reservations/widgets/reservations_header.dart';
import '../reservations/widgets/search_filter_section.dart';
import '../reservations/widgets/reservations_table.dart';
import '../reservations/widgets/bottom_navigation.dart';
import '../reservations/models/reservation_model.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  // Sample data for demonstration
  final List<Reservation> _allReservations = [
    Reservation(
      id: '1', 
      nomPrenom: 'Ahmed Ben Ali', 
      email: 'ahmed.benali@email.com',
      telephone: '+216 98 123 456',
      nombreAdultes: 2,
      nombreEnfants: 1,
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
      date: DateTime.now().add(const Duration(days: 9)), 
      activity: 'Plong��e sous marine'
    ),
  ];

  List<Reservation> _filteredReservations = [];
  String _searchQuery = '';
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredReservations = _allReservations;
  }

  // Handle search functionality
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredReservations = _allReservations;
      } else {
        _filteredReservations = _allReservations
            .where((reservation) =>
                reservation.nomPrenom.toLowerCase().contains(query.toLowerCase()) ||
                reservation.email.toLowerCase().contains(query.toLowerCase()) ||
                reservation.telephone.contains(query))
            .toList();
      }
    });
  }

  // Handle filter button press
  void _handleFilter() {
    // Placeholder for filter functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtres'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Filtrer par date'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement date filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Filtrer par activité'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement activity filter
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
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
        return _AddReservationDialog(
          onReservationAdded: (Reservation newReservation) {
            setState(() {
              _allReservations.add(newReservation);
              // Update filtered list based on current search
              if (_searchQuery.isEmpty) {
                _filteredReservations = _allReservations;
              } else {
                _filteredReservations = _allReservations
                    .where((reservation) =>
                        reservation.nomPrenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        reservation.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        reservation.telephone.contains(_searchQuery))
                    .toList();
              }
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Réservation de ${newReservation.nomPrenom} ajoutée avec succès'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with client name and action buttons
                Row(
                  children: [
                    // Client Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Réservation de',
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reservation.nomPrenom,
                            style: const TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF061138),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Edit Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _handleEditReservation(reservation);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _handleDeleteReservation(reservation);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Reservation Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE9ECEF),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Email', reservation.email, Icons.email),
                      const SizedBox(height: 16),
                      _buildDetailRow('Téléphone', reservation.telephone, Icons.phone),
                      const SizedBox(height: 16),
                      _buildDetailRow('Participants', reservation.formattedPersonnes, Icons.group),
                      const SizedBox(height: 16),
                      _buildDetailRow('Activité', reservation.activity, Icons.waves),
                      const SizedBox(height: 16),
                      _buildDetailRow('Date', reservation.formattedDate, Icons.calendar_today),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Close Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF061138),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Handle edit reservation
  void _handleEditReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier la réservation',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w600,
              color: Color(0xFF061138),
            ),
          ),
          content: Text(
            'Modification de la réservation de ${reservation.nomPrenom}',
            style: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 14,
              color: Color(0xFF6C757D),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Modification de ${reservation.nomPrenom} - À implémenter'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  // Handle delete reservation
  void _handleDeleteReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Supprimer la réservation',
            style: TextStyle(
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer la réservation de ${reservation.nomPrenom} ?\n\nCette action est irréversible.',
            style: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 14,
              color: Color(0xFF6C757D),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement actual deletion
                setState(() {
                  _allReservations.removeWhere((r) => r.id == reservation.id);
                  _filteredReservations.removeWhere((r) => r.id == reservation.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Réservation de ${reservation.nomPrenom} supprimée'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF061138),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C757D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212529),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Handle bottom navigation
  void _handleNavigation(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    
    switch (index) {
      case 0:
        // Already on reservations page
        break;
      case 1:
        // Navigate to statistics
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Page Statistiques - À implémenter'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case 2:
        // Navigate to settings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Page Paramètres - À implémenter'),
            backgroundColor: Colors.grey,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
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
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedNavIndex,
        onItemSelected: _handleNavigation,
      ),
    );
  }
}

// Add Reservation Dialog Widget
class _AddReservationDialog extends StatefulWidget {
  final Function(Reservation) onReservationAdded;

  const _AddReservationDialog({
    required this.onReservationAdded,
  });

  @override
  State<_AddReservationDialog> createState() => _AddReservationDialogState();
}

class _AddReservationDialogState extends State<_AddReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomPrenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _nombreAdultesController = TextEditingController();
  final _nombreEnfantsController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedActivity;
  bool _isLoading = false;

  // Available activities (same as in existing reservations)
  final List<String> _activities = [
    'Balade en mer avec kayak',
    'Sortie bateau à Haouaria',
    'Balade en mer avec bateau',
    'Plongée sous marine',
    'Haouaria one day',
    'Camping',
    'Journée crique',
  ];

  @override
  void dispose() {
    _nomPrenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _nombreAdultesController.dispose();
    _nombreEnfantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF061138),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF061138),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF061138),
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
      });
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  Future<void> _handleConfirm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une activité'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate new ID (in real app, this would come from backend)
    final newId = DateTime.now().millisecondsSinceEpoch.toString();

    final newReservation = Reservation(
      id: newId,
      nomPrenom: _nomPrenomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      nombreAdultes: int.parse(_nombreAdultesController.text),
      nombreEnfants: int.parse(_nombreEnfantsController.text),
      date: _selectedDate!,
      activity: _selectedActivity!,
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
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SFPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF061138),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'SFPro',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF212529),
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6C757D)),
            hintStyle: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6C757D),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF061138), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date de la réservation',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF061138),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF6C757D)),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                      : 'Sélectionner une date',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _selectedDate != null ? const Color(0xFF212529) : const Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activité',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF061138),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedActivity,
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedActivity = newValue;
            });
          },
          decoration: InputDecoration(
            hintText: 'Sélectionner une activité',
            prefixIcon: const Icon(Icons.waves, color: Color(0xFF6C757D)),
            hintStyle: const TextStyle(
              fontFamily: 'SFPro',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6C757D),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF061138), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: const TextStyle(
            fontFamily: 'SFPro',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF212529),
          ),
          items: _activities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                width: double.infinity,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF212529),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF061138),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Nouvelle Réservation',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleCancel,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client Information Section
                      const Text(
                        'Informations Client',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF061138),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _nomPrenomController,
                        label: 'Nom et Prénom',
                        hint: 'Ex: Ahmed Ben Ali',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom et prénom sont requis';
                          }
                          if (value.trim().length < 2) {
                            return 'Le nom doit contenir au moins 2 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Ex: ahmed@email.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'L\'email est requis';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _telephoneController,
                        label: 'Téléphone',
                        hint: 'Ex: +216 98 123 456',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le téléphone est requis';
                          }
                          if (value.trim().length < 8) {
                            return 'Veuillez entrer un numéro valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Reservation Details Section
                      const Text(
                        'Détails de la Réservation',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF061138),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _nombreAdultesController,
                              label: 'Nombre d\'adultes',
                              hint: '1',
                              icon: Icons.person,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requis';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number < 1) {
                                  return 'Min: 1';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _nombreEnfantsController,
                              label: 'Nombre d\'enfants',
                              hint: '0',
                              icon: Icons.child_care,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requis';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number < 0) {
                                  return 'Min: 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildDateField(),
                      const SizedBox(height: 16),

                      _buildActivityDropdown(),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C757D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF061138),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Confirmer',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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