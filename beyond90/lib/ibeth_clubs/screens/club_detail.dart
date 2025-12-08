import 'package:flutter/material.dart';
import '../service/club_service.dart';
import '../models/club.dart';
import 'club_form.dart';

class ClubDetailPage extends StatefulWidget {
  final int id;

  const ClubDetailPage({super.key, required this.id});

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

  void _confirmDelete(BuildContext context, int clubId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Club"),
          content: const Text("Apakah kamu yakin ingin menghapus club ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // tutup dialog

                try {
                  await ClubService.deleteClub(clubId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Club berhasil dihapus!")),
                  );

                  Navigator.pop(context); // kembali ke list club
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Klub"),
        actions: [
          // --- TOMBOL EDIT ---
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final club = await futureClub; // Ambil data club dulu

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClubFormPage(club: club),
                ),
              );

              if (result == true) {
                setState(() {
                  futureClub = ClubService.fetchClubDetail(widget.id);
                });
              }
            },
          ),

          // --- TOMBOL DELETE ---
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final club = await futureClub;
              _confirmDelete(context, club.id);
            },
          ),
        ],
      ),

      // --- BODY DETAIL CLUB ---
      body: FutureBuilder<Club>(
        future: futureClub,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final club = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Center(
                  child: club.urlGambar != null
                      ? Image.network(
                          club.urlGambar!,
                          height: 150,
                        )
                      : const Icon(Icons.sports_soccer, size: 80),
                ),
                const SizedBox(height: 20),
                Text("Nama: ${club.nama}",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text("Negara: ${club.negara}"),
                const SizedBox(height: 10),
                Text("Stadion: ${club.stadion}"),
                const SizedBox(height: 10),
                Text("Tahun Berdiri: ${club.tahunBerdiri}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
