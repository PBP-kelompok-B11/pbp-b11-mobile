import 'package:flutter/material.dart';

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
      height: 56, // scaled h-28
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(53), // Figma rounded-[53px]
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 🔍 ICON
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF261893), // indigo-900
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          // 📝 INPUT TEXT
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 20, // text-4xl scaled
                color: Color(0xFF261893),
                fontFamily: 'Geologica',
              ),
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF261893),
                  fontFamily: 'Geologica',
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
