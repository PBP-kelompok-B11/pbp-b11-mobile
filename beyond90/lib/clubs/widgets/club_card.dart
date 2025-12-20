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
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6, // Kita sesuaikan flex-nya agar pas
              child: Container(
                padding: const EdgeInsets.all(20), // Memberi ruang agar logo tidak nempel pinggir
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain, // 👈 Kuncinya di sini: Logo akan terlihat full
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.sports_soccer, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // ================= CONTENT (Flex dikurangi jadi 3) =================
            Expanded(
              flex: 3, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Membagi ruang teks & tombol secara rata
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clubName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Geologica',
                            color: AppColors.indigo,
                          ),
                        ),
                        Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Geologica',
                            color: AppColors.indigo,
                          ),
                        ),
                      ],
                    ),
                    // ================= DETAILS BUTTON =================
                    Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Geologica',
                            color: AppColors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}