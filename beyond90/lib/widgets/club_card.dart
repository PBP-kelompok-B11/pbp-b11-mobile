import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class ClubCard extends StatelessWidget {
  final String imageUrl;
  final String clubName;
  final String location;
  final VoidCallback onTap;

  const ClubCard({
    super.key,
    required this.imageUrl,
    required this.clubName,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Grey card background (Figma)
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            // IMAGE
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

            // CLUB NAME
            Text(
              clubName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32, // 6xl approx (sama Player/Event)
                fontWeight: FontWeight.bold,
                fontFamily: 'Geologica',
                color: AppColors.indigo,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // LOCATION
            Text(
              location,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Geologica',
                color: AppColors.indigo,
              ),
            ),

            const SizedBox(height: 14),

            // DETAILS BUTTON
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
