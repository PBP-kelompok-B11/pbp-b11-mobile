import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CookieRequest>(
      builder: (context, request, _) {
        final bool isLoggedIn = request.loggedIn;

        return GestureDetector(
          onTap: () async {
            // 1. JIKA BELUM LOGIN -> PINDAH KE HALAMAN LOGIN
            if (!isLoggedIn) {
              Navigator.pushNamed(context, '/login');
              return;
            }

            // 2. JIKA SUDAH LOGIN -> PROSES LOGOUT
            // Gunakan IP 10.0.2.2 jika pakai emulator Android, atau 127.0.0.1 jika Chrome
            final response = await request.logout(
              'http://127.0.0.1:8000/logout/',
            );

            if (context.mounted) {
              // Cek apakah logout sukses di sisi Django
              if (response['status'] == true || response['success'] == true) {
                
                // RESET status admin global kita agar bersih
                // AuthService.isAdmin = false; 

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout berhasil!')),
                );

                // 3. PINDAH KE HALAMAN LOGIN & HAPUS SEMUA HALAMAN SEBELUMNYA
                // Kita gunakan pushNamedAndRemoveUntil agar user tidak bisa klik 'Back' ke Home
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/login', 
                  (route) => false,
                );
              } else {
                // Jika gagal (misal koneksi mati)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout gagal: ${response['message']}')),
                );
              }
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
      },
    );
  }
}
