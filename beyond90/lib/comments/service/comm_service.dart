import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beyond90/comments/models/comm.dart';

class CommentService {
  static const String baseUrl = 'http://localhost:8000';

  /// ===============================
  /// GET COMMENTS
  /// ===============================

  static Future<CommentEntry> fetchEventComments(int eventId) async {
    final url = Uri.parse('$baseUrl/comments/json/event/$eventId/');
    return _fetchComments(url);
  }

  static Future<CommentEntry> fetchPlayerComments(String playerUuid) async {
    final url = Uri.parse('$baseUrl/comments/json/player/$playerUuid/');
    return _fetchComments(url);
  }

  static Future<CommentEntry> fetchClubComments(int clubId) async {
    final url = Uri.parse('$baseUrl/comments/json/club/$clubId/');
    return _fetchComments(url);
  }

  static Future<CommentEntry> _fetchComments(Uri url) async {
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return commentEntryFromJson(response.body);
    } else {
      throw Exception('Gagal memuat komentar');
    }
  }

  /// ===============================
  /// ADD COMMENT
  /// ===============================

  static Future<void> addEventComment({
    required int eventId,
    required String isiKomentar,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final url = Uri.parse('$baseUrl/comments/add/event/$eventId/');
    await _postComment(
      url: url,
      isiKomentar: isiKomentar,
      csrfToken: csrfToken,
      sessionCookie: sessionCookie,
    );
  }

  static Future<void> addPlayerComment({
    required String playerUuid,
    required String isiKomentar,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final url = Uri.parse('$baseUrl/comments/add/player/$playerUuid/');
    await _postComment(
      url: url,
      isiKomentar: isiKomentar,
      csrfToken: csrfToken,
      sessionCookie: sessionCookie,
    );
  }

  static Future<void> addClubComment({
    required int clubId,
    required String isiKomentar,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final url = Uri.parse('$baseUrl/comments/add/club/$clubId/');
    await _postComment(
      url: url,
      isiKomentar: isiKomentar,
      csrfToken: csrfToken,
      sessionCookie: sessionCookie,
    );
  }

  static Future<void> _postComment({
    required Uri url,
    required String isiKomentar,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRFToken': csrfToken,
        'Cookie': sessionCookie,
      },
      body: {
        'isi_komentar': isiKomentar,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      throw Exception('Gagal menambahkan komentar');
    }
  }

  /// ===============================
  /// EDIT COMMENT
  /// ===============================

  static Future<void> editComment({
    required int commentId,
    required String isiKomentar,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final url = Uri.parse('$baseUrl/comments/edit/$commentId/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRFToken': csrfToken,
        'Cookie': sessionCookie,
      },
      body: {
        'isi_komentar': isiKomentar,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      throw Exception('Gagal mengedit komentar');
    }
  }

  /// ===============================
  /// DELETE COMMENT
  /// ===============================

  static Future<void> deleteComment({
    required int commentId,
    required String csrfToken,
    required String sessionCookie,
  }) async {
    final url = Uri.parse('$baseUrl/comments/delete/$commentId/');
    final response = await http.post(
      url,
      headers: {
        'X-CSRFToken': csrfToken,
        'Cookie': sessionCookie,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      throw Exception('Gagal menghapus komentar');
    }
  }
}
