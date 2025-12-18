
import 'package:beyond90/player/models/achievements.dart';
import 'package:beyond90/player/models/season_stat.dart';
import 'package:beyond90/player/models/career.dart';

class PlayerEntry {
  final String id;
  final String nama;
  final String negara;
  final int usia;
  final double tinggi;
  final double berat;
  final String posisi;
  final String thumbnail;
  final int? user_id ;

  final List<Achievement> achievement;
  final List<SeasonStat> seasonStats;
  final List<CareerHistory> careerHistory;

  PlayerEntry({
    required this.id,
    required this.nama,
    required this.negara,
    required this.usia,
    required this.tinggi,
    required this.berat,
    required this.posisi,
    required this.thumbnail,
    required this.achievement,
    required this.seasonStats,
    required this.careerHistory,
    required this.user_id,
  });

  factory PlayerEntry.fromJson(Map<String, dynamic> json) {

    return PlayerEntry(
      id: json['id'],
      nama: json['nama'],
      negara: json['negara'],
      usia: json['usia'],
      tinggi: (json['tinggi'] as num).toDouble(),
      berat: (json['berat'] as num).toDouble(),
      posisi: json['posisi'],
      thumbnail: json['thumbnail'],
      user_id: json['user_id'],
      achievement: (json['achievement'] as List<dynamic>? ?? [])
          .map((a) => Achievement.fromJson(a))
          .toList(),

      seasonStats: (json['season_stats'] as List<dynamic>? ?? [])
          .map((s) => SeasonStat.fromJson(s))
          .toList(),

      careerHistory: (json['career_history'] as List<dynamic>? ?? [])
          .map((c) => CareerHistory.fromJson(c))
          .toList(),

    );
  }
}
