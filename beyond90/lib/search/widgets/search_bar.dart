import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // mengikuti proporsi figma (h-28)
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(53),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 🔍 ICON CIRCLE
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.indigo,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 24, 
                color: AppColors.indigo,
                fontFamily: 'Geologica',
                height: 1.3,
              ),
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: 24,
                  color: AppColors.indigo,
                  fontFamily: 'Geologica',
                  height: 1.3,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
