class ClubRanking {
  final int id;
  final int club;
  final String musim;
  final int peringkat;

  ClubRanking({
    required this.id,
    required this.club,
    required this.musim,
    required this.peringkat,
  });

  factory ClubRanking.fromJson(Map<String, dynamic> json) {
    return ClubRanking(
      id: json['id'],
      club: json['club'],    
      musim: json['musim'],
      peringkat: json['peringkat'],
    );
  }
}
