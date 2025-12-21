import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/comments/models/comm.dart';

class CommentService {
  static const String baseUrl =
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id";

  // ======================
  // FETCH COMMENTS
  // ======================

  static Future<CommentEntry> fetchEventComments(
      CookieRequest request,
      int eventId,
      ) async {
    final response = await request.get(
      "$baseUrl/comments/json/event/$eventId/",
    );

    return CommentEntry.fromJson(response);
  }

  static Future<CommentEntry> fetchPlayerComments(
      CookieRequest request,
      String playerUuid,
      ) async {
    final response = await request.get(
      "$baseUrl/comments/json/player/$playerUuid/",
    );

    return CommentEntry.fromJson(response);
  }

  static Future<CommentEntry> fetchClubComments(
      CookieRequest request,
      int clubId,
      ) async {
    final response = await request.get(
      "$baseUrl/comments/json/club/$clubId/",
    );

    return CommentEntry.fromJson(response);
  }

  // ======================
  // ADD COMMENT
  // ======================

  static Future<void> addComment({
    required CookieRequest request,
    required String type, // event | player | club
    required String targetId,
    required String isiKomentar,
  }) async {
    final response = await request.post(
      "$baseUrl/comments/add/$type/$targetId/",
      {
        "isi_komentar": isiKomentar,
      },
    );

    if (response["status"] != "success") {
      throw Exception(response["message"]);
    }
  }

  // ======================
  // DELETE COMMENT
  // ======================

  static Future<void> deleteComment(
      CookieRequest request,
      int commentId,
      ) async {
    final response = await request.post(
      "$baseUrl/comments/delete/$commentId/",
      {},
    );

    if (response["status"] != "success") {
      throw Exception(response["message"]);
    }
  }
}

