import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Card grey dari Figma
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            // Banner Event
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

            // Judul Event
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32, // mengikuti PlayerCard style
                fontWeight: FontWeight.bold,
                fontFamily: 'Geologica',
                color: AppColors.indigo,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 6),

            // Tanggal Event + icon
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
                  date,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Geologica',
                    color: AppColors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Tombol Details
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
