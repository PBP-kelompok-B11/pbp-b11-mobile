import 'dart:convert';
import 'package:beyond90/category/screens/category_page.dart';
import 'package:beyond90/landing_page/screeen/landing_page.dart';
import 'package:beyond90/media_gallery/screens/media_entry_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';


// Widgets
import 'package:beyond90/search/widgets/search_bar.dart';
import 'package:beyond90/widgets/event_card.dart';
import 'package:beyond90/widgets/player_card.dart';
import 'package:beyond90/widgets/club_card.dart';

class SearchDefaultPage extends StatefulWidget {
  const SearchDefaultPage({super.key});

  @override
  State<SearchDefaultPage> createState() => _SearchDefaultPageState();
}

class _SearchDefaultPageState extends State<SearchDefaultPage> {
  final TextEditingController _searchController = TextEditingController();

  List eventList = [];
  List playerList = [];
  List clubList = [];

  bool isLoading = false;

  final ScrollController _scrollControllerEvent = ScrollController();
  final ScrollController _scrollControllerPlayer = ScrollController();
  final ScrollController _scrollControllerClub = ScrollController();

  bool showArrowEvent = false;
  bool showArrowPlayer = false;
  bool showArrowClub = false;

  // =========================
  // INIT
  // =========================
  @override
  void initState() {
    super.initState();
    _addScrollListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollControllerEvent.dispose();
    _scrollControllerPlayer.dispose();
    _scrollControllerClub.dispose();
    super.dispose();
  }

  // =========================
  // SCROLL LISTENER
  // =========================
  void _addScrollListeners() {
    _scrollControllerEvent.addListener(() {
      if (_scrollControllerEvent.offset > 50 && !showArrowEvent) {
        setState(() => showArrowEvent = true);
      }
    });

    _scrollControllerPlayer.addListener(() {
      if (_scrollControllerPlayer.offset > 50 && !showArrowPlayer) {
        setState(() => showArrowPlayer = true);
      }
    });

    _scrollControllerClub.addListener(() {
      if (_scrollControllerClub.offset > 50 && !showArrowClub) {
        setState(() => showArrowClub = true);
      }
    });
  }

  // =========================
  // API SEARCH
  // =========================
  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          "http://10.0.2.2:8000/search/api/search/?q=$query&type=players",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          eventList = data['events'] ?? [];
          playerList = data['players'] ?? [];
          clubList = data['clubs'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }

    setState(() => isLoading = false);
  }

  // =========================
  // NAVBAR HANDLER
  // =========================
  void _onNavbarTap(int index) {
    if (index == 1) return; // already on Search

    Widget page;
    switch (index) {
      case 0:
        page = const MyHomePage();
        break;
      case 2:
        page = const CategoryPage();
        break;
      case 3:
        page = const MediaEntryListPage();
        break;
      default:
        page = const SearchDefaultPage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 1,
        onTap: _onNavbarTap,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              SearchBarWidget(
                controller: _searchController,
                onSubmitted: fetchSearchResults,
              ),

              const SizedBox(height: 40),
              _sectionTitle("Event"),
              _horizontalSection(
                scrollController: _scrollControllerEvent,
                items: eventList.isNotEmpty
                    ? eventList.map<Widget>((event) {
                        return EventCard(
                          imageUrl: event['image_url'] ?? '',
                          title: event['nama_event'] ?? 'Unknown',
                          date: '',
                          onTap: () {},
                        );
                      }).toList()
                    : _placeholderCards(_emptyEventCard()),
                showArrow: showArrowEvent,
              ),

              const SizedBox(height: 50),
              _sectionTitle("Player"),
              _horizontalSection(
                scrollController: _scrollControllerPlayer,
                items: playerList.isNotEmpty
                    ? playerList.map<Widget>((player) {
                        return PlayerCard(
                          thumbnail: player['thumbnail'] ?? '',
                          nama: player['nama'] ?? 'Unknown',
                          negara: player['negara'] ?? '',
                          usia: player['usia'] ?? 0,
                          tinggi: (player['tinggi'] as num?)?.toDouble() ?? 0.0,
                          berat: (player['berat'] as num?)?.toDouble() ?? 0.0,
                          posisi: player['posisi'] ?? '',
                          onTap: () {},
                        );
                      }).toList()
                    : _placeholderCards(_emptyPlayerCard()),
                showArrow: showArrowPlayer,
              ),

              const SizedBox(height: 50),
              _sectionTitle("Club"),
              _horizontalSection(
                scrollController: _scrollControllerClub,
                items: clubList.isNotEmpty
                    ? clubList.map<Widget>((club) {
                        return ClubCard(
                          imageUrl: club['image_url'] ?? '',
                          clubName: club['nama'] ?? 'Unknown',
                          location: club['negara'] ?? '',
                          onTap: () {},
                        );
                      }).toList()
                    : _placeholderCards(_emptyClubCard()),
                showArrow: showArrowClub,
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // HELPERS
  // =========================
  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.lime,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _horizontalSection({
    required ScrollController scrollController,
    required List<Widget> items,
    required bool showArrow,
  }) {
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 24),
            itemBuilder: (_, i) => items[i],
          ),
          if (!showArrow)
            Positioned(
              right: 0,
              top: 130,
              child: _scrollHint(),
            ),
        ],
      ),
    );
  }

  Widget _scrollHint() => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          "→",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.indigo,
          ),
        ),
      );

  List<Widget> _placeholderCards(Widget card) =>
      [card, const SizedBox(), const SizedBox()];

  Widget _emptyEventCard() => EventCard(
        imageUrl: '',
        title: 'No Data',
        date: '',
        onTap: () {},
      );

  Widget _emptyPlayerCard() => PlayerCard(
    thumbnail: '',
    nama: 'No Data',
    negara: '',
    usia: 0,
    tinggi: 0.0,
    berat: 0.0,
    posisi: '',
    onTap: () {},
  );


  Widget _emptyClubCard() => ClubCard(
        imageUrl: '',
        clubName: 'No Data',
        location: '',
        onTap: () {},
      );
}
