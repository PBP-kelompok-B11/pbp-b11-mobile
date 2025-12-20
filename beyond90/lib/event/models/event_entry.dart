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
    int? skorHome; // 👈 Tambahkan tanda tanya (?) agar bisa null
    int? skorAway; // 👈 Tambahkan tanda tanya (?) agar bisa null
    int? createdBy;
    String username;

    Fields({
        required this.namaEvent,
        required this.lokasi,
        required this.tanggal,
        required this.timHome,
        required this.timAway,
        this.skorHome, // 👈 Hapus 'required' jika ingin opsional di constructor
        this.skorAway, // 👈 Hapus 'required' jika ingin opsional di constructor
        this.createdBy,
        required this.username,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaEvent: json["nama_event"] ?? "Event Tanpa Nama",
        lokasi: json["lokasi"] ?? "Lokasi Belum Diatur",
        tanggal: DateTime.parse(json["tanggal"] ?? DateTime.now().toIso8601String()),
        timHome: json["tim_home"] ?? "-",
        timAway: json["tim_away"] ?? "-",
        // 🔥 JANGAN gunakan ?? 0, biarkan dia null kalau memang dari JSON-nya null
        skorHome: json["skor_home"], 
        skorAway: json["skor_away"],
        createdBy: json["created_by"], 
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