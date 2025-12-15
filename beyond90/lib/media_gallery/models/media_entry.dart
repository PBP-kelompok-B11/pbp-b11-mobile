import 'dart:convert';

List<MediaEntry> mediaEntryFromJson(String str) => List<MediaEntry>.from(json.decode(str).map((x) => MediaEntry.fromJson(x)));

String mediaEntryToJson(List<MediaEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MediaEntry {
  String id;
  String deskripsi;
  String category;
  String thumbnail;
  DateTime createdAt;
  int viewers;

  MediaEntry({
    required this.id,
    required this.deskripsi,
    required this.category,
    required this.thumbnail,
    required this.createdAt,
    required this.viewers,
  });

  factory MediaEntry.fromJson(Map<String, dynamic> json) => MediaEntry(
    id: json["id"],
    deskripsi: json["deskripsi"],
    category: json["category"],
    thumbnail: json["thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    viewers: json["viewers"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deskripsi": deskripsi,
    "category": category,
    "thumbnail": thumbnail,
    "created_at": createdAt.toIso8601String(),
    "viewers": viewers,
  };
}
