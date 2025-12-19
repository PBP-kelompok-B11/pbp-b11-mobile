import 'package:pbp_django_auth/pbp_django_auth.dart';

class AuthService {
  // Gunakan 10.0.2.2 jika pakai emulator Android, atau IP asli jika pakai HP fisik
  static const String baseUrl = "http://localhost:8000";
  // static const String baseUrl = "https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/";
  // Variabel Global untuk status Admin
  static bool isAdmin = false;
  static String? currentUsername;

  // LOGIN - Sekarang menerima CookieRequest dari Provider
  static Future<Map<String, dynamic>> login(
      CookieRequest request, String username, String password) async {
    
    final url = "$baseUrl/login/";

    try {
      // Gunakan request.login (dari pbp_django_auth) BUKAN http.post
      final response = await request.login(url, {
        "username": username,
        "password": password,
      });

      if (request.loggedIn) {
        // Ambil status admin dari JSON response Django
        // Sesuaikan dengan key 'is_admin' yang kita buat di views.py tadi
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

  // LOGOUT - Harus memanggil endpoint Django agar session di server mati
  static Future<Map<String, dynamic>> logout(CookieRequest request) async {
    final url = "$baseUrl/logout/";
    try {
      final response = await request.logout(url);
      if (response['status'] == true || response['success'] == true) {
        isAdmin = false;
        currentUsername = null;
      }
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
      // Untuk register biasa menggunakan request.post
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