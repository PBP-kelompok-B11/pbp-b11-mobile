// To parse this JSON data, do
//
//     final commentEntry = commentEntryFromJson(jsonString);

import 'dart:convert';

CommentEntry commentEntryFromJson(String str) => CommentEntry.fromJson(json.decode(str));

String commentEntryToJson(CommentEntry data) => json.encode(data.toJson());

class CommentEntry {
  Target target;
  List<Comment> comments;

  CommentEntry({
    required this.target,
    required this.comments,
  });

  factory CommentEntry.fromJson(Map<String, dynamic> json) => CommentEntry(
    target: Target.fromJson(json["target"]),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "target": target.toJson(),
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  int id;
  User user;
  String isiKomentar;
  DateTime tanggal;
  bool canEdit;

  Comment({
    required this.id,
    required this.user,
    required this.isiKomentar,
    required this.tanggal,
    required this.canEdit,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    user: User.fromJson(json["user"]),
    isiKomentar: json["isi_komentar"],
    tanggal: DateTime.parse(json["tanggal"]),
    canEdit: json["can_edit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "isi_komentar": isiKomentar,
    "tanggal": tanggal.toIso8601String(),
    "can_edit": canEdit,
  };
}

class User {
  int id;
  String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}

class Target {
  String type;
  String id;
  String name;

  Target({
    required this.type,
    required this.id,
    required this.name,
  });

  factory Target.fromJson(Map<String, dynamic> json) => Target(
    type: json["type"],
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "name": name,
  };
}
