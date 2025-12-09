import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club_ranking.dart';

class ClubRankingService {
  static const String baseUrl = "http://localhost:8000/clubs/ranking/api/";

  static Future<List<ClubRanking>> fetchAllRankings() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ClubRanking.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil ranking club");
    }
  }
}
