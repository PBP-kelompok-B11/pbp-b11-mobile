import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Pakai watch biar reaktif
    final bool isLoggedIn = request.loggedIn;

    return GestureDetector(
      onTap: () async {
        // 1. JIKA BELUM LOGIN -> KE HALAMAN LOGIN
        if (!isLoggedIn) {
          Navigator.pushNamed(context, '/login');
          return;
        }

        // 2. JIKA SUDAH LOGIN -> PROSES LOGOUT
        try {
          print("Memulai proses logout...");
          
          // GANTI URL: Sesuaikan dengan path di Django kamu
          // Pakai 10.0.2.2 untuk Android Emulator
          final response = await request.logout(
            'http://localhost:8000/api/logout/', 
          ).timeout(const Duration(seconds: 5));

          if (!context.mounted) return;

          // Cek response (Django kamu tadi kirim 'success' atau 'status')
          if (response['status'] == true || response['success'] == true) {
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logout berhasil! Sesi dibersihkan.')),
            );

            // 3. PINDAH KE LOGIN & RESET SEMUA ROUTE
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home', 
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout gagal: ${response['message'] ?? "Error server"}')),
            );
          }
        } catch (e) {
          print("Logout Error: $e");
          // Jika koneksi gagal, kita paksa bersihkan di sisi Flutter saja
          // agar user tidak terjebak di session yang rusak
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      child: Container(
        width: 140,
        height: 48,
        decoration: BoxDecoration(
          color: isLoggedIn ? Colors.redAccent : AppColors.lime,
          borderRadius: BorderRadius.circular(34),
        ),
        alignment: Alignment.center,
        child: Text(
          isLoggedIn ? "Logout" : "Login",
          style: TextStyle(
            fontFamily: 'Geologica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isLoggedIn ? Colors.white : AppColors.indigo,
          ),
        ),
      ),
    );
  }
}