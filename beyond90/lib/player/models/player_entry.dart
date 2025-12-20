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
  final int? user_id;

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
    required this.user_id,
    required this.achievement,
    required this.seasonStats,
    required this.careerHistory,
  });

  factory PlayerEntry.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> fields =
        (json['fields'] as Map<String, dynamic>?) ?? json;

    return PlayerEntry(
      id: (fields['id'] ?? json['pk'] ?? '').toString(),
      nama: fields['nama'] ?? '',
      negara: fields['negara'] ?? '',
      usia: fields['usia'] is int ? fields['usia'] : int.tryParse('${fields['usia']}') ?? 0,
      tinggi: (fields['tinggi'] as num?)?.toDouble() ?? 0.0,
      berat: (fields['berat'] as num?)?.toDouble() ?? 0.0,
      posisi: fields['posisi'] ?? '',
      thumbnail: fields['thumbnail'] ?? '',
      user_id: fields['user'],

      achievement: (fields['achievement'] as List<dynamic>?)
              ?.map((a) => Achievement.fromJson(a))
              .toList() ??
          [],
      seasonStats: (fields['season_stats'] as List<dynamic>?)
              ?.map((s) => SeasonStat.fromJson(s))
              .toList() ??
          [],
      careerHistory: (fields['career_history'] as List<dynamic>?)
              ?.map((c) => CareerHistory.fromJson(c))
              .toList() ??
          [],
    );
  }
}
