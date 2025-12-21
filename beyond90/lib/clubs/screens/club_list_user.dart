import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/clubs/widgets/club_card.dart';

import '../service/club_service.dart';
import '../models/club.dart';
import 'club_detail_user.dart';

class ClubListUser extends StatefulWidget {
  const ClubListUser({super.key});

  @override
  State<ClubListUser> createState() => _ClubListUserState();
}

class _ClubListUserState extends State<ClubListUser> {
  late Future<List<Club>> _futureClubs;

  @override
  void initState() {
    super.initState();
    _futureClubs = ClubService.fetchClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded, 
            color: AppColors.lime, 
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Club",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 36,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<Club>>(
        future: _futureClubs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: AppColors.white),
              ),
            );
          }

          final clubs = snapshot.data ?? [];

          if (clubs.isEmpty) {
            return const Center(
              child: Text(
                "No clubs available",
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: clubs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final club = clubs[index];

                // Di dalam ClubListUser
                return ClubCard(
                  imageUrl: club.urlGambar ?? "", // Tetap kirim satu per satu
                  clubName: club.nama,
                  location: club.negara,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ClubDetailUser(clubId: club.id)),
                    );
                  },
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 2) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/media_gallery');
              break;
          }
        },
      ),
    );
  }
}
