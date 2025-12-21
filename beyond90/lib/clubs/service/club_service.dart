import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club.dart';

class ClubService {
  // ✅ BASE URL SESUAI DEPLOY
  static const String baseUrl =
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/clubs/api/";

  // =====================
  // CLUB
  // =====================

  static Future<List<Club>> fetchClubs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Club.fromJson(json)).toList();
    }
    throw Exception("Failed to fetch clubs: ${response.body}");
  }

  static Future<Club> fetchClubDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id/"));

    if (response.statusCode == 200) {
      return Club.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch club detail: ${response.body}");
  }

  static Future<int> createClub(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    }
    throw Exception("Failed to create club: ${response.body}");
  }

  static Future<void> updateClub(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to update club: ${response.body}");
    }
  }

  static Future<void> deleteClub(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id/"));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete club: ${response.body}");
    }
  }

  // =====================
  // RANKING (API YANG ADA)
  // =====================

  /// UPDATE ranking
  /// endpoint: /clubs/ranking/api/<ranking_id>/
  static Future<void> updateRanking(int rankingId, int ranking) async {
    final response = await http.put(
      Uri.parse(
        "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/clubs/ranking/api/$rankingId/",
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "peringkat": ranking,
        "musim": "2025",
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to update ranking: ${response.body}");
    }
  }
}
