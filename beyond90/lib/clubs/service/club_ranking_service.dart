import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club_ranking.dart';

class ClubRankingService {
  static const String baseUrl =
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/clubs/ranking/api/";

  static Future<List<ClubRanking>> fetchAllRankings() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ClubRanking.fromJson(e)).toList();
    }

    throw Exception("Failed to fetch rankings: ${response.body}");
  }

  static Future<void> createRanking({
    required int clubId,
    required int ranking,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "club": clubId,
        "peringkat": ranking,
        "musim": "2025",
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create ranking: ${response.body}");
    }
  }
}
