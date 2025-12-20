import 'dart:convert';

List<EventEntry> eventEntryFromJson(String str) =>
    List<EventEntry>.from(json.decode(str).map((x) => EventEntry.fromJson(x)));

String eventEntryToJson(List<EventEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        model: json["model"] ?? "vidia_event.event",
        pk: json["pk"] ?? 0,
        fields: Fields.fromJson(json["fields"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };

  factory EventEntry.empty() {
    return EventEntry(
      model: "vidia_event.event",
      pk: 0,
      fields: Fields(
        namaEvent: "No Event",
        lokasi: "-",
        tanggal: DateTime.now(),
        timHome: "No Data",
        timAway: "",
        skorHome: null,
        skorAway: null,
        createdBy: null,
        username: "",
        logoHome: null,
        logoAway: null,
      ),
    );
  }
}

class Fields {
  String namaEvent;
  String lokasi;
  DateTime tanggal;
  String timHome;
  String timAway;
  int? skorHome;
  int? skorAway;
  int? createdBy;
  String username;
  String? logoHome; // opsional, URL logo tim home
  String? logoAway; // opsional, URL logo tim away

  Fields({
    required this.namaEvent,
    required this.lokasi,
    required this.tanggal,
    required this.timHome,
    required this.timAway,
    this.skorHome,
    this.skorAway,
    this.createdBy,
    required this.username,
    this.logoHome,
    this.logoAway,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaEvent: json["nama_event"] ?? "Event Tanpa Nama",
        lokasi: json["lokasi"] ?? "Lokasi Belum Diatur",
        tanggal: json["tanggal"] != null
            ? DateTime.parse(json["tanggal"])
            : DateTime.now(),
        timHome: json["tim_home"] ?? "-",
        timAway: json["tim_away"] ?? "-",
        skorHome: json["skor_home"],
        skorAway: json["skor_away"],
        createdBy: json["created_by"],
        username: json["username"] ?? "Unknown User",
        logoHome: json["logo_home"], // nullable
        logoAway: json["logo_away"], // nullable
      );

  Map<String, dynamic> toJson() => {
        "nama_event": namaEvent,
        "lokasi": lokasi,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "tim_home": timHome,
        "tim_away": timAway,
        "skor_home": skorHome,
        "skor_away": skorAway,
        "created_by": createdBy,
        "username": username,
        "logo_home": logoHome,
        "logo_away": logoAway,
      };
}
