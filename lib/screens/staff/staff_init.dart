import 'package:flutter/material.dart';
import 'package:mfuborrow/components/nav_bar.dart';
import 'package:mfuborrow/screens/shared_screeens/profile.dart';
import 'package:mfuborrow/screens/shared_screeens/home.dart';
import 'package:mfuborrow/screens/staff/history.dart';
import 'package:mfuborrow/screens/staff/return.dart';

class StaffInitialScreen extends StatefulWidget {
  const StaffInitialScreen({super.key});

  @override
  State<StaffInitialScreen> createState() => _StaffInitialScreenState();
}

class _StaffInitialScreenState extends State<StaffInitialScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(role: "staff"),
    const ReturnScreen(),
    const StaffHistory(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        userRole: "staff",
      ),
    );
  }
}
