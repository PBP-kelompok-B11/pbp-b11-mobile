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
        height: 300, 
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Warna fallback jika gambar gagal
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: AppColors.indigo,
            width: 4,
          ),
        ),
        // 🔥 Gunakan Stack agar teks bisa berada DI ATAS gambar
        child: Stack(
          children: [
            // 1. BACKGROUND IMAGE (Full memenuhi sisa ruang)
            Positioned.fill(
              child: Image.network(
                thumbnail,
                fit: BoxFit.cover, // Gambar akan selalu memenuhi sisa ruang
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50),
              ),
            ),

            // 2. GRADIENT OVERLAY (PENTING: Agar teks tetap terbaca jika gambarnya terang)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.indigo.withOpacity(0.8), // Gradasi gelap di bawah teks
                    ],
                    stops: const [0.5, 1.0], // Gradasi mulai dari tengah ke bawah
                  ),
                ),
              ),
            ),

            // 3. DETAIL CONTENT (Teks didorong ke paling bawah)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geologica',
                        color: AppColors.white, // Ubah ke putih karena background-nya sekarang gambar/gelap
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.shield, color: AppColors.indigo, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          posisi,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Geologica',
                            color: AppColors.lime, // Pakai lime agar kontras dengan indigo/gambar
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tombol Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(15),
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