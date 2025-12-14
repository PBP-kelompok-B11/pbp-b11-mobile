// To parse this JSON data, do
//
//     final playerEntry = playerEntryFromJson(jsonString);

import 'dart:convert';

List<PlayerEntry> playerEntryFromJson(String str) => List<PlayerEntry>.from(json.decode(str).map((x) => PlayerEntry.fromJson(x)));

String playerEntryToJson(List<PlayerEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerEntry {
    String id;
    String nama;
    String negara;
    int usia;
    int tinggi;
    int berat;
    String posisi;
    String thumbnail;
    int userId;

    PlayerEntry({
        required this.id,
        required this.nama,
        required this.negara,
        required this.usia,
        required this.tinggi,
        required this.berat,
        required this.posisi,
        required this.thumbnail,
        required this.userId,
    });

    factory PlayerEntry.fromJson(Map<String, dynamic> json) => PlayerEntry(
        id: json["id"],
        nama: json["nama"],
        negara: json["negara"],
        usia: json["usia"],
        tinggi: json["tinggi"],
        berat: json["berat"],
        posisi: json["posisi"],
        thumbnail: json["thumbnail"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "negara": negara,
        "usia": usia,
        "tinggi": tinggi,
        "berat": berat,
        "posisi": posisi,
        "thumbnail": thumbnail,
        "user_id": userId,
    };
}
