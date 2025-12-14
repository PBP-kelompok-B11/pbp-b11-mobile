import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Color highlightColor;
  final Color mainColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.highlightColor,
    required this.mainColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          // BACKGROUND WHITE
          Container(
            height: 200,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
          ),

          // RIGHT lime section
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 200,
              width: width * 0.45,
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),

          // TEXT CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 18,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
