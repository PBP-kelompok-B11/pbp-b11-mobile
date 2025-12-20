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
  
        child: Stack(
          children: [

            Positioned.fill(
              child: Image.network(
                // 'https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/proxy-image/?url=${Uri.encodeComponent(thumbnail)}',
                thumbnail,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) {
                  // 🔁 fallback ke proxy
                  final proxyUrl =
                      'https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/proxy-image/?url=${Uri.encodeComponent(thumbnail)}';

                  return Image.network(
                    proxyUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 220,
                                  width: double.infinity,
                                  color: Colors.grey.shade300,
                                );
                            }
                  );
                },
              ),
            ),

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
                        color: AppColors.white, 
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
                            color: AppColors.lime, 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
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