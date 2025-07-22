import 'package:flutter/material.dart';
import 'package:mfuborrow/components/nav_bar.dart';
import 'package:mfuborrow/screens/shared_screeens/profile.dart';
import 'package:mfuborrow/screens/lecturer/history.dart';
import 'package:mfuborrow/screens/lecturer/requests.dart';
import 'package:mfuborrow/screens/shared_screeens/home.dart';

class LecturerInitScreen extends StatefulWidget {
  const LecturerInitScreen({super.key});

  @override
  State<LecturerInitScreen> createState() => _LecturerInitStateScreen();
}

class _LecturerInitStateScreen extends State<LecturerInitScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(role: "lecturer"),
    const RequestsScreen(),
    const LecturerHistory(),
    const ProfileScreen()
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
        userRole: "lecturer",
      ),
    );
  }
}
