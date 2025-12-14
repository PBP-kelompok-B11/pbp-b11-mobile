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
            // BELUM LOGIN → LOGIN PAGE
            if (!isLoggedIn) {
              Navigator.pushNamed(context, '/login');
              return;
            }

            // SUDAH LOGIN → LOGOUT
            await request.logout(
              'http://localhost:8000/authentication/logout/',
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout berhasil')),
              );
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
