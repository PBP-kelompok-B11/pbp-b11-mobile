// lib/search/widgets/result_title.dart
import 'package:flutter/material.dart';

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
              fontSize: 32, // 6xl approx
              fontWeight: FontWeight.bold,
              height: 1.2, // leading approx
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: '“$keyword”',
            style: const TextStyle(
              fontFamily: 'Geologica',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Color(0xFFB0FE08), // neon green
            ),
          ),
        ],
      ),
    );
  }
}
