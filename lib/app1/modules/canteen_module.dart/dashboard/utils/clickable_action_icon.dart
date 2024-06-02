// Helper method to build each clickable icon item
import 'package:flutter/material.dart';

Widget buildClickableIcon({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 225, 222, 222)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Color.fromARGB(255, 24, 20, 19),
          ),
          SizedBox(height: 8.0),
          Center(
            child: Text(
              label,
              style: TextStyle(
                color: const Color.fromARGB(255, 59, 57, 57),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
