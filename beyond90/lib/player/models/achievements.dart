class Achievement {
  final String deskripsi;
  final int tahun;

  Achievement({required this.deskripsi, required this.tahun});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      deskripsi: json['deskripsi'],
      tahun: json['tahun'],
    );
  }
}

// tes