import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club.dart';

class ClubService {
  static const String baseUrl = "http://127.0.0.1:8000/clubs/api/";

  static Future<List<Club>> fetchClubs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data clubs");
    }
  }

  static Future<Club> fetchClubDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id/"));

    if (response.statusCode == 200) {
      return Club.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal mengambil detail club");
    }
  }

  static Future<void> createClub(Map<String, dynamic> clubData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clubData),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Gagal membuat club baru");
    }
  }

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
}
