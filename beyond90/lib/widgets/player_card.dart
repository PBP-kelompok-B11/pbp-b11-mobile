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
        height: 380, // Tambahkan height yang fixed
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: AppColors.indigo,
            width: 4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max, // Ubah dari min ke max
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  width: double.infinity,
                  color: const Color(0xFFD9D9D9), // Abu-abu sama seperti sebelumnya
                );
              },
            ),

            // White section with details
            Expanded( // Wrap dengan Expanded
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Player Name
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
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

                    const Spacer(), // Ini yang mendorong tombol ke bawah!

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
