import 'package:flutter/material.dart';
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

  Color get indigo => const Color(0xFF1E1B4B);
  Color get lime => const Color(0xFFBEF264);

  @override
  void initState() {
    super.initState();
    futureClub = ClubService.fetchClubDetail(widget.clubId);
    futureRankings = ClubRankingService.fetchAllRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: indigo,
      appBar: AppBar(
        backgroundColor: indigo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Club details",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 32,
            color: lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Club>(
        future: futureClub,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final club = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: Column(
                      children: [
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

                        Text(
                          club.nama.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Geologica",
                            fontSize: 46,
                            color: indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("📍", style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 6),
                            Text(
                              club.negara,
                              style: TextStyle(
                                fontFamily: "Geologica",
                                fontSize: 26,
                                color: indigo,
                                fontWeight: FontWeight.w500,
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

                            final allRankings = rankSnapshot.data!;
                            final filtered = allRankings.where((r) => r.club == club.id).toList();

                            if (filtered.isEmpty) {
                              return _limeBar("Ranking Klub: -");
                            }

                            final ranking = filtered.first;

                            return _limeBar("Ranking Klub: ${ranking.peringkat}");
                          },
                        ),
                        const SizedBox(height: 32),

                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: lime,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            size: 36,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        height: 80,
        color: lime,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.home, "Home"),
            _navItem(Icons.search, "Explore"),
            _navItem(Icons.category, "Category", isActive: true),
            _navItem(Icons.play_circle_fill, "Media"),
          ],
        ),
      ),
    );
  }

  Widget _limeBar(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      height: 50,
      decoration: BoxDecoration(
        color: lime,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 22,
            color: indigo,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: isActive ? indigo : Colors.black,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: "Geologica",
            color: isActive ? indigo : Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
