import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

import '../models/club.dart';
import '../models/club_ranking.dart';
import '../service/club_service.dart';
import '../service/club_ranking_service.dart';

class ClubDetailUser extends StatefulWidget {
  final int clubId;

  const ClubDetailUser({super.key, required this.clubId});

  @override
  State<ClubDetailUser> createState() => _ClubDetailUserState();
}

class _ClubDetailUserState extends State<ClubDetailUser> {
  late Future<Club> futureClub;
  late Future<List<ClubRanking>> futureRankings;

  @override
  
  void initState() {
    super.initState();
    futureClub = ClubService.fetchClubDetail(widget.clubId);
    futureRankings = ClubRankingService.fetchAllRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Club details",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 32,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<Club>(
        future: futureClub,
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

          final club = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: Column(
                      children: [
                        // IMAGE
                        Container(
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(55),
                            ),
                            color: Colors.grey.shade300,
                            image: club.urlGambar != null
                                ? DecorationImage(
                                    image: NetworkImage(club.urlGambar!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // CLUB NAME
                        Text(
                          club.nama.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Geologica",
                            fontSize: 46,
                            color: AppColors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // LOCATION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("📍", style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 6),
                            Text(
                              club.negara,
                              style: const TextStyle(
                                fontFamily: "Geologica",
                                fontSize: 26,
                                color: AppColors.indigo,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        _limeBar("Stadion: ${club.stadion}"),
                        _limeBar("Tahun Berdiri: ${club.tahunBerdiri}"),

                        FutureBuilder<List<ClubRanking>>(
                          future: futureRankings,
                          builder: (context, rankSnapshot) {
                            if (!rankSnapshot.hasData) {
                              return _limeBar("Ranking Klub: -");
                            }

                            final filtered = rankSnapshot.data!
                                .where((r) => r.club == club.id)
                                .toList();

                            return filtered.isEmpty
                                ? _limeBar("Ranking Klub: -")
                                : _limeBar(
                                    "Ranking Klub: ${filtered.first.peringkat}",
                                  );
                          },
                        ),

                        const SizedBox(height: 32),

                        // CHAT ICON
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            size: 36,
                            color: AppColors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),

      // BOTTOM NAVBAR 
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2, // Category
        onTap: (index) {
        },
      ),
    );
  }

  // HELPERS

  Widget _limeBar(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Geologica",
            fontSize: 22,
            color: AppColors.indigo,
          ),
        ),
      ),
    );
  }
}
