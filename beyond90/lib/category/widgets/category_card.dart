import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'category_card_content.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          // Lime side block
          Positioned(
            right: 0,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),

          CategoryCardContent(
            title: title,
            subtitle: subtitle,
            actionText: actionText,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
