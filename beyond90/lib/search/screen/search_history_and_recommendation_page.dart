import 'dart:async';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/search/service/search_service.dart';
import 'package:beyond90/search/widgets/search_bar.dart';
import 'package:beyond90/search/screen/search_result.dart';

class SearchHistoryAndSuggestionPage extends StatefulWidget {
  const SearchHistoryAndSuggestionPage({super.key});

  @override
  State<SearchHistoryAndSuggestionPage> createState() =>
      _SearchHistoryAndSuggestionPageState();
}

class _SearchHistoryAndSuggestionPageState
    extends State<SearchHistoryAndSuggestionPage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _suggestions = [];

  Timer? _debounce;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ======================
  // 📜 LOAD HISTORY
  // ======================
  Future<void> _loadHistory() async {
    try {
      final data = await SearchService.getHistory();
      setState(() => _history = data);
    } catch (_) {}
  }

  // ======================
  // 🔍 SUGGESTION
  // ======================
  void _onQueryChanged() {
    final query = _controller.text.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _loading = true);

      try {
        final data =
            await SearchService.getSuggestions(query: query);

        setState(() => _suggestions = data);
      } catch (_) {}

      setState(() => _loading = false);
    });
  }

  // ======================
  // 🚀 RESULT
  // ======================
  void _goResult(String query) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultPage(query: query),
      ),
    );
  }

  // ======================
  // ❌ DELETE
  // ======================
  Future<void> _deleteHistory(int id) async {
    await SearchService.deleteHistoryItem(id);
    _loadHistory();
  }

  Future<void> _deleteAll() async {
    await SearchService.clearHistory();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestion = _controller.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            SearchBarWidget(
              controller: _controller,
              onSubmitted: _goResult,
            ),
            const SizedBox(height: 24),
            if (!showSuggestion) _historyHeader(),
            Expanded(
              child: showSuggestion
                  ? _buildSuggestionList()
                  : _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // UI PARTS
  // ======================
  Widget _historyHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pill("History"),
            GestureDetector(
              onTap: _deleteAll,
              child: _pill("Delete All"),
            ),
          ],
        ),
      );

  Widget _pill(String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.indigo,
            fontSize: 20,
          ),
        ),
      );

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return const Center(
        child: Text("No search history",
            style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _history.length,
      itemBuilder: (_, i) {
        final h = _history[i];
        return _tile(
          text: h["kata_kunci"],
          onTap: () => _goResult(h["kata_kunci"]),
          onDelete: () => _deleteHistory(h["id"]),
        );
      },
    );
  }

  Widget _buildSuggestionList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.lime),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _suggestions.length,
      itemBuilder: (_, i) {
        final s = _suggestions[i];
        return _tile(
          text: s["title"],
          icon: Icons.search,
          onTap: () => _goResult(s["title"]),
        );
      },
    );
  }

  Widget _tile({
    required String text,
    required VoidCallback onTap,
    VoidCallback? onDelete,
    IconData icon = Icons.history,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(53),
          border: Border.all(color: AppColors.lime, width: 3),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.lime),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 22)),
            ),
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close,
                    color: AppColors.lime),
              ),
          ],
        ),
      ),
    );
  }
}
