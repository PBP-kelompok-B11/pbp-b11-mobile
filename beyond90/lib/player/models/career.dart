class CareerHistory {
  final String klub;
  final int tahunMulai;
  final int? tahunSelesai;

  CareerHistory({required this.klub, required this.tahunMulai, this.tahunSelesai});

  factory CareerHistory.fromJson(Map<String, dynamic> json) {
    return CareerHistory(
      klub: json['klub'],
      tahunMulai: json['tahun_mulai'],
      tahunSelesai: json['tahun_selesai'],
    );
  }
}
