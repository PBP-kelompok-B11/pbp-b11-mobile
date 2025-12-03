import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart'; 

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.lime,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.search, "Explore", 1),
          _navItem(Icons.layers, "Category", 2),
          _navItem(Icons.play_circle_fill, "Media", 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isActive ? AppColors.indigo : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isActive ? AppColors.lime : AppColors.indigo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontSize: 14,
              color: AppColors.indigo,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
