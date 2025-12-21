import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/clubs/widgets/club_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../service/club_service.dart';
import '../models/club.dart';
import 'club_detail_admin.dart';
import 'club_form.dart';

class ClubListAdmin extends StatefulWidget {
  const ClubListAdmin({super.key});

  @override
  State<ClubListAdmin> createState() => _ClubListAdminState();
}

class _ClubListAdminState extends State<ClubListAdmin> {
  late Future<List<Club>> _futureClubs;

  @override
  void initState() {
    super.initState();
    _futureClubs = ClubService.fetchClubs();
  }

  void _refreshClubs() {
    setState(() {
      _futureClubs = ClubService.fetchClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lime, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Club",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 28, // Disesuaikan ukurannya dengan style Player (28)
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // TOMBOL ADD DI DALAM ACTIONS (Sesuai style Player List)
          if (request.loggedIn)
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.lime,
                size: 30, // Ukuran disamakan dengan Player (30)
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClubForm(),
                  ),
                );
                if (result == true) _refreshClubs();
              },
            ),
          const SizedBox(width: 12), // Padding kanan disamakan (12)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // CLUB GRID (Logic Snapshot Tidak Berubah)
          Expanded(
            child: FutureBuilder<List<Club>>(
              future: _futureClubs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                    ),
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
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      // Tetap 0.75 agar tidak overflow teksnya
                      childAspectRatio: 0.75, 
                    ),
                    itemBuilder: (context, index) {
                      final club = clubs[index];

                      return ClubCard(
                        imageUrl: club.urlGambar ?? "",
                        clubName: club.nama,
                        location: club.negara,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClubDetailAdmin(clubId: club.id),
                            ),
                          );
                          if (result == true) _refreshClubs();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2, // CATEGORY
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