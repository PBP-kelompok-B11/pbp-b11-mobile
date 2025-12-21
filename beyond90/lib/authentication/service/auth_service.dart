import 'package:pbp_django_auth/pbp_django_auth.dart';

class AuthService {
  //static const String baseUrl = "http://localhost:8000";
  static const String baseUrl = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id";
  // Variabel Global untuk status Admin
  static bool isAdmin = false;
  static String? currentUsername;

  static Future<Map<String, dynamic>> login(
      CookieRequest request, String username, String password) async {
    
    final url = "$baseUrl/api/login/";

    try {
      final response = await request.login(url, {
        "username": username,
        "password": password,
      });

      if (request.loggedIn) {
        isAdmin = response["is_admin"] ?? false;
        currentUsername = response["username"];
        
        print("Login Berhasil sebagai $currentUsername. Admin: $isAdmin");
      }
      
      return response;
    } catch (e) {
      print("Login error: $e");
      return {
        "success": false,
        "message": "Terjadi error pada koneksi: $e"
      };
    }
  }

  static Future<Map<String, dynamic>> logout(CookieRequest request) async {
    final url = "$baseUrl/api/logout/";
    try {
      final response = await request.post(url, {});
      isAdmin = false;
      currentUsername = null;
      return response;
    } catch (e) {
      return {"success": false, "message": "Logout gagal: $e"};
    }
  }

  // REGISTER
  static Future<Map<String, dynamic>> register(
    CookieRequest request, {
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String alamat,
    required String umur,
    required String nomorHp,
    required String role,
  }) async {
    final url = "$baseUrl/register/";
    try {
      final response = await request.post(url, {
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "alamat": alamat,
        "umur": umur,
        "nomor_handphone": nomorHp,
        "role": role,
      });
      return response;
    } catch (e) {
      return {"success": false, "message": "Error koneksi: $e"};
    }
  }
}