import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class CategoryArrow extends StatelessWidget {
  const CategoryArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      size: 18,
      color: AppColors.indigo,
    );
  }
}
