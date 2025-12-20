import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 200, // Sedikit ditinggikan (dari 180 ke 200) agar font gede muat lebih banyak
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // 1. BACKGROUND LIME (Setengah Kanan)
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(color: AppColors.lime),
              ),
            ),

            // 2. KONTEN UTAMA
            Row(
              children: [
                // SISI KIRI (PUTIH)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1, // Judul jangan sampai turun ke bawah
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Geologica',
                            fontSize: 28, // Font title diperbesar
                            fontWeight: FontWeight.w900,
                            color: AppColors.indigo,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // PROTEKSI SUBTITLE AGAR TIDAK OVERFLOW
                        Flexible(
                          child: Text(
                            subtitle,
                            maxLines: 3, // Maksimal 3 baris
                            overflow: TextOverflow.ellipsis, // Jadi titik-titik kalau kepanjangan
                            style: TextStyle(
                              fontFamily: 'Geologica',
                              fontSize: 18, // Font diperbesar sesuai request
                              color: AppColors.indigo.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              height: 1.2, // Atur jarak antar baris teks
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // SISI KANAN (HIJAU LIME)
                Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.double_arrow_rounded,
                            color: AppColors.indigo,
                            size: 45, // Icon diperbesar
                          ),
                          const SizedBox(height: 10),
                          Text(
                            actionText.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2, // Biar kalau teks action panjang, tidak overflow
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Geologica',
                              fontSize: 16, // Font action diperbesar
                              fontWeight: FontWeight.w900,
                              color: AppColors.indigo,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}