import 'package:beyond90/search/widgets/suggestion_item.dart';
import 'package:flutter/material.dart';

class SearchSuggestionList extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;
  final Function(String) onSelect;

  const SearchSuggestionList({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox();

    return Column(
      children: suggestions.map((s) {
        return SearchSuggestionItem(
          title: s["title"],
          subtitle: s["subtitle"] ?? "",
          label: s["label"],
          onTap: () => onSelect(s["title"]),
        );
      }).toList(),
    );
  }
}
