import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/search/widgets/search_bar.dart';

import 'package:beyond90/landing_page/screeen/landing_page.dart';
import 'package:beyond90/category/screens/category_page.dart';
import 'package:beyond90/media_gallery/screens/media_entry_list.dart';

import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/service/event_service.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';

class SearchDefaultPage extends StatefulWidget {
  const SearchDefaultPage({super.key});

  @override
  State<SearchDefaultPage> createState() => _SearchDefaultPageState();
}

class _SearchDefaultPageState extends State<SearchDefaultPage> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<EventEntry>> _eventFuture;

  final ScrollController _scrollControllerEvent = ScrollController();
  bool showArrowEvent = false;

  // =========================
  // INIT
  // =========================
  @override
  void initState() {
    super.initState();

    _scrollControllerEvent.addListener(() {
      if (_scrollControllerEvent.offset > 50 && !showArrowEvent) {
        setState(() => showArrowEvent = true);
      }
    });

    final request = context.read<CookieRequest>();
    _eventFuture = EventService.fetchEvents(request);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollControllerEvent.dispose();
    super.dispose();
  }

  // =========================
  // NAVBAR HANDLER
  // =========================
  void _onNavbarTap(int index) {
    if (index == 1) return;

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
                onSubmitted: (_) {},
              ),

              const SizedBox(height: 40),

              // ===== EVENT TITLE (TANPA ARROW) =====
              _sectionTitle("Event"),

              // ===== EVENT PREVIEW =====
              FutureBuilder<List<EventEntry>>(
                future: _eventFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lime,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _horizontalSection(
                      scrollController: _scrollControllerEvent,
                      items: [_emptyEventCard()],
                      showArrow: false,
                    );
                  }

                  final previewEvents = snapshot.data!.take(3).toList();

                  return _horizontalSection(
                    scrollController: _scrollControllerEvent,
                    items: previewEvents.map((event) {
                      return SizedBox(
                        width: 280,
                        child: EventEntryCard(
                          event: event,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EventDetailPage(event: event),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    showArrow: showArrowEvent,
                  );
                },
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
  Widget _sectionTitle(String title) {
    return Padding(
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
  }

  Widget _horizontalSection({
    required ScrollController scrollController,
    required List<Widget> items,
    required bool showArrow,
  }) {
    return SizedBox(
      height: 200,
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

          // ===== ARROW BULAT (SATU-SATUNYA) =====
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

  Widget _scrollHint() => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EventEntryListPage(),
            ),
          );
        },
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
      );

  Widget _emptyEventCard() => SizedBox(
        width: 280,
        child: EventEntryCard(
          event: EventEntry.empty(),
          onTap: () {},
        ),
      );
}
