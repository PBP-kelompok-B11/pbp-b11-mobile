import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class NextCategoryButton extends StatelessWidget {
  final String category;


  const NextCategoryButton({super.key, required this.category});

  void _handleNavigation(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNavigation(context),
      child: SizedBox(
        width: 80,
        height: 64,
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Positioned(
              right: 18,
              top: 18,
              child: Icon(
                Icons.arrow_forward,
                size: 28,
                color: AppColors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
