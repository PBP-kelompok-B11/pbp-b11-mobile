import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/media_gallery/screens/medialist_form.dart';


Future<bool> isAdmin(CookieRequest request) async {
  final response = await request.get(
    "http://localhost:8000/user/"
  );

  return response['is_staff'] == true || response['is_superuser'] == true;
}

// BASE_URL diarahkan ke folder events
const String BASE_URL = "http://localhost:8000/events"; 

class EventEntryListPage extends StatefulWidget {
  final bool filterByUser;

  const EventEntryListPage({super.key, this.filterByUser = false});

  @override
  State<EventEntryListPage> createState() => _EventEntryListPageState();
}

class _EventEntryListPageState extends State<EventEntryListPage> {
  
  Future<List<EventEntry>> fetchEvent(CookieRequest request) async {
    // Pilih URL berdasarkan filterByUser
    String url = widget.filterByUser
        ? '$BASE_URL/my-events-json/'  // Hanya event user login
        : '$BASE_URL/json/';           // Semua event

    // Pakai request.get yang sudah punya cookie session
    final response = await request.get(url);

    // Debug: cek apakah response benar JSON
    // print(response);

    if (response is Map && response.containsKey('detail')) {
      // Kalau dapat redirect login JSON, berarti belum login
      throw Exception('Not logged in. Please login first.');
    }

    // Konversi list JSON menjadi EventEntry
    List<EventEntry> listEvent = [];
    for (var d in response) {
      listEvent.add(EventEntry.fromJson(d));
    }

    return listEvent;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔙 BACK BUTTON + TITLE
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
              child: FutureBuilder<bool>(
                future: isAdmin(request),
                builder: (context, snapshot) {
                  final isAdminUser = snapshot.data ?? false;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.lime,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.filterByUser ? 'My Event' : 'Event',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lime,
                            ),
                          ),
                        ],
                      ),

                      // 🟢 CREATE EVENT (ADMIN ONLY)
                      if (isAdminUser)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/event/create');
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Create Event',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lime,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            // 📦 CONTENT
            Expanded( //test
              child: FutureBuilder<List<EventEntry>>(
                future: fetchEvent(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No events available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 165, // ✅ tinggi FIXED
                      ),
                      itemBuilder: (_, index) => EventEntryCard(
                        event: snapshot.data![index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailPage(event: snapshot.data![index]),
                            ),
                          );
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

      // 🔽 BOTTOM NAVBAR
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) return;

          switch (index) {
            case 1:
              Navigator.pushNamed(context, 'search');
              break;
            case 2:
              Navigator.pushNamed(context, '/category');
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaFormPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
