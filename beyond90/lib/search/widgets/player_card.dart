import 'package:flutter/material.dart';

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
        width: 220, // adjust grid size
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Gray background
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼️ Player Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            // ✍️ Player Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24, // text-6xl scaled
                fontWeight: FontWeight.bold,
                color: Color(0xFF261893), // Indigo 900
                fontFamily: 'Geologica',
                height: 1.2,
              ),
            ),

            const SizedBox(height: 6),

            // 🏷️ Position Badge area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon placeholder (role icon)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF261893),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),

                // Position text
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 18, // text-3xl scaled
                    fontFamily: 'Geologica',
                    color: Color(0xFF261893),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 🔘 Details Button
            Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB0FE08), // Lime button
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Center(
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 20, // text-4xl scaled
                    fontFamily: 'Geologica',
                    color: Color(0xFF261893),
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
