import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class ResultTitle extends StatelessWidget {
  final String keyword;

  const ResultTitle({
    super.key,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Result for ',
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontSize: 48, // mendekati 6xl di Figma
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: AppColors.white,
            ),
          ),
          TextSpan(
            text: '“$keyword”',
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: AppColors.lime,
            ),
          ),
        ],
      ),
    );
  }
}
