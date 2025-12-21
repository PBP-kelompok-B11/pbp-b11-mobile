import 'package:flutter/material.dart';
import 'package:beyond90/comments/models/comm.dart';
import 'package:beyond90/comments/service/comm_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentListWidget extends StatelessWidget {
  final String type;     // "event" | "player" | "club"
  final String targetId; // int -> string, uuid -> string

  const CommentListWidget({
    super.key,
    required this.type,
    required this.targetId,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder<CommentEntry>(
      future: _fetchComments(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final comments = snapshot.data!.comments;

        if (comments.isEmpty) {
          return const Center(
            child: Text("Belum ada komentar"),
          );
        }

        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final c = comments[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                title: Text(c.user.username),
                subtitle: Text(c.isiKomentar),
                trailing: c.canEdit
                    ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await CommentService.deleteComment(
                      request,
                      c.id,
                    );
                    (context as Element).reassemble();
                  },
                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Future<CommentEntry> _fetchComments(CookieRequest request) {
    switch (type) {
      case "event":
        return CommentService.fetchEventComments(
          request,
          int.parse(targetId),
        );
      case "club":
        return CommentService.fetchClubComments(
          request,
          int.parse(targetId),
        );
      case "player":
        return CommentService.fetchPlayerComments(
          request,
          targetId,
        );
      default:
        throw Exception("Invalid comment type");
    }
  }
}

