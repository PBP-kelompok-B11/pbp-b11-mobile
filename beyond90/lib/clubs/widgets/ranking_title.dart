import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class RankingTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const RankingTitle({
    super.key,
    required this.title,
    this.icon = Icons.leaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 26,
              color: AppColors.indigo,
            ),
          ),

          const SizedBox(width: 14),

          // TITLE
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.lime,
            ),
          ),

          const Spacer(),

          // DECORATIVE LINE
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
