import 'package:flutter/material.dart';

void showErrorSnackBar(
    BuildContext context, String message, IconData icon, Color color) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white), // Error icon
        const SizedBox(width: 8), // Space between icon and text
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white), // Text style
          ),
        ),
      ],
    ),
    backgroundColor: color, // Background color
    behavior: SnackBarBehavior.floating, // Floating SnackBar
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    duration: const Duration(seconds: 3), // Duration before SnackBar disappears
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
