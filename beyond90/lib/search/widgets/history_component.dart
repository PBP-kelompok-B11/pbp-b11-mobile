import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  final VoidCallback onDeleteAll;

  const HistoryHeader({
    super.key,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🟩 History Label (HANYA LABEL, tidak clickable)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFB0FE08), // lime
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Text(
              "History",
              style: TextStyle(
                fontSize: 18, // text-2xl approx
                fontFamily: 'Geologica',
                color: Color(0xFF261893), // indigo-900
              ),
            ),
          ),

          // ❌ Delete All button (clickable)
          GestureDetector(
            onTap: onDeleteAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB0FE08),
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Text(
                "Delete All",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Geologica',
                  color: Color(0xFF261893),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
