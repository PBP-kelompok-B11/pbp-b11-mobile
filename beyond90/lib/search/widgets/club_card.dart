import 'package:flutter/material.dart';

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
          color: const Color(0xFFD9D9D9), // light gray background
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            // 🖼️ IMAGE PART
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            // 🏟️ CLUB NAME
            Text(
              clubName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24, // text-6xl equivalent scaled
                fontWeight: FontWeight.bold,
                color: Color(0xFF261893), // text-indigo-900
                fontFamily: 'Geologica',
                height: 1.2, // leading adjustment
              ),
            ),

            const SizedBox(height: 8),

            // 📍 LOCATION
            Text(
              location,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18, // text-3xl scaled
                color: Color(0xFF261893),
                fontFamily: 'Geologica',
              ),
            ),

            const SizedBox(height: 16),

            // 🔘 DETAILS BUTTON
            Container(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB0FE08), // lime button #B0FE08
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  'Details',
                  style: const TextStyle(
                    fontSize: 20, // text-4xl scaled
                    color: Color(0xFF261893),
                    fontFamily: 'Geologica',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
