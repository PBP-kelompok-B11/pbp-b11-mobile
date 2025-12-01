import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class PlayerCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final VoidCallback onTap;

  const PlayerCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // sesuai Figma grey
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Player Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            // Player Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32, // 6xl approx sesuai desain
                fontWeight: FontWeight.bold,
                fontFamily: 'Geologica',
                color: AppColors.indigo,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 6),

            // Position with Badge Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.indigo,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Geologica',
                    color: AppColors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Details Button
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Center(
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Geologica',
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
