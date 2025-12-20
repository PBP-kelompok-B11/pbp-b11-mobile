import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String baseUrl =
      "http://127.0.0.1:8000/search/api/search";

  // =======================
  // 🔍 SEARCH UTAMA
  // =======================
  static Future<Map<String, dynamic>> search({
    required String query,
    required String type, // players | clubs | events
  }) async {
    final uri = Uri.parse(
      "$baseUrl/?q=${Uri.encodeQueryComponent(query)}&type=$type",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Search failed");
    }

    return jsonDecode(response.body);
  }

  // =======================
  // 🔮 SUGGESTION
  // =======================
  static Future<List<Map<String, dynamic>>> getSuggestions({
    required String query,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/suggest/?q=${Uri.encodeQueryComponent(query)}",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Suggestion failed");
    }

    final data = jsonDecode(response.body);

    return List<Map<String, dynamic>>.from(data["results"]);
  }

  // =======================
  // 📜 HISTORY
  // =======================
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final uri = Uri.parse("$baseUrl/history/");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("History failed");
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data["history"]);
  }

  // =======================
  // ❌ DELETE 1
  // =======================
  static Future<void> deleteHistoryItem(int id) async {
    final uri = Uri.parse("$baseUrl/history/$id/");
    await http.delete(uri);
  }

  // =======================
  // ❌ CLEAR ALL
  // =======================
  static Future<void> clearHistory() async {
    final uri = Uri.parse("$baseUrl/history/clear/");
    await http.delete(uri);
  }
}
