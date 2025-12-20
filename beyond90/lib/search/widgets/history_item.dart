import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SearchHistoryItem extends StatelessWidget {
  final String keyword;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryItem({
    super.key,
    required this.keyword,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lime, width: 2),
          borderRadius: BorderRadius.circular(53),
        ),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppColors.lime),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                keyword,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: 'Geologica',
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.close, color: AppColors.lime),
            ),
          ],
        ),
      ),
    );
  }
}
