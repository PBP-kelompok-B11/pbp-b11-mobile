import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Geologica',
          fontWeight: FontWeight.bold,
          fontSize: 28, 
          color: AppColors.lime,
        ),
      ),
    );
  }
}
