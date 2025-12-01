import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart'; 
class SeeMoreButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SeeMoreButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.indigo,
            size: 28,
          ),
        ),
      ),
    );
  }
}
