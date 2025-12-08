import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/club_ranking.dart';

class ClubRankingService {
  static const String baseUrl = "http://127.0.0.1:8000/clubs/ranking/api/";

  static Future<List<ClubRanking>> fetchAllRankings() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ClubRanking.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data ranking");
    }
  }

  static Future<ClubRanking> fetchRankingDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id/"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ClubRanking.fromJson(data);
    } else {
      throw Exception("Gagal mengambil detail ranking");
    }
  }

  static Future<List<ClubRanking>> fetchRankingByClub(int clubId) async {
    final url = "${baseUrl}?club=$clubId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ClubRanking.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil ranking club ID $clubId");
    }
  }
}
