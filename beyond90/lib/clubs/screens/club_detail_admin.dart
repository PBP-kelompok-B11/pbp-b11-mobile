import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

import '../models/club.dart';
import '../models/club_ranking.dart';
import '../service/club_service.dart';
import '../service/club_ranking_service.dart';
import 'club_form.dart';

class ClubDetailAdmin extends StatefulWidget {
  final int clubId;

  const ClubDetailAdmin({super.key, required this.clubId});

  @override
  State<ClubDetailAdmin> createState() => _ClubDetailAdminState();
}

class _ClubDetailAdminState extends State<ClubDetailAdmin> {
  final bool isAdmin = AuthService.isAdmin;

  late Future<Club> futureClub;
  late Future<List<ClubRanking>> futureRankings;

  int? _currentRanking;
  int? _currentRankingId;

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
          icon: const Icon(Icons.arrow_back,
              color: AppColors.white, size: 32),
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
                const SizedBox(height: 16),
                
                // MAIN CARD
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 12),
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
                            image: club.urlGambar != null &&
                                    club.urlGambar!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(club.urlGambar!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (club.urlGambar == null ||
                                  club.urlGambar!.isEmpty)
                              ? const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.black45,
                                  ),
                                )
                              : null,
                        ),

                        const SizedBox(height: 24),

                        // NAME
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
                                fontSize: 24,
                                color: AppColors.indigo,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _limeBar("Stadion: ${club.stadion}"),
                        _limeBar("Tahun Berdiri: ${club.tahunBerdiri}"),

                        // RANKING 
                        FutureBuilder<List<ClubRanking>>(
                          future: futureRankings,
                          builder: (context, rankSnapshot) {
                            if (!rankSnapshot.hasData) {
                              _currentRanking = null;
                              _currentRankingId = null;
                              return _limeBar("Ranking Klub: -");
                            }

                            final filtered = rankSnapshot.data!
                                .where((r) => r.club == club.id)
                                .toList();

                            if (filtered.isEmpty) {
                              _currentRanking = null;
                              _currentRankingId = null;
                              return _limeBar("Ranking Klub: -");
                            }

                            final ranking = filtered.first;
                            _currentRanking = ranking.peringkat;
                            _currentRankingId = ranking.id;

                            return _limeBar(
                                "Ranking Klub: ${ranking.peringkat}");
                          },
                        ),

                        const SizedBox(height: 24),

                        if (AuthService.isAdmin) ...[
                          _adminButton(
                            label: "Edit Club",
                            background: Colors.yellow.shade400,
                            textColor: AppColors.indigo,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClubForm(
                                    club: club,
                                    ranking: _currentRanking,
                                    rankingId: _currentRankingId,
                                  ),
                                ),
                              );

                              if (result == true) {
                                setState(() {
                                  futureClub =
                                      ClubService.fetchClubDetail(widget.clubId);
                                  futureRankings =
                                      ClubRankingService.fetchAllRankings();
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _adminButton(
                            label: "Delete Club",
                            background: Colors.red.shade600,
                            textColor: AppColors.white,
                            onTap: () async {
                              await ClubService.deleteClub(club.id);
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2,
        onTap: (_) {},
      ),
    );
  }

  Widget _limeBar(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
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
            fontSize: 20,
            color: AppColors.indigo,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _adminButton({
    required String label,
    required Color background,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(34),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: "Geologica",
              fontSize: 20,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
