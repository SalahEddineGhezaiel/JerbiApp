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
    Reservation(id: '1', clientName: 'Ahmed Ben Ali', date: DateTime.now(), activity: 'Conference Room A'),
    Reservation(id: '2', clientName: 'Fatima Zahra', date: DateTime.now().add(const Duration(days: 1)), activity: 'Meeting Room B'),
    Reservation(id: '3', clientName: 'Mohamed Salah', date: DateTime.now().add(const Duration(days: 2)), activity: 'Event Hall'),
    Reservation(id: '4', clientName: 'Leila Mansouri', date: DateTime.now().add(const Duration(days: 3)), activity: 'Workshop Room'),
    Reservation(id: '5', clientName: 'Karim Bouazizi', date: DateTime.now().add(const Duration(days: 4)), activity: 'Conference Room B'),
    Reservation(id: '6', clientName: 'Nadia Trabelsi', date: DateTime.now().add(const Duration(days: 5)), activity: 'Meeting Room A'),
    Reservation(id: '7', clientName: 'Youssef Khelifi', date: DateTime.now().add(const Duration(days: 6)), activity: 'Event Hall'),
    Reservation(id: '8', clientName: 'Amina Gharbi', date: DateTime.now().add(const Duration(days: 7)), activity: 'Training Room'),
    Reservation(id: '9', clientName: 'Sami Jebali', date: DateTime.now().add(const Duration(days: 8)), activity: 'Conference Room A'),
    Reservation(id: '10', clientName: 'Rim Sassi', date: DateTime.now().add(const Duration(days: 9)), activity: 'Workshop Room'),
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
                reservation.clientName.toLowerCase().contains(query.toLowerCase()))
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
    // Placeholder for add reservation functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouter une nouvelle réservation - À implémenter'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Handle reservation details view
  void _handleViewDetails(Reservation reservation) {
    // Placeholder for view details functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Détails de la réservation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client: ${reservation.clientName}'),
              const SizedBox(height: 8),
              Text('Activité: ${reservation.activity}'),
              const SizedBox(height: 8),
              Text('Date: ${reservation.formattedDate}'),
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
            
            // Bottom Navigation
            BottomNavigation(
              selectedIndex: _selectedNavIndex,
              onItemSelected: _handleNavigation,
            ),
          ],
        ),
      ),
    );
  }
}