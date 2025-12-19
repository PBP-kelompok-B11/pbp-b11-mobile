import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

import 'package:beyond90/player/models/player_entry.dart';
import 'package:beyond90/player/service/player_service.dart';
import 'package:beyond90/player/screens/player_entry_list.dart';
import 'package:beyond90/player/screens/edit_player_entry.dart';

import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class PlayerDetailEntry extends StatefulWidget {
  final String playerId;

  const PlayerDetailEntry({super.key, required this.playerId});

  @override
  State<PlayerDetailEntry> createState() => _PlayerDetailEntryState();
}

class _PlayerDetailEntryState extends State<PlayerDetailEntry> {
  late Future<PlayerEntry> futurePlayer;
  bool isAchievementExpanded = false;
  bool isSeasonStatsExpanded = false;
  bool isCareerHistoryExpanded = false;

  @override
  void initState() {
    super.initState();
    futurePlayer = PlayerEntryService.fetchPlayerDetail(widget.playerId);
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
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Player details",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 28,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<PlayerEntry>(
        future: futurePlayer,
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

          final player = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    // IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                      child: Image.network(
                        player.thumbnail ?? '',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey.shade300,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // PLAYER NAME
                          Text(
                            player.nama,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "Geologica",
                              fontSize: 36,
                              color: AppColors.indigo,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // POSITION & COUNTRY
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.indigo,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shield,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                player.posisi,
                                style: const TextStyle(
                                  fontFamily: "Geologica",
                                  fontSize: 20,
                                  color: AppColors.indigo,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.indigo,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                player.negara,
                                style: const TextStyle(
                                  fontFamily: "Geologica",
                                  fontSize: 20,
                                  color: AppColors.indigo,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // STATS PILLS (Height, Weight, Age)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _statPill("${player.tinggi.toInt()} Cm"),
                              const SizedBox(width: 10),
                              _statPill("${player.berat.toInt()} Kg"),
                              const SizedBox(width: 10),
                              _statPill("${player.usia} Years"),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ACHIEVEMENTS DROPDOWN
                          _dropdownSection(
                            title: "Achievements",
                            isExpanded: isAchievementExpanded,
                            onTap: () {
                              setState(() {
                                isAchievementExpanded = !isAchievementExpanded;
                              });
                            },
                            children: player.achievement
                                .map((a) => _dataItem("${a.deskripsi} (${a.tahun})"))
                                .toList(),
                          ),

                          const SizedBox(height: 12),

                          // SEASON STATS DROPDOWN
                          _dropdownSection(
                            title: "Season Stats",
                            isExpanded: isSeasonStatsExpanded,
                            onTap: () {
                              setState(() {
                                isSeasonStatsExpanded = !isSeasonStatsExpanded;
                              });
                            },
                            children: player.seasonStats
                                .map((s) => _dataItem(
                                    "${s.musim} - ${s.pertandingan} Match, ${s.gol} Goal, ${s.assist} Assist"))
                                .toList(),
                          ),

                          const SizedBox(height: 12),

                          // CAREER HISTORY DROPDOWN
                          _dropdownSection(
                            title: "Career History",
                            isExpanded: isCareerHistoryExpanded,
                            onTap: () {
                              setState(() {
                                isCareerHistoryExpanded = !isCareerHistoryExpanded;
                              });
                            },
                            children: player.careerHistory.map((c) {
                              String tahunSelesai = c.tahunSelesai != null
                                  ? c.tahunSelesai.toString()
                                  : "Sekarang";
                              return _dataItem(
                                  "${c.klub} (${c.tahunMulai} - $tahunSelesai)");
                            }).toList(),
                          ),

                          const SizedBox(height: 32),

                          // CHAT ICON
                          // ACTION BUTTONS (Edit, Delete, Chat)
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // EDIT BUTTON

                                if (request.jsonData["success"] == true && request.jsonData["is_admin"] == true)
                                  _actionButton(
                                    icon: Icons.edit,
                                    color: AppColors.indigo,
                                    iconColor: Colors.white,
                                    onTap: () async {
                                      
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditPlayerEntry(player: player),
                                        ),
                                      );

                                      if (result == true) {
                                        setState(() {
                                          futurePlayer = PlayerEntryService.fetchPlayerDetail(player.id);
                                        });
                                      }

                                    },
                                  ),

                                  const SizedBox(width: 10),

                                // DELETE BUTTON
                                if (request.jsonData["success"] == true && request.jsonData["is_admin"] == true)
                                  _actionButton(
                                    icon: Icons.delete_outline,
                                    color: Colors.redAccent,
                                    iconColor: Colors.white,
                                    onTap: () {
                                      _showDeleteConfirmation(context);
                                    },
                                  ),

                                  const SizedBox(width: 10),

                                // CHAT BUTTON
                        
                                _actionButton(
                                  icon: Icons.chat_bubble_outline,
                                  color: AppColors.lime,
                                  iconColor: AppColors.indigo,
                                  onTap: () {
                                    // TODO: Open chat
                                  },
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2,
        onTap: (index) {},
      ),
    );
  }

  // STAT PILL WIDGET
  Widget _statPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Geologica",
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // DROPDOWN SECTION WIDGET
  Widget _dropdownSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 20,
                    color: AppColors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.indigo,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  // DATA ITEM WIDGET (untuk isi dropdown)
  Widget _dataItem(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lime.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lime,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Geologica",
          fontSize: 16,
          color: AppColors.indigo,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
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
        child: Icon(
          icon,
          size: 28,
          color: iconColor,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Player"),
      content: const Text("Are you sure you want to delete this player?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            try {
              await PlayerEntryService.deletePlayer(widget.playerId);

              if (!mounted) return;

              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // keluar halaman detail

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PlayerEntryListPage(filter: "All")),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Player deleted")),
              );
            } catch (e) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Delete failed: $e")),
              );
            }
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}



}