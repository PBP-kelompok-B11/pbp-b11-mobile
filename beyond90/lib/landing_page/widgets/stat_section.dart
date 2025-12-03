import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 100+
        Text(
          "100+",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Geologica',
            fontSize: 56,
            fontWeight: FontWeight.w800,
            height: 1,
            color: AppColors.lime,
          ),
        ),

        const SizedBox(height: 4),

        // Players, clubs, and competitions
        SizedBox(
          width: 260,
          child: Text(
            "Players, clubs, and competitions",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Geologica',
              fontSize: 22,
              fontWeight: FontWeight.normal,
              height: 1.2,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
