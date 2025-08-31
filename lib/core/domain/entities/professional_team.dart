import 'package:flutter/foundation.dart';

enum League {
  central('セ・リーグ'),
  pacific('パ・リーグ');

  const League(this.label);
  final String label;
}

enum TeamStatus {
  active('活動中'),
  inactive('非活動');

  const TeamStatus(this.label);
  final String label;
}

class ProfessionalTeam {
  final String id;
  final String name;
  final String shortName;
  final League league;
  final String city;
  final String stadium;
  final TeamStatus status;
  final DateTime founded;
  final List<String> playerIds;
  final Map<String, dynamic> seasonStats;
  final Map<String, dynamic> allTimeStats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfessionalTeam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.league,
    required this.city,
    required this.stadium,
    required this.status,
    required this.founded,
    required this.playerIds,
    required this.seasonStats,
    required this.allTimeStats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalTeam.initial({
    required String id,
    required String name,
    required String shortName,
    required League league,
    required String city,
    required String stadium,
  }) {
    final now = DateTime.now();
    return ProfessionalTeam(
      id: id,
      name: name,
      shortName: shortName,
      league: league,
      city: city,
      stadium: stadium,
      status: TeamStatus.active,
      founded: now,
      playerIds: [],
      seasonStats: {
        'wins': 0,
        'losses': 0,
        'ties': 0,
        'winPercentage': 0.0,
        'gamesBack': 0.0,
        'runsScored': 0,
        'runsAllowed': 0,
        'runDifferential': 0,
      },
      allTimeStats: {
        'seasons': 0,
        'totalWins': 0,
        'totalLosses': 0,
        'totalTies': 0,
        'championships': 0,
        'playoffAppearances': 0,
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  ProfessionalTeam copyWith({
    String? id,
    String? name,
    String? shortName,
    League? league,
    String? city,
    String? stadium,
    TeamStatus? status,
    DateTime? founded,
    List<String>? playerIds,
    Map<String, dynamic>? seasonStats,
    Map<String, dynamic>? allTimeStats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      league: league ?? this.league,
      city: city ?? this.city,
      stadium: stadium ?? this.stadium,
      status: status ?? this.status,
      founded: founded ?? this.founded,
      playerIds: playerIds ?? this.playerIds,
      seasonStats: seasonStats ?? this.seasonStats,
      allTimeStats: allTimeStats ?? this.allTimeStats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  ProfessionalTeam addPlayer(String playerId) {
    if (!playerIds.contains(playerId)) {
      return copyWith(
        playerIds: [...playerIds, playerId],
      );
    }
    return this;
  }

  ProfessionalTeam removePlayer(String playerId) {
    return copyWith(
      playerIds: playerIds.where((id) => id != playerId).toList(),
    );
  }

  ProfessionalTeam updateSeasonStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(seasonStats);
    updatedStats.addAll(newStats);
    
    // 勝率を計算
    final wins = updatedStats['wins'] ?? 0;
    final losses = updatedStats['losses'] ?? 0;
    final ties = updatedStats['ties'] ?? 0;
    final totalGames = wins + losses + ties;
    
    if (totalGames > 0) {
      updatedStats['winPercentage'] = wins / totalGames;
    }
    
    // 得失点差を計算
    final runsScored = updatedStats['runsScored'] ?? 0;
    final runsAllowed = updatedStats['runsAllowed'] ?? 0;
    updatedStats['runDifferential'] = runsScored - runsAllowed;
    
    return copyWith(seasonStats: updatedStats);
  }

  ProfessionalTeam resetSeasonStats() {
    return copyWith(
      seasonStats: {
        'wins': 0,
        'losses': 0,
        'ties': 0,
        'winPercentage': 0.0,
        'gamesBack': 0.0,
        'runsScored': 0,
        'runsAllowed': 0,
        'runDifferential': 0,
      },
    );
  }

  ProfessionalTeam updateAllTimeStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(allTimeStats);
    updatedStats.addAll(newStats);
    return copyWith(allTimeStats: updatedStats);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'league': league.name,
      'city': city,
      'stadium': stadium,
      'status': status.name,
      'founded': founded.toIso8601String(),
      'playerIds': playerIds,
      'seasonStats': seasonStats,
      'allTimeStats': allTimeStats,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfessionalTeam.fromJson(Map<String, dynamic> json) {
    return ProfessionalTeam(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      league: League.values.firstWhere((e) => e.name == json['league']),
      city: json['city'] as String,
      stadium: json['stadium'] as String,
      status: TeamStatus.values.firstWhere((e) => e.name == json['status']),
      founded: DateTime.parse(json['founded'] as String),
      playerIds: List<String>.from(json['playerIds']),
      seasonStats: Map<String, dynamic>.from(json['seasonStats']),
      allTimeStats: Map<String, dynamic>.from(json['allTimeStats']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfessionalTeam && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProfessionalTeam(id: $id, name: $name, league: ${league.label})';
  }
}
