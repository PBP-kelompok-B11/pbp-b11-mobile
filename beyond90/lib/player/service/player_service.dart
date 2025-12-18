import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beyond90/player/models/player_entry.dart';

class PlayerEntryService {
  static const String baseUrl = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/players/json/";

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

  static Future<int> createPlayerEntry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    }
    throw Exception("Failed to create player: ${response.body}");
  }

  static Future<void> updatePlayerEntry(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to update player: ${response.body}");
    }
  }

  static Future<void> deletePlayerEntry(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id/"));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete player: ${response.body}");
    }
  }

  
}
