import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beyond90/player/models/player_entry.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlayerEntryService {
  static const String baseUrl = "http://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/json/";
  

  // CLUB
  static Future<List<PlayerEntry>> fetchPlayerEntry() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => PlayerEntry.fromJson(json)).toList();
    }
    throw Exception("Failed to fetch player data: ${response.body}");
  }

  static Future<PlayerEntry> fetchPlayerDetail(String playerId) async {

      final url = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/player/$playerId/detailjson/json/";
      // final url = "http://localhost:8000/players/player/$playerId/detailjson/json/";
  
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return PlayerEntry.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load player detail');
      }
  }

  static Future<void> createPlayerEntry(Map<String, dynamic> data, CookieRequest request) async {
    final response = await request.postJson(
      // "http://localhost:8000/players/player/create/flutter/"
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/player/create/flutter/"
      ,jsonEncode(data),              // Kirim sebagai JSON
    );

     if (response["status"] != "success") {
      throw Exception(response["message"]);
    }
  }

  static Future<void> deletePlayer(String id) async {
    final response = await http.delete(
      Uri.parse("https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/player/$id/delete/flutter/"),
    );

    if (response.statusCode != 200) {
      throw Exception("Delete gagal");
    }
  }

  static Future<void> updatePlayer(
    CookieRequest request,
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await request.postJson(
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/player/$id/edit/flutter/",
      jsonEncode(data),
    );

    if (response["message"] != "Player updated successfully") {
      throw Exception("Edit gagal");
    }
  }
  
}
