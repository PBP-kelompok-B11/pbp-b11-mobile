import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:beyond90/event/service/event_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/media_gallery/screens/medialist_form.dart';
import 'package:beyond90/authentication/service/auth_service.dart';

class EventEntryListPage extends StatefulWidget {
  final bool filterByUser;
  const EventEntryListPage({super.key, this.filterByUser = false});

  @override
  State<EventEntryListPage> createState() => _EventEntryListPageState();
}

class _EventEntryListPageState extends State<EventEntryListPage> {
  late Future<List<EventEntry>> _eventFuture;
  
  // 🔥 1. TAMBAHKAN VARIABEL STATE INI
  late bool _isFilteringMyEvents;

  @override
  void initState() {
    super.initState();
    // Inisialisasi awal berdasarkan parameter dari widget
    _isFilteringMyEvents = widget.filterByUser;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshEvents();
  }

  void _refreshEvents() {
    final request = context.read<CookieRequest>();
    setState(() {
      // Sekarang _isFilteringMyEvents sudah dikenali
      _eventFuture = EventService.fetchEvents(
        request, 
        filterByUser: _isFilteringMyEvents
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SECTION ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushReplacementNamed(context, '/category'),
                        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.lime, size: 30),
                      ),
                      const SizedBox(width: 12),
                      // Judul berubah sesuai filter
                      Text(
                        _isFilteringMyEvents ? 'My Events' : 'Events',
                        style: const TextStyle(fontFamily: 'Geologica', fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.lime),
                      ),

                      // 🔥 POPUP MENU DENGAN DESAIN LIME & INDIGO
                      PopupMenuButton<bool>(
                        icon: const Icon(Icons.filter_list, color: AppColors.lime, size: 28),
                        // Mengatur warna background kotak popup
                        color: AppColors.lime, 
                        // Mengatur bentuk pojok kotak agar rounded/mulus
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                        onSelected: (bool value) {
                          if (_isFilteringMyEvents != value) {
                            setState(() {
                              _isFilteringMyEvents = value;
                              _refreshEvents();
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: false,
                            child: Row(
                              children: [
                                Icon(Icons.all_inclusive, color: !_isFilteringMyEvents ? AppColors.indigo : AppColors.indigo.withOpacity(0.5)),
                                const SizedBox(width: 10),
                                Text(
                                  "All Events",
                                  style: TextStyle(
                                    color: AppColors.indigo,
                                    fontWeight: !_isFilteringMyEvents ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: true,
                            child: Row(
                              children: [
                                Icon(Icons.person, color: _isFilteringMyEvents ? AppColors.indigo : AppColors.indigo.withOpacity(0.5)),
                                const SizedBox(width: 10),
                                Text(
                                  "My Events",
                                  style: TextStyle(
                                    color: AppColors.indigo,
                                    fontWeight: _isFilteringMyEvents ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  if (AuthService.isAdmin)
                    InkWell(
                      onTap: () async {
                        final refresh = await Navigator.pushNamed(context, '/event/create');
                        if (refresh == true) _refreshEvents();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: AppColors.lime, size: 22),
                            SizedBox(width: 4),
                            Text('Add Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lime)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- CONTENT SECTION (GRID) ---
            Expanded(
              child: FutureBuilder<List<EventEntry>>(
                future: _eventFuture, 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.lime));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No events available.', style: TextStyle(color: Colors.white)),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 190, // Ditinggiin dikit biar gak sesak
                      ),
                      itemBuilder: (_, index) => EventEntryCard(
                        event: snapshot.data![index],
                        onTap: () async {
                          final refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailPage(event: snapshot.data![index]),
                            ),
                          );
                          if (refresh == true) _refreshEvents();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          switch (index) {
            case 1: Navigator.pushNamed(context, 'search'); break;
            case 2: Navigator.pushReplacementNamed(context, '/category'); break;
            case 3: Navigator.push(context, MaterialPageRoute(builder: (context) => MediaFormPage())); break;
          }
        },
      ),
    );
  }
}