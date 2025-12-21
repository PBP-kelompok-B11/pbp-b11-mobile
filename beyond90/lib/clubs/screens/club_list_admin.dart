import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/clubs/widgets/club_card.dart'; // Pastikan path widget benar
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
  // final bool isAdmin = AuthService.isAdmin; jangan pake ini, soalnya klo pencet tombol logout masih muncul tombol add clubnya

  late Future<List<Club>> _futureClubs;

  @override
  void initState() {
    super.initState();
    _futureClubs = ClubService.fetchClubs();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Club",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.lime,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // ADD CLUB (ADMIN ONLY)
                if (request.loggedIn)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ClubForm(),
                        ),
                      );
                    },
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(54),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Add Club",
                        style: TextStyle(
                          fontFamily: "Geologica",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.indigo,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CLUB GRID
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
                      // Diubah ke 0.85 agar kartu tidak terlalu melar ke bawah (pendek dikit)
                      childAspectRatio: 0.85, 
                    ),
                    itemBuilder: (context, index) {
                      final club = clubs[index];

                      return ClubCard(
                        imageUrl: club.urlGambar ?? "",
                        clubName: club.nama,
                        location: club.negara,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClubDetailAdmin(clubId: club.id),
                            ),
                          );
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