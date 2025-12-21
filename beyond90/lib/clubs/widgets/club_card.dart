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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Menghitung ukuran berdasarkan ketersediaan ruang card
          // maxWidth biasanya lebih stabil untuk dijadikan patokan font
          final double cardWidth = constraints.maxWidth;
          final double cardHeight = constraints.maxHeight;

          // Rasio Dinamis
          final double titleFontSize = cardWidth * 0.11; // 11% dari lebar card
          final double subTitleFontSize = cardWidth * 0.08; // 8% dari lebar card
          final double paddingEdge = cardWidth * 0.08; // Padding tepi 8%
          final double imagePadding = cardHeight * 0.05; // Padding gambar 5% dari tinggi

          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardWidth * 0.15), // Border radius mengikuti lebar
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 1. AREA GAMBAR (Adaptif terhadap Tinggi Card)
                Expanded(
                  flex: 5, // Mengambil 5 bagian dari total 9
                  child: Container(
                    padding: EdgeInsets.all(imagePadding),
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.sports_soccer,
                        size: cardWidth * 0.4,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

                // 2. AREA INFORMASI (Adaptif terhadap sisa ruang)
                Expanded(
                  flex: 4, // Mengambil 4 bagian dari total 9
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingEdge, 0, paddingEdge, paddingEdge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Teks Nama & Lokasi
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                clubName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: titleFontSize.clamp(14, 24), // Batas aman mata
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Geologica',
                                  color: AppColors.indigo,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: cardHeight * 0.01),
                              Text(
                                location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: subTitleFontSize.clamp(10, 16),
                                  fontFamily: 'Geologica',
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 3. TOMBOL DETAILS (Proporsional terhadap tinggi card)
                        Container(
                          width: double.infinity,
                          // Tinggi tombol otomatis 15% dari total tinggi card
                          height: (cardHeight * 0.15).clamp(28, 45), 
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(100), // Selalu bulat sempurna
                          ),
                          child: Center(
                            child: Text(
                              'Details',
                              style: TextStyle(
                                // Font tombol 70% dari font judul
                                fontSize: (titleFontSize * 0.7).clamp(10, 15),
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
          );
        },
      ),
    );
  }
}