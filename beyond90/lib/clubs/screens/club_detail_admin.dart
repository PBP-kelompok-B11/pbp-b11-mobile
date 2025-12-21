import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:beyond90/comments/screens/comm_list.dart';

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
    final request = context.watch<CookieRequest>(); 
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.lime, size: 32),
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
                          width: double.infinity,
                          padding: const EdgeInsets.all(10), 
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(55),
                            ),
                            color: AppColors.white, 
                          ),
                          child: club.urlGambar != null && club.urlGambar!.isNotEmpty
                              ? Image.network(
                                  club.urlGambar!,
                                  fit: BoxFit.contain, 
                                )
                              : const Icon(
                                  Icons.sports_soccer,
                                  size: 80,
                                  color: Colors.white,
                                ),
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

                        // --- ACTION BUTTONS (Edit, Delete, Comment) ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol EDIT (Hanya jika login)
                                if (request.loggedIn)
                                  _actionButtonSquare(
                                    icon: Icons.edit,
                                    color: Colors.yellow.shade400,
                                    iconColor: AppColors.indigo,
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
                                          futureClub = ClubService.fetchClubDetail(widget.clubId);
                                          futureRankings = ClubRankingService.fetchAllRankings();
                                        });
                                      }
                                    },
                                  ),

                                if (request.loggedIn) const SizedBox(width: 10),

                                // Tombol DELETE (Hanya jika login)
                                if (request.loggedIn)
                                  _actionButtonSquare(
                                    icon: Icons.delete_outline,
                                    color: Colors.red.shade600,
                                    iconColor: Colors.white,
                                    onTap: () async {
                                      _showDeleteConfirmation(context, club.id);
                                    },
                                  ),

                                if (request.loggedIn) const SizedBox(width: 10),

                                // Tombol COMMENT
                                _actionButtonSquare(
                                  imagePath: 'assets/icons/comment.png',
                                  color: AppColors.lime,
                                  iconColor: AppColors.indigo,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.indigo[900],
                                      isScrollControlled: true,
                                      builder: (_) => SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.7,
                                        child: CommentListWidget(
                                          type: 'player', targetId: club.id.toString(), // UUID
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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

  // Helper untuk membuat tombol icon kotak tumpul
  Widget _actionButtonSquare({
    IconData? icon,
    String? imagePath,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 28,
                  height: 28,
                  color: iconColor,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.chat_bubble_outline, color: iconColor, size: 28),
                )
              : Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
        ),
      ),
    );
  }

  // Dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, int clubId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Klub"),
        content: const Text("Apakah kamu yakin ingin menghapus klub ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await ClubService.deleteClub(clubId);
              if (context.mounted) {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke list
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}