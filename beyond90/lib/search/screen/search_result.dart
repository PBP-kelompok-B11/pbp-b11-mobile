import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/search/widgets/search_bar.dart';
import 'package:beyond90/search/widgets/result_title.dart';

import 'package:beyond90/search/service/search_service.dart';

// PLAYER
import 'package:beyond90/player/models/player_entry.dart';
import 'package:beyond90/widgets/player_card.dart';
import 'package:beyond90/player/screens/player_entry_details.dart';

// CLUB
import 'package:beyond90/clubs/models/club.dart';
import 'package:beyond90/widgets/club_card.dart';
import 'package:beyond90/clubs/screens/club_detail_user.dart';

// EVENT
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:beyond90/event/screens/event_detail.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({
    super.key,
    required this.query,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late TextEditingController _controller;

  late Future<List<PlayerEntry>> _players;
  late Future<List<Club>> _clubs;
  late Future<List<EventEntry>> _events;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _fetchAll(widget.query);
  }

  void _fetchAll(String query) {
    if (query.trim().isEmpty) {
      _players = Future.value([]);
      _clubs = Future.value([]);
      _events = Future.value([]);
      return;
    }

    _players = _fetchPlayers(query);
    _clubs = _fetchClubs(query);
    _events = _fetchEvents(query);
  }

  Future<List<PlayerEntry>> _fetchPlayers(String q) async {
    final res = await SearchService.search(query: q, type: "players");

    final list = res["players"] ?? [];
    return list.map<PlayerEntry>((e) => PlayerEntry.fromJson(e)).toList();
  }


  Future<List<Club>> _fetchClubs(String q) async {
    final res = await SearchService.search(query: q, type: "clubs");

    final list = res["clubs"] ?? [];
    return list.map<Club>((e) => Club.fromJson(e)).toList();
  }


  Future<List<EventEntry>> _fetchEvents(String q) async {
    final res = await SearchService.search(query: q, type: "events");

    final list = res["events"] ?? [];
    return list.map<EventEntry>((e) => EventEntry.fromJson(e)).toList();
  }

  void _onSearch(String q) {
    if (q.trim().isEmpty) return;

    setState(() {
      _controller.text = q;
      _fetchAll(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 1, 
        onTap: (index) {
          if (index == 1) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/category');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/media_gallery');
              break;
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              SearchBarWidget(
                controller: _controller,
                onSubmitted: _onSearch,
              ),

              const SizedBox(height: 32),

              ResultTitle(query: _controller.text, keyword: ''),

              const SizedBox(height: 32),

              _buildSection<PlayerEntry>(
                title: "Player",
                future: _players,
                itemBuilder: (p) => PlayerCard(
                  thumbnail: p.thumbnail ?? "",
                  nama: p.nama,
                  negara: p.negara,
                  usia: p.usia,
                  tinggi: p.tinggi,
                  berat: p.berat,
                  posisi: p.posisi,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerDetailEntry(playerId: p.id),
                    ),
                  ),
                ),
              ),

              _buildSection<Club>(
                title: "Club",
                future: _clubs,
                itemBuilder: (c) => ClubCard(
                  imageUrl: c.urlGambar ?? "",
                  clubName: c.nama,
                  location: c.stadion,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClubDetailUser(clubId: c.id),
                    ),
                  ),
                ),
              ),

              _buildSection<EventEntry>(
                title: "Event",
                future: _events,
                itemBuilder: (e) => EventEntryCard(
                  event: e,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(event: e),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection<T>({
    required String title,
    required Future<List<T>> future,
    required Widget Function(T item) itemBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.lime,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<T>>(
            future: future,
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lime,
                  ),
                );
              }

              final items = snap.data ?? [];
              if (items.isEmpty) {
                return const Text(
                  "No result",
                  style: TextStyle(color: Colors.white70),
                );
              }

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: items
                    .map(
                      (e) => SizedBox(
                        width: 320,
                        child: itemBuilder(e),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
