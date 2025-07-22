import 'package:flutter/material.dart';
import 'package:mfuborrow/components/nav_bar.dart';
import 'package:mfuborrow/screens/shared_screeens/profile.dart';
import 'package:mfuborrow/screens/shared_screeens/home.dart';
import 'package:mfuborrow/screens/student/history.dart';
import 'package:mfuborrow/screens/student/request.dart';

class StudentInitialScreen extends StatefulWidget {
  const StudentInitialScreen({super.key});

  @override
  State<StudentInitialScreen> createState() => _StudentInitialScreenState();
}

class _StudentInitialScreenState extends State<StudentInitialScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(role: "student"),
    const Request(),
    const StudentHistory(),
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
        userRole: "student",
      ),
    );
  }
}
