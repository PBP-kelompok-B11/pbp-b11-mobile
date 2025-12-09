import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // LOGIN
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/authentication/login/");

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

      return jsonDecode(response.body);
    } catch (e) {
      print("Login error: $e");
      return {
        "success": false,
        "message": "Terjadi error pada koneksi."
      };
    }
  }

  // REGISTER
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
    final url = Uri.parse("$baseUrl/authentication/register/");

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
      print("Register error: $e");
      return {
        "success": false,
        "message": "Terjadi error pada koneksi."
      };
    }
  }
}
