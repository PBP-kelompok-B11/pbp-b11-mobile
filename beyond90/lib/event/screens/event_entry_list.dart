import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/widgets/left_drawer.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/widgets/event_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// ignore: constant_identifier_names
const String BASE_URL = "http://localhost:8000"; 

class EventEntryListPage extends StatefulWidget {
  // 1. TAMBAHKAN PARAMETER filterByUser
  final bool filterByUser;

  const EventEntryListPage({
    super.key, 
    this.filterByUser = false, // Default: false (tampilkan semua)
  });

  @override
  State<EventEntryListPage> createState() => _EventEntryListPageState();
}

class _EventEntryListPageState extends State<EventEntryListPage> {
  
  Future<List<EventEntry>> fetchEvent(CookieRequest request) async {
    // 2. MODIFIKASI LOGIKA URL BERDASARKAN filterByUser
    String url;
    if (widget.filterByUser) {
      // Panggil URL untuk produk pengguna yang login
      url = '$BASE_URL/my-events-json/'; // <--- ASUMSI URL BARU DI DJANGO
    } else {
      // Panggil URL untuk semua produk (default)
      url = '$BASE_URL/events/json/';
    }

    final response = await request.get(url);
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to EventEntry objects
    List<EventEntry> listEvent = [];
    for (var d in data) {
      if (d != null) {
        // Pastikan Anda menggunakan EventEntry.fromJson
        listEvent.add(EventEntry.fromJson(d));
      }
    }
    return listEvent;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        // Ganti judul berdasarkan filter
        title: Text(widget.filterByUser ? 'My Event List' : 'All Event List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchEvent(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) { // Periksa juga jika list kosong
              return Center( // Pusatkan pesan jika tidak ada data
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.filterByUser 
                        ? 'You haven\'t added any events yet.' 
                        : 'There are no events in football shop yet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => EventEntryCard(
                  event: snapshot.data![index],
                  onTap: () {
                    // Navigate to event detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          event: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}