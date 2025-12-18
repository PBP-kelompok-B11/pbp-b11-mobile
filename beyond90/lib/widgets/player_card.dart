import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class PlayerCard extends StatelessWidget {
  final String thumbnail;
  final String nama;
  final String negara;
  final int usia;
  final double tinggi;
  final double berat;
  final String posisi;
  final VoidCallback onTap;

  const PlayerCard({
    super.key,
    required this.thumbnail,
    required this.nama,
    required this.negara,
    required this.usia,
    required this.tinggi,
    required this.berat,
    required this.posisi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255), // sesuai Figma grey
          borderRadius: BorderRadius.circular(35),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Player Image
            Image.network(
              thumbnail,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(height: 10),

            // Player Name
            // White section with details
            Expanded( // Wrap dengan Expanded
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Player Name
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Geologica',
                        color: AppColors.indigo,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Position with Badge Icon
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.indigo,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          posisi,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Geologica',
                            color: AppColors.indigo,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(), 

                    // Details Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 24,
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
