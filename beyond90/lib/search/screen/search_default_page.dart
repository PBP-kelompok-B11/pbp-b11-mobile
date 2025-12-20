import 'package:beyond90/clubs/models/club.dart';
import 'package:beyond90/clubs/screens/club_detail_user.dart';
import 'package:beyond90/player/screens/player_entry_details.dart';
import 'package:beyond90/search/screen/search_history_and_recommendation_page.dart';
import 'package:beyond90/search/screen/search_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/search/widgets/search_bar.dart';

import 'package:beyond90/landing_page/screeen/landing_page.dart';
import 'package:beyond90/category/screens/category_page.dart';
import 'package:beyond90/media_gallery/screens/media_entry_list.dart';

// ================= EVENT =================
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/service/event_service.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';

// ================= PLAYER =================
import 'package:beyond90/player/models/player_entry.dart';
import 'package:beyond90/player/service/player_service.dart';
import 'package:beyond90/player/screens/player_entry_list.dart';

// ===== CARD =====
import 'package:beyond90/widgets/player_card.dart';
// "ubah import jadi ambil widget dari folder clubs"
import 'package:beyond90/clubs/widgets/club_card.dart';

// ================= CLUB =================
import 'package:beyond90/clubs/service/club_service.dart';
import 'package:beyond90/clubs/screens/club_list_user.dart';

class SearchDefaultPage extends StatefulWidget {
  const SearchDefaultPage({super.key});

  @override
  State<SearchDefaultPage> createState() => _SearchDefaultPageState();
}

class _SearchDefaultPageState extends State<SearchDefaultPage> {
  final TextEditingController _searchController = TextEditingController();

  late final Future<List<EventEntry>> _eventFuture;
  late final Future<List<PlayerEntry>> _playerFuture;
  late final Future<List<Club>> _clubFuture;

  final _eventCtrl = ScrollController();
  final _playerCtrl = ScrollController();
  final _clubCtrl = ScrollController();

  bool showEventArrow = false;
  bool showPlayerArrow = false;
  bool showClubArrow = false;

  @override
  void initState() {
    super.initState();

    final request = context.read<CookieRequest>();
    _eventFuture = EventService.fetchEvents(request);
    _playerFuture = PlayerEntryService.fetchPlayerEntry();
    _clubFuture = ClubService.fetchClubs();

    _bindArrow(_eventCtrl, () => showEventArrow = true);
    _bindArrow(_playerCtrl, () => showPlayerArrow = true);
    _bindArrow(_clubCtrl, () => showClubArrow = true);
  }

  void _bindArrow(ScrollController c, VoidCallback onShow) {
    c.addListener(() {
      if (c.offset > 50) setState(onShow);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _eventCtrl.dispose();
    _playerCtrl.dispose();
    _clubCtrl.dispose();
    super.dispose();
  }

  void _onNavbarTap(int index) {
    if (index == 1) return;

    final pages = [
      const MyHomePage(),
      const SearchDefaultPage(),
      const CategoryPage(),
      const MediaEntryListPage(),
    ];

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => pages[index],
        transitionDuration: Duration.zero,
      ),
    );
  }

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
            children: [
              const SizedBox(height: 24),

              SearchBarWidget(
                controller: _searchController,
                onTap: () {
                  final request = context.read<CookieRequest>();

                  if (request.loggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchHistoryAndSuggestionPage(),
                      ),
                    );
                  } else {
                    // user belum login → tetap ke history / suggestion
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchHistoryAndSuggestionPage(),
                      ),
                    );
                  }
                },
                onSubmitted: (query) {
                  if (query.trim().isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultPage(query: query),
                    ),
                  );
                },
              ),


              const SizedBox(height: 32),

              // ================= EVENT =================
              _buildSection<EventEntry>(
                title: "Event",
                future: _eventFuture,
                scrollController: _eventCtrl,
                showArrow: showEventArrow,
                onArrowTap: () => _go(const EventEntryListPage()),
                itemWidth: 280,
                sectionHeight: 200,
                emptyWidget: _emptyEventCard(),
                itemBuilder: (e) => EventEntryCard(
                  event: e,
                  onTap: () => _go(EventDetailPage(event: e)),
                ),
              ),

              // ================= PLAYER =================
              _buildSection<PlayerEntry>(
                title: "Player",
                future: _playerFuture,
                scrollController: _playerCtrl,
                showArrow: showPlayerArrow,
                onArrowTap: () =>
                    _go(const PlayerEntryListPage(filter: '')),
                itemWidth: 280,
                sectionHeight: 260,
                itemBuilder: (player) => PlayerCard(
                  thumbnail: player.thumbnail ?? "",
                  nama: player.nama,
                  negara: player.negara,
                  usia: player.usia,
                  tinggi: player.tinggi,
                  berat: player.berat,
                  posisi: player.posisi,
                  onTap: () =>
                      _go(PlayerDetailEntry(playerId: player.id)),
                ),
              ),

              // ================= CLUB =================
              _buildSection<Club>(
                title: "Club",
                future: _clubFuture,
                scrollController: _clubCtrl,
                showArrow: showClubArrow,
                onArrowTap: () => _go(const ClubListUser()),
                itemWidth: 220,      // Sedikit diperkecil lebarnya agar lebih proporsional
                sectionHeight: 320,  // 🔥 NAIKKAN TINGGINYA agar tidak overflow
                itemBuilder: (club) => ClubCard(
                  imageUrl: club.urlGambar ?? "",
                  clubName: club.nama,
                  location: club.stadion, // Atau gunakan club.negara sesuai kebutuhan
                  onTap: () => _go(ClubDetailUser(clubId: club.id)),
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection<T>({
    required String title,
    required Future<List<T>> future,
    required ScrollController scrollController,
    required bool showArrow,
    required VoidCallback onArrowTap,
    required Widget Function(T item) itemBuilder,
    required double sectionHeight,
    double itemWidth = 200,
    Widget? emptyWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 12),
        FutureBuilder<List<T>>(
          future: future,
          builder: (_, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return _loading(sectionHeight);
            }

            final items = snapshot.data?.take(3).toList() ?? [];

            return _horizontalSection(
              height: sectionHeight,
              scrollController: scrollController,
              showArrow: showArrow,
              onArrowTap: onArrowTap,
              items: items.isEmpty && emptyWidget != null
                  ? [emptyWidget]
                  : items
                      .map(
                        (e) => SizedBox(
                          width: itemWidth,
                          child: itemBuilder(e),
                        ),
                      )
                      .toList(),
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.lime,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _loading(double height) => SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.lime,
          ),
        ),
      );

  Widget _horizontalSection({
    required double height,
    required ScrollController scrollController,
    required List<Widget> items,
    required bool showArrow,
    required VoidCallback onArrowTap,
  }) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 24),
            itemBuilder: (_, i) => items[i],
          ),
          if (!showArrow)
            Positioned(
              right: 30,
              top: height / 2 - 26,
              child: _scrollHint(onArrowTap),
            ),
        ],
      ),
    );
  }

  Widget _scrollHint(VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Padding(
          padding: EdgeInsets.only(left: 8), // 👈 Padding kecil agar icon ios terlihat center secara optik
          child: Icon(
            Icons.arrow_forward_ios_rounded, // 
            color: AppColors.indigo,
            size: 24,
          ),
        ),
      ),
    );

  Widget _emptyEventCard() => SizedBox(
        width: 280,
        child: EventEntryCard(
          event: EventEntry.empty(),
          onTap: () {},
        ),
      );

  void _go(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
