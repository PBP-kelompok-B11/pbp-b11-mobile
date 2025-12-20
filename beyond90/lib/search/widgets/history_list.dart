
import 'package:beyond90/search/widgets/history_item.dart';
import 'package:flutter/material.dart';

class SearchHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final Function(String) onSelect;
  final Function(int) onDelete;

  const SearchHistoryList({
    super.key,
    required this.history,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "No search history yet",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      children: history.map((item) {
        return SearchHistoryItem(
          keyword: item["kata_kunci"],
          onTap: () => onSelect(item["kata_kunci"]),
          onDelete: () => onDelete(item["id"]),
        );
      }).toList(),
    );
  }
}
