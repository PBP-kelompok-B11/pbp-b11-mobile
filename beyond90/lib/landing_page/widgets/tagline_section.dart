import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class TaglineSection extends StatelessWidget {
  const TaglineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // nanti bisa di-resize responsive
      child: Text(
        "Where football goes beyond the 90 minutes. Explore players, clubs, and events — all in one place.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Geologica',
          fontSize: 19,
          fontWeight: FontWeight.normal,
          height: 1.3,
          color: AppColors.white,
        ),
      ),
    );
  }
}
