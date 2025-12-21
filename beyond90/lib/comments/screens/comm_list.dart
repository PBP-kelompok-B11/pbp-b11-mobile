import 'package:flutter/material.dart';
import 'package:beyond90/comments/models/comm.dart';
import 'package:beyond90/comments/service/comm_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentListWidget extends StatefulWidget {
  final String type;      // event | player | club
  final String targetId;  // int -> string | uuid -> string

  const CommentListWidget({
    super.key,
    required this.type,
    required this.targetId,
  });

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  late Future<CommentEntry> _future;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final request = context.read<CookieRequest>();
    _future = CommentService.fetchComments(
      request,
      widget.type,
      widget.targetId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Container(
      color: const Color(0xFF1E1B4B), // indigo gelap
      child: Column(
        children: [
          // ======================
          // COMMENT LIST
          // ======================
          Expanded(
            child: FutureBuilder<CommentEntry>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.lime),
                  );
                }

                final comments = snapshot.data!.comments;

                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada komentar",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    final c = comments[i];

                    return Card(
                      color: const Color(0xFF312E81), // indigo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          c.user.username,
                          style: const TextStyle(
                            color: Colors.lime,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            c.isiKomentar,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: c.canEdit
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // EDIT
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.lime),
                              onPressed: () async {
                                _controller.text = c.isiKomentar;
                                await _showEditDialog(request, c.id);
                                setState(_refresh);
                              },
                            ),
                            // DELETE
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await CommentService.deleteComment(
                                  request,
                                  c.id,
                                );
                                setState(_refresh);
                              },
                            ),
                          ],
                        )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ======================
          // ADD COMMENT
          // ======================
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1B4B),
              border: Border(
                top: BorderSide(color: Colors.white24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Tulis komentar...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF312E81),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lime,
                    foregroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_controller.text.trim().isEmpty) return;

                    await CommentService.addComment(
                      request,
                      widget.type,
                      widget.targetId,
                      _controller.text,
                    );

                    _controller.clear();
                    setState(_refresh);
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================
  // EDIT DIALOG
  // ======================
  Future<void> _showEditDialog(
      CookieRequest request,
      int commentId,
      ) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text(
          "Edit Komentar",
          style: TextStyle(color: Colors.lime),
        ),
        content: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Edit komentar...",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lime,
              foregroundColor: Colors.indigo,
            ),
            child: const Text("Simpan"),
            onPressed: () async {
              await CommentService.editComment(
                request,
                commentId,
                _controller.text,
              );
              _controller.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}



