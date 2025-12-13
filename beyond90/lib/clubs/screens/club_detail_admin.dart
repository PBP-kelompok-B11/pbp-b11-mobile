import 'package:flutter/material.dart';
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
  final bool isAdmin = true;

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
              child: Text("Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final club = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // SEARCH BAR (dummy)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          "Search",
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

                // MAIN CARD
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.symmetric(vertical: 12),
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(55)),
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
                              fontSize: 24,
                              color: indigo,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

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

                          if (filtered.isEmpty) {
                            return _limeBar("Ranking Klub: -");
                          }

                          return _limeBar("Ranking Klub: ${filtered.first.peringkat}");
                        },
                      ),

                      const SizedBox(height: 24),

                      // ===================== ADMIN BUTTONS ======================
                      if (isAdmin) ...[
                        // EDIT BUTTON
                        _adminButton(
                          label: "Edit Club",
                          background: Colors.yellow.shade400,
                          textColor: indigo,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClubForm(club: club),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // DELETE BUTTON
                        _adminButton(
                          label: "Delete Club",
                          background: Colors.red.shade600,
                          textColor: Colors.white,
                          onTap: () async {
                            try {
                              await ClubService.deleteClub(club.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Club Deleted")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                      ],

                      // CHAT BUTTON
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: lime,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.chat_bubble_outline,
                          size: 36,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
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

  // ================= Helper Widgets ===================

  Widget _limeBar(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
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
            fontSize: 20,
            color: indigo,
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

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: isActive ? indigo : Colors.black),
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
