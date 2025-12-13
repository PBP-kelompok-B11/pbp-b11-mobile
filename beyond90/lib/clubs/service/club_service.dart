import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club.dart';

class ClubService {
  static const String baseUrl = "http://localhost:8000/clubs/api/";

  // LIST
  static Future<List<Club>> fetchClubs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data clubs");
    }
  }

  // DETAIL
  static Future<Club> fetchClubDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id/"));

    if (response.statusCode == 200) {
      return Club.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal mengambil detail club");
    }
  }

  // CREATE
  static Future<int> createClub(Map<String, dynamic> clubData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clubData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data["id"]; // return ID buat ranking
    } else {
      throw Exception("Gagal membuat club baru");
    }
  }

  // UPDATE
  static Future<void> updateClub(int id, Map<String, dynamic> clubData) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clubData),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Gagal mengupdate club");
    }
  }

  // DELETE
  static Future<void> deleteClub(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$id/"),
    );

    if (response.statusCode != 204) {
      throw Exception("Gagal menghapus club");
    }
  }

  // CREATE RANKING
  static Future<void> createRanking(int clubId, int ranking) async {
    final url = Uri.parse("$baseUrl$clubId/ranking/");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"peringkat": ranking, "musim": "2025"}),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal membuat ranking");
    }
  }
}
