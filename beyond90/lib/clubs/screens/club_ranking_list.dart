import 'package:flutter/material.dart';
import '../service/club_ranking_service.dart';
import '../models/club_ranking.dart';

class ClubRankingListPage extends StatefulWidget {
  const ClubRankingListPage({super.key});

  @override
  _ClubRankingListPageState createState() => _ClubRankingListPageState();
}

class _ClubRankingListPageState extends State<ClubRankingListPage> {
  late Future<List<ClubRanking>> futureRankings;

  Color get indigo => const Color(0xFF1E1B4B);
  Color get lime => const Color(0xFFBEF264);

  @override
  void initState() {
    super.initState();
    futureRankings = ClubRankingService.fetchAllRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // TITLE PAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Club Rankings",
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: lime,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SEARCH BAR (dummy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(54),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      "Search ranking...",
                      style: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LIST RANKING
            Expanded(
              child: FutureBuilder<List<ClubRanking>>(
                future: futureRankings,
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

                  final rankings = snapshot.data ?? [];

                  if (rankings.isEmpty) {
                    return const Center(
                      child: Text(
                        "No rankings available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      final ranking = rankings[index];

                      return _rankingCard(ranking);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== RANKING CARD UI =======================

  Widget _rankingCard(ClubRanking ranking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // NUMBER ICON
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: lime,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              ranking.peringkat.toString(),
              style: TextStyle(
                fontFamily: "Geologica",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: indigo,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // RANKING INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Season ${ranking.musim}",
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: indigo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ranked #${ranking.peringkat}",
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 16,
                  color: indigo.withOpacity(0.7),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
