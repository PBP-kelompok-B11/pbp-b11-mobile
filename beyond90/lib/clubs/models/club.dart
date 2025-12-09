class Club {
  final int id;
  final String nama;
  final String negara;
  final String stadion;
  final int tahunBerdiri;
  final String? urlGambar;

  Club({
    required this.id,
    required this.nama,
    required this.negara,
    required this.stadion,
    required this.tahunBerdiri,
    this.urlGambar,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      nama: json['nama'],
      negara: json['negara'],
      stadion: json['stadion'],
      tahunBerdiri: json['tahun_berdiri'],
      urlGambar: json['url_gambar'],
    );
  }
}
