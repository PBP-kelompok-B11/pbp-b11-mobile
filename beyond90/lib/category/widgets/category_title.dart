import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24),
      child: Text(
        'Categories',
        style: TextStyle(
          fontFamily: 'Geologica',
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.lime,
        ),
      ),
    );
  }
}
