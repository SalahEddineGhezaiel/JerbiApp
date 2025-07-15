import 'package:flutter/material.dart';
import '../reservations/reservations_content.dart';
import '../statistics/statistics_content.dart';
import '../settings/settings_content.dart';
import '../../shared/widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    const ReservationsContent(),
    const StatisticsContent(),
    const SettingsContent(),
  ];

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _handleNavigation,
      ),
    );
  }
}