import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SearchSuggestionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String label;
  final VoidCallback onTap;

  const SearchSuggestionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontFamily: 'Geologica',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.indigo,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
