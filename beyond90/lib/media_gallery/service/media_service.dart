import 'dart:convert';
import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MediaService {
  // static const String baseURL = 'http://localhost:8000';
  static const String baseURL = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id";

  // method untuk increment jumlah viewers
  static Future<bool> updateViewers({
    required String mediaId,
    required int viewers,
  }) async{
    final url  = Uri.parse('$baseURL/media-gallery/$mediaId/increment_views/',
    );

    try{
      final response = await http.post(url);
       if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed with status: ${response.statusCode}');
        return false;
      }
    }catch (e){
      print('Update viewers error: $e');
      return false;
    }
  }

  // method untuk delete media
  static Future<bool> deleteMedia(String id) async{
    final url = Uri.parse('$baseURL/media-gallery/$id/delete-flutter/');

    try{
      final response = await http.delete(url);
      return response.statusCode == 200;
    } catch (e){
      debugPrint('Delete error: $e');
      return false;
    }
  } 

  // method untuk edit media
  static Future<MediaEntry?> editMedia({
    required String id,
    required String deskripsi,
    required category,
    required thumbnail,
  }) async{
    final url = Uri.parse('$baseURL/media-gallery/$id/edit-flutter/');

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'deskripsi': deskripsi,
          'category': category,
          'thumbnail': thumbnail,
        }),
      );

      debugPrint('Edit media status: ${response.statusCode}');
      debugPrint('Edit media body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MediaEntry.fromJson(data['media']);
      }

      return null;
    } catch (e) {
      debugPrint('Edit media error: $e');
      return null;
    }
  }

}