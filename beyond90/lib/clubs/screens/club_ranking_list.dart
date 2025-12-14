import 'package:flutter/material.dart';
import '../service/club_ranking_service.dart';
import '../models/club_ranking.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

class ClubRankingListPage extends StatefulWidget {
  const ClubRankingListPage({super.key});

  @override
  State<ClubRankingListPage> createState() => _ClubRankingListPageState();
}

class _ClubRankingListPageState extends State<ClubRankingListPage> {
  late Future<List<ClubRanking>> futureRankings;
  int _selectedIndex = 2; // Category active

  @override
  void initState() {
    super.initState();
    futureRankings = ClubRankingService.fetchAllRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Club Rankings",
                style: const TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lime,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // LIST
            Expanded(
              child: FutureBuilder<List<ClubRanking>>(
                future: futureRankings,
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

                  final rankings = snapshot.data ?? [];

                  if (rankings.isEmpty) {
                    return const Center(
                      child: Text(
                        "No rankings available",
                        style: TextStyle(color: AppColors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      return _rankingCard(rankings[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVBAR
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          // nanti routing di-handle di sini
        },
      ),
    );
  }

  // ================= CARD =================

  Widget _rankingCard(ClubRanking ranking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // NUMBER
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              ranking.peringkat.toString(),
              style: const TextStyle(
                fontFamily: "Geologica",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.indigo,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Season ${ranking.musim}",
                style: const TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.indigo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ranked #${ranking.peringkat}",
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 16,
                  color: AppColors.indigo.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
