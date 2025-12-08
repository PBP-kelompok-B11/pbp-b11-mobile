// To parse this JSON data, do
//
//     final eventEntry = eventEntryFromJson(jsonString);

import 'dart:convert';

List<EventEntry> eventEntryFromJson(String str) => List<EventEntry>.from(json.decode(str).map((x) => EventEntry.fromJson(x)));

String eventEntryToJson(List<EventEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventEntry {
    String model;
    int pk;
    Fields fields;

    EventEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory EventEntry.fromJson(Map<String, dynamic> json) => EventEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String namaEvent;
    String lokasi;
    DateTime tanggal;
    String timHome;
    String timAway;
    int skorHome;
    int skorAway;
    dynamic createdBy;

    Fields({
        required this.namaEvent,
        required this.lokasi,
        required this.tanggal,
        required this.timHome,
        required this.timAway,
        required this.skorHome,
        required this.skorAway,
        this.createdBy,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaEvent: json["nama_event"],
        lokasi: json["lokasi"],
        tanggal: DateTime.parse(json["tanggal"]),
        timHome: json["tim_home"],
        timAway: json["tim_away"],
        skorHome: json["skor_home"],
        skorAway: json["skor_away"],
        createdBy: json["created_by"],
    );

    Map<String, dynamic> toJson() => {
        "nama_event": namaEvent,
        "lokasi": lokasi,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "tim_home": timHome,
        "tim_away": timAway,
        "skor_home": skorHome,
        "skor_away": skorAway,
        "created_by": createdBy,
    };
}
