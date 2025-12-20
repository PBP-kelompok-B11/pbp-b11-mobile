import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String baseUrl = "http://127.0.0.1:8000/search/api/test/";

  // =======================
  // 🔍 SEARCH
  // =======================
  static Future<Map<String, dynamic>> search({
    required String query,
    required String type, // players | clubs | events
  }) async {
    final uri = Uri.parse(
      "$baseUrl/search/?q=${Uri.encodeQueryComponent(query)}&type=$type",
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Search failed: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // =======================
  // 📜 GET HISTORY (LOGIN)
  // =======================
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final uri = Uri.parse("$baseUrl/search/history/");

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load search history");
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data["history"]);
  }

  // =======================
  // ❌ DELETE ALL HISTORY
  // =======================
  static Future<void> clearHistory() async {
    final uri = Uri.parse("$baseUrl/search/history/clear/");

    final response = await http.delete(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to clear history");
    }
  }

  // =======================
  // ❌ DELETE ONE HISTORY
  // =======================
  static Future<void> deleteHistoryItem(int historyId) async {
    final uri = Uri.parse("$baseUrl/search/history/$historyId/");

    final response = await http.delete(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete history item");
    }
  }
  // =======================
  // 🔮 SEARCH SUGGESTION
  // =======================
  static Future<List<Map<String, dynamic>>> getSuggestions({
    required String query,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/search/suggest/?q=${Uri.encodeQueryComponent(query)}",
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load suggestions");
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data["results"]);
  }
}

