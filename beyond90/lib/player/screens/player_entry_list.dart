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
    print(request); 

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
          "Player",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 28,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          // if (request.jsonData["status"] == true)
           Padding(
              padding: const EdgeInsets.only(right: 25.0, top: 25, bottom: 15),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                fillColor: AppColors.lime,
                selectedColor: AppColors.indigo,
                color: AppColors.white,
                constraints: const BoxConstraints(minHeight: 40, minWidth: 70),
                isSelected: [_filterAll, !_filterAll], // boolean list untuk toggle
                onPressed: (index) {
                  setState(() {
                    _filterAll = index == 0;
                  });
                },
                children: const [
                  Text("All", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Mine", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 25.0, top: 25, bottom: 15),
              child: DropdownButton<String>(
                value: _selectedPosition,
                dropdownColor: AppColors.indigo,
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPosition = newValue!;
                  });
                },
                items: <String>[
                  'All', 'GK', 'DF', 'DFFW', 'DFMF', 'MF', 'MFDF', 'MFFW', 'FW', 'FWDF', 'FWMF'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            ),

          // if (request.jsonData["status"] == true )
          Padding(
            padding: const EdgeInsets.only(right: 25.0, top: 25,bottom: 15), // jarak dari tepi kanan
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPlayerEntry()),
                );
              },
              child: Container(
                width: 250,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Add Player",
                  style: TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 20,
                    color: AppColors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        ],

        // actions: [

        
        //     // if (isAdmin)
        //     //   IconButton(
        //     //     icon: const Icon(Icons.add, color: AppColors.lime, size: 32),
        //     //     onPressed: () {
        //     //       // navigasi ke halaman add player
        //     //       Navigator.push(
        //     //         context,
        //     //         MaterialPageRoute(
        //     //           builder: (_) => AddPlayerPage(), // buat page ini sendiri
        //     //         ),
        //     //       );
        //     //     },
        //     //   ),
        // ],

      ),
      
      // drawer: const LeftDrawer(),
      body: FutureBuilder<List<PlayerEntry>>(
        future: _futureEntry,
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

          final playerList = snapshot.data ?? [];

          final filteredList = playerList.where((player) {

            // toggle All/Mine
            bool ownerMatch = _filterAll ? true : player.user_id == request.jsonData["user_id"];

            // posisi filter
            bool positionMatch = _selectedPosition == 'All' ? true : player.posisi == _selectedPosition;

            return  ownerMatch && positionMatch;

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

      // ✅ REUSABLE BOTTOM NAVBAR
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2, // Category
        onTap: (index) {
          // nanti sambung ke routing global
        },
      ),
        
    );
  }
}