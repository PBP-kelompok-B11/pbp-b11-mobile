import 'package:beyond90/player/screens/player_entry_details.dart';
import 'package:flutter/material.dart';

import 'package:beyond90/player/models/player_entry.dart';
import 'package:beyond90/widgets/player_card.dart';
import 'package:beyond90/player/screens/add_player_entry.dart';

import 'package:beyond90/player/service/player_service.dart';

import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
// import 'package:ego_gear/widgets/left_drawer.dart';
// import 'package:ego_gear/screens/product_detail.dart';
// import 'package:ego_gear/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


class PlayerEntryListPage extends StatefulWidget {

  final String filter;


  

  const PlayerEntryListPage({super.key, required this.filter});

  

  @override
  State<PlayerEntryListPage> createState() => _PlayerEntryListPageState();

  
}

class _PlayerEntryListPageState extends State<PlayerEntryListPage> {

  late Future<List<PlayerEntry>> _futureEntry;

  bool _filterAll = true;          // toggle All/Mine
  String _selectedPosition = 'All'; // dropdown posisi

  
  @override
  void initState() {
    super.initState();
    _filterAll = widget.filter == "All" ? true : false;
    _futureEntry = PlayerEntryService.fetchPlayerEntry();
  }

  // Future<void> increaseHype(CookieRequest request, String productId) async {
  //   final response = await request.post(
  //     "https://muhammad-rafi42-egogear.pbp.cs.ui.ac.id/products/$productId/increase_hype/",
  //     {},
  //   );

  //   print("Increase hype response: $response");
  // }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lime, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Player",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 28,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.lime, size: 30),
            color: AppColors.lime,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            
            onSelected: (String value) {
              setState(() {
                if (value == 'all_data') {
                  _filterAll = true;
                } else if (value == 'mine_data') {
                  _filterAll = false;
                } else {
                  _selectedPosition = value; // Menangani 'GK', 'DF', 'DFFW', dll.
                }
              });
            },
            itemBuilder: (context) => [
              if (request.jsonData["success"] == true) ...[
                PopupMenuItem(
                  value: 'all_data',
                  child: Row(
                    children: [
                      Icon(Icons.people, color: _filterAll ? AppColors.indigo : AppColors.indigo.withOpacity(0.4)),
                      const SizedBox(width: 12),
                      const Text("All Players", style: TextStyle(color: AppColors.indigo, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'mine_data',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: !_filterAll ? AppColors.indigo : AppColors.indigo.withOpacity(0.4)),
                      const SizedBox(width: 12),
                      const Text("My Players", style: TextStyle(color: AppColors.indigo, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
              ],
              
              // --- 🔥 DAFTAR POSISI LENGKAP ---
              ...[
                'All', 'GK', 'DF', 'DFFW', 'DFMF', 'MF', 'MFDF', 'MFFW', 'FW', 'FWDF', 'FWMF'
              ].map((pos) => PopupMenuItem(
                value: pos,
                child: Row(
                  children: [
                    Icon(
                      Icons.sports_soccer, 
                      size: 18, 
                      color: _selectedPosition == pos ? AppColors.indigo : AppColors.indigo.withOpacity(0.4)
                    ),
                    const SizedBox(width: 12),
                    Text(pos, style: const TextStyle(color: AppColors.indigo)),
                  ],
                ),
              )),
            ],
          ),

          if (request.jsonData["is_admin"] == true)
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.lime, size: 30),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPlayerEntry()),
              ),
            ),
          const SizedBox(width: 12),
        ],
      ),
      
      body: FutureBuilder<List<PlayerEntry>>(
        future: _futureEntry,
        builder: (context, snapshot) {
          // ... (logika loading & error tetap sama)

          final playerList = snapshot.data ?? [];

          final filteredList = playerList.where((player) {
            // 1. Filter All/Mine
            bool ownerMatch = _filterAll ? true : player.user_id == request.jsonData["user_id"];

            // 2. Filter Posisi (Sekarang handle semua String posisi)
            bool positionMatch = _selectedPosition == 'All' ? true : player.posisi == _selectedPosition;

            return ownerMatch && positionMatch;
          }).toList();


          if (filteredList.isEmpty) {
            return const Center(
              child: Text(
                "No player available",
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: filteredList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final player = filteredList[index];

                return PlayerCard(
                  thumbnail: player.thumbnail ?? "",
                  nama: player.nama,
                  negara: player.negara,
                  usia: player.usia,
                  tinggi: player.tinggi,
                  berat: player.berat,
                  posisi: player.posisi,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlayerDetailEntry(playerId: player.id),
                      ),
                    );
                  },
                );
              },
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
}