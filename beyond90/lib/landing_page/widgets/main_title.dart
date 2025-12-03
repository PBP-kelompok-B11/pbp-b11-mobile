import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';


// Ini yang tulisan BEYOND 90 di landing page
class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // BEYOND
        Text(
          "BEYOND",
          style: TextStyle(
            fontFamily: 'LeagueGothic', // pastikan font sudah di-register di pubspec.yaml
            fontSize: 140, // responsive nanti bisa pakai MediaQuery
            color: AppColors.white,
            height: 0.9,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),

        // 90
        Text(
          "90",
          style: TextStyle(
            fontFamily: 'LeagueGothic',
            fontSize: 160,
            color: AppColors.white,
            height: 0.9,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
