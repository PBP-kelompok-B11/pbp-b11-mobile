import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class HistoryHeader extends StatelessWidget {
  final VoidCallback onDeleteAll;

  const HistoryHeader({
    super.key,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // History Label (NOT CLICKABLE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Text(
              "History",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Geologica',
                color: AppColors.indigo,
                height: 1.2,
              ),
            ),
          ),

          // Delete All button (CLICKABLE)
          GestureDetector(
            onTap: onDeleteAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Text(
                "Delete All",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Geologica',
                  color: AppColors.indigo,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
