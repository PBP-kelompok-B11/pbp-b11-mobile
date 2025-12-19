import 'dart:convert';
import 'package:http/http.dart' as http;

class MediaService {
  static const String baseURL = 'http://localhost:8000';

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
}