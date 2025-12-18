import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Ganti ke IP asli laptopmu jika testing di HP Android (contoh: 10.0.2.2 atau 192.168.x.x)
  static const String baseUrl = "http://127.0.0.1:8000";

  // Variabel Global untuk status Admin
  static bool isAdmin = false;
  
  // LOGIN
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login/");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: {
          "username": username,
          "password": password,
        },
      );

      // Di auth_service.dart, bagian login
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        // Pastikan key 'is_staff' sama dengan yang kamu tulis di Django
        isAdmin = data["is_staff"] ?? false; 
        print("Status isAdmin ter-update: $isAdmin");
      }
      return data;
    } catch (e) {
      print("Login error: $e");
      return {
        "success": false,
        "message": "Terjadi error pada koneksi."
      };
    }
  }

  // Tambahkan fungsi Logout untuk reset status
  static void logout() {
    isAdmin = false;
  }

  // REGISTER (Tetap sama, hanya dirapikan sedikit)
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String alamat,
    required String umur,
    required String nomorHp,
    required String role,
  }) async {
    final url = Uri.parse("$baseUrl/register/");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: {
          "username": username,
          "email": email,
          "password": password,
          "confirm_password": confirmPassword,
          "alamat": alamat,
          "umur": umur,
          "nomor_handphone": nomorHp,
          "role": role,
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}