import 'package:flutter/material.dart';
import '../service/club_service.dart';
import '../models/club.dart';

class ClubDetailPage extends StatefulWidget {
  final int id;

  ClubDetailPage({required this.id});

  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  late Future<Club> futureClub;

  @override
  void initState() {
    super.initState();
    futureClub = ClubService.fetchClubDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Klub")),
      body: FutureBuilder<Club>(
        future: futureClub,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final club = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: club.urlGambar != null
                      ? Image.network(club.urlGambar!)
                      : Icon(Icons.sports_soccer, size: 80),
                ),
                SizedBox(height: 20),
                Text("Nama: ${club.nama}", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Negara: ${club.negara}"),
                SizedBox(height: 10),
                Text("Stadion: ${club.stadion}"),
                SizedBox(height: 10),
                Text("Tahun Berdiri: ${club.tahunBerdiri}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
