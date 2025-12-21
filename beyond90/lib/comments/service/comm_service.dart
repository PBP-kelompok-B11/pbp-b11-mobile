import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/comments/models/comm.dart';

class CommentService {
  static const String baseUrl =
      "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/comments/flutter";

  static Future<CommentEntry> fetchComments(
      CookieRequest request,
      String type,
      String targetId,
      ) async {
    final response = await request.get("$baseUrl/$type/$targetId/");
    return CommentEntry.fromJson(response);
  }

  static Future<void> addComment(
      CookieRequest request,
      String type,
      String targetId,
      String isiKomentar,
      ) async {
    final response = await request.post(
      "$baseUrl/add/$type/$targetId/",
      {"isi_komentar": isiKomentar},
    );

    if (response["status"] != "success") {
      throw Exception("Gagal menambah komentar");
    }
  }

  static Future<void> editComment(
      CookieRequest request,
      int commentId,
      String isiKomentar,
      ) async {
    final response = await request.post(
      "$baseUrl/edit/$commentId/",
      {"isi_komentar": isiKomentar},
    );

    if (response["status"] != "updated") {
      throw Exception("Gagal edit komentar");
    }
  }

  static Future<void> deleteComment(
      CookieRequest request,
      int commentId,
      ) async {
    final response = await request.post(
      "$baseUrl/delete/$commentId/",
      {},
    );

    if (response["status"] != "deleted") {
      throw Exception("Gagal hapus komentar");
    }
  }
}
