import 'package:flutter/material.dart';
import '../models/club.dart';
import '../screens/club_detail.dart';

class ClubCard extends StatelessWidget {
  final Club club;

  const ClubCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClubDetailPage(id: club.id),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Gambar klub
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: club.urlGambar != null
                  ? Image.network(
                      club.urlGambar!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue.shade200,
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
            ),

            // Text bagian kanan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.flag, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          club.negara,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
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
