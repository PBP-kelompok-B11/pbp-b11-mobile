import 'package:flutter/material.dart';
import '../service/club_ranking_service.dart';
import '../models/club_ranking.dart';

class ClubRankingListPage extends StatefulWidget {
  @override
  _ClubRankingListPageState createState() => _ClubRankingListPageState();
}

class _ClubRankingListPageState extends State<ClubRankingListPage> {
  late Future<List<ClubRanking>> futureRankings;

  @override
  void initState() {
    super.initState();
    futureRankings = ClubRankingService.fetchAllRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Ranking Klub"),
      ),
      body: FutureBuilder<List<ClubRanking>>(
        future: futureRankings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final rankings = snapshot.data!;

          return ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              final ranking = rankings[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      ranking.peringkat.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text("Musim: ${ranking.musim}"),
                  subtitle: Text("Peringkat ke-${ranking.peringkat}"),
                  // onTap: () => Navigator.push(...detail ranking...),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
