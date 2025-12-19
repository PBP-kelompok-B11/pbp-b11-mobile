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
        model: json["model"] ?? "vidia_event.event",
        pk: json["pk"] ?? 0,
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
    int? createdBy;
    String username; // Tambahkan ini untuk menampilkan 'admin1'

    Fields({
        required this.namaEvent,
        required this.lokasi,
        required this.tanggal,
        required this.timHome,
        required this.timAway,
        required this.skorHome,
        required this.skorAway,
        this.createdBy,
        required this.username,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaEvent: json["nama_event"] ?? "Event Tanpa Nama",
        lokasi: json["lokasi"] ?? "Lokasi Belum Diatur",
        // Jaga-jaga kalau tanggal kosong
        tanggal: DateTime.parse(json["tanggal"] ?? DateTime.now().toIso8601String()),
        timHome: json["tim_home"] ?? "-",
        timAway: json["tim_away"] ?? "-",
        // Jaga-jaga kalau skor kosong (null dari Django)
        skorHome: json["skor_home"] ?? 0,
        skorAway: json["skor_away"] ?? 0,
        createdBy: json["created_by"], 
        // Jaga-jaga kalau username tidak terkirim atau null
        username: json["username"] ?? "Unknown User",
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
        "username": username,
    };
}