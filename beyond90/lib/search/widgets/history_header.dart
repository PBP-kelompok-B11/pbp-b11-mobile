import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SearchHistoryHeader extends StatelessWidget {
  final VoidCallback onDeleteAll;

  const SearchHistoryHeader({
    super.key,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pill("History"),
          GestureDetector(
            onTap: onDeleteAll,
            child: _pill("Delete All"),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.indigo,
          fontSize: 18,
          fontFamily: 'Geologica',
        ),
      ),
    );
  }
}
