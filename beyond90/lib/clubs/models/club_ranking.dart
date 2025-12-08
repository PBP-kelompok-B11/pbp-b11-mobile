class ClubRanking {
  final int id;
  final int clubId; 
  final String musim;
  final int peringkat;

  ClubRanking({
    required this.id,
    required this.clubId,
    required this.musim,
    required this.peringkat,
  });

  factory ClubRanking.fromJson(Map<String, dynamic> json) {
    return ClubRanking(
      id: json['id'],
      clubId: json['club'],       
      musim: json['musim'],
      peringkat: json['peringkat'],
    );
  }
}
