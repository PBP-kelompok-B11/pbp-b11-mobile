import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/models/event_entry.dart';

class EventService {
  // Ganti ke URL deploy jika sudah naik, atau 10.0.2.2 untuk emulator android
  static const String baseUrl = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/events";
  
  static Future<List<EventEntry>> fetchEvents(CookieRequest request, {bool filterByUser = false}) async {
    // Service yang menentukan URL-nya
    final String url = filterByUser 
        ? '$baseUrl/my-events-json/' 
        : '$baseUrl/json/';
    // testrs
    final response = await request.get(url);

    if (response is List) {
      return response.map((json) => EventEntry.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data event");
    }
  }

  static String getEventStatus(DateTime tanggal) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(tanggal.year, tanggal.month, tanggal.day);

    if (eventDay == today) return "LIVE";
    if (tanggal.isAfter(now)) return "UPCOMING";
    return "FINISHED";
  }

  // 2. CREATE EVENT
  static Future<bool> createEvent(CookieRequest request, Map<String, dynamic> data) async {
    final response = await request.post("$baseUrl/create-flutter/", data);
    return response['status'] == 'success';
  }

  // 3. EDIT EVENT
  static Future<bool> updateEvent(CookieRequest request, int id, Map<String, dynamic> data) async {
    final response = await request.post("$baseUrl/$id/edit-flutter/", data);
    return response['status'] == 'success';
  }

  // 4. DELETE EVENT
  static Future<bool> deleteEvent(CookieRequest request, int id) async {
    final response = await request.post("$baseUrl/$id/delete/", {});
    return response['status'] == 'success';
  }
}