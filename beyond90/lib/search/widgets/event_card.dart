import 'package:flutter/material.dart';

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
          color: const Color(0xFFD9D9D9), // zinc-300
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            // 🖼️ Event Banner
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(35),
              ),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            // 🎟️ EVENT TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24, // scaled from 6xl
                fontWeight: FontWeight.bold,
                color: Color(0xFF261893),
                fontFamily: 'Geologica',
                height: 1.2,
              ),
            ),

            const SizedBox(height: 6),

            // 🗓️ DATE + ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon date placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF261893), // indigo-900
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF261893),
                    fontFamily: 'Geologica',
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
                color: const Color(0xFFB0FE08), // lime-400
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  'Details',
                  style: const TextStyle(
                    fontSize: 20,
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
