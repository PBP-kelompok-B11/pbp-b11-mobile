import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'category_arrow.dart';

class CategoryCardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;

  const CategoryCardContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.indigo,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontSize: 20,
              color: AppColors.indigo,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 22,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(width: 8),
                const CategoryArrow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
