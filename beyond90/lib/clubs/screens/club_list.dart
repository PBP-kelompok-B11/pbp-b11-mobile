import 'package:flutter/material.dart';
import '../service/club_service.dart';
import '../models/club.dart';
import 'club_detail_user.dart';

class ClubListPage extends StatefulWidget {
  @override
  _ClubListPageState createState() => _ClubListPageState();
}

class _ClubListPageState extends State<ClubListPage> {
  late Future<List<Club>> futureClubs;

  @override
  void initState() {
    super.initState();
    futureClubs = ClubService.fetchClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Klub")),
      body: FutureBuilder<List<Club>>(
        future: futureClubs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final clubs = snapshot.data!;

          return ListView.builder(
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              final club = clubs[index];

              return ListTile(
                leading: club.urlGambar != null
                    ? Image.network(club.urlGambar!)
                    : Icon(Icons.sports_soccer),
                title: Text(club.nama),
                subtitle: Text(club.negara),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClubDetailUser(clubId: club.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
