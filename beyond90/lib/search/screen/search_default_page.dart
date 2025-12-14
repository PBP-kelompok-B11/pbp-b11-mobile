import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

// widgets kamu
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

  @override
  void initState() {
    super.initState();
    _addScrollListeners();
  }

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

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) return;
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/search?query=$query"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          eventList = data["events"] ?? [];
          playerList = data["players"] ?? [];
          clubList = data["clubs"] ?? [];
        });
      }
    } catch (e) {
      print("ERROR: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 1,
        onTap: (index) {}, 
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 24),
              SearchBarWidget(
                controller: _searchController,
                onSubmitted: (value) => fetchSearchResults(value),
              ),

              const SizedBox(height: 40),
              _sectionTitle("Event"),
              _horizontalSection(
                scrollController: _scrollControllerEvent,
                items: eventList.isNotEmpty
                    ? eventList.map((event) {
                        return EventCard(
                          imageUrl: event["image_url"],
                          title: event["title"],
                          date: event["date"],
                          onTap: () {},
                        );
                      }).toList()
                    : _placeholderCards(EventCard(
                        imageUrl: "",
                        title: "No Data",
                        date: "",
                        onTap: (){},
                      )),
                showArrow: showArrowEvent,
              ),

              const SizedBox(height: 50),
              _sectionTitle("Player"),
              _horizontalSection(
                scrollController: _scrollControllerPlayer,
                items: playerList.isNotEmpty
                    ? playerList.map((player) {
                        return PlayerCard(
                          imageUrl: player["image_url"],
                          name: player["name"],
                          onTap: () {}, position: '',
                        );
                      }).toList()
                    : _placeholderCards(PlayerCard(
                        imageUrl: "",
                        name: "No Data",
                        onTap: (){}, position: '',
                      )),
                showArrow: showArrowPlayer,
              ),

              const SizedBox(height: 50),
              _sectionTitle("Club"),
              _horizontalSection(
                scrollController: _scrollControllerClub,
                items: clubList.isNotEmpty
                    ? clubList.map((club) {
                        return ClubCard(
                          imageUrl: club["image_url"],
                          clubName: club["name"],
                          location: club["location"],
                          onTap: () {},
                        );
                      }).toList()
                    : _placeholderCards(ClubCard(
                        imageUrl: "",
                        clubName: "No Data",
                        onTap: (){}, location: '',
                      )),
                showArrow: showArrowClub,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _placeholderCards(Widget card) =>
      [card, const SizedBox(), const SizedBox()];

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
              child: Container(
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
              ),
            ),
        ],
      ),
    );
  }
}
