class SeasonStat {
  final String musim;
  final int pertandingan;
  final int gol;
  final int assist;
  final int kartu;

  SeasonStat({required this.musim, required this.pertandingan, required this.gol, required this.assist, required this.kartu});

  factory SeasonStat.fromJson(Map<String, dynamic> json) {
    return SeasonStat(
      musim: json['musim'],
      pertandingan: json['pertandingan'],
      gol: json['gol'],
      assist: json['assist'],
      kartu: json['kartu'],
    );
  }
}
