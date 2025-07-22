import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  final String userRole;

  const NavBar(
      {super.key,
      required this.selectedIndex,
      required this.onTap,
      required this.userRole});

  String _getLabelText() {
    if (userRole == "student") {
      return "Request";
    } else if (userRole == "staff") {
      return "Return";
    } else {
      return "Requests";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.black.withOpacity(0.6),
          currentIndex: selectedIndex,
          onTap: onTap,
          items: [
            const BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/home.png'), size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage('assets/icons/education.png'),
                  size: 30),
              label: _getLabelText(),
            ),
            const BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/layer.png'), size: 30),
              label: 'History',
            ),
            const BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/user.png'), size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
