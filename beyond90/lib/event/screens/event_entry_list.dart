import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/widgets/left_drawer.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

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
      appBar: AppBar(
        title: Text(widget.filterByUser ? 'My Event List' : 'All Event List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<EventEntry>>(
        future: fetchEvent(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}\n\nMake sure you are logged in.',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                widget.filterByUser
                    ? 'You haven\'t added any events yet.'
                    : 'No events available.',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => EventEntryCard(
                event: snapshot.data![index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(
                        event: snapshot.data![index],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
