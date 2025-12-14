import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            // TODO: Navigate ke Login Page
            // contoh nanti:
            // Navigator.pushNamed(context, '/login');
          },
      child: Container(
        width: 140,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(34),
        ),
        alignment: Alignment.center,
        child: Text(
          "Login",
          style: TextStyle(
            fontFamily: 'Geologica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.indigo,
          ),
        ),
      ),
    );
  }
}
