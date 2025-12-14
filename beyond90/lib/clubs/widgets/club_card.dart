import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import '../models/club.dart';

class ClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubCard({
    super.key,
    required this.club,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(35),
              ),
              child: club.urlGambar != null && club.urlGambar!.isNotEmpty
                  ? Image.network(
                      club.urlGambar!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
            ),

            const SizedBox(height: 12),

            // CLUB NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                club.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.indigo,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // LOCATION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text("📍", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      club.negara,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: AppColors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // DETAILS BUTTON
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
