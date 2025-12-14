import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class AuthBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const AuthBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.indigo,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
