enum SeasonPhase {
  preseason('オープン戦'),
  regularSeason('レギュラーシーズン'),
  playoffs('プレーオフ'),
  offseason('オフシーズン');

  const SeasonPhase(this.label);
  final String label;
}

enum GameStatus {
  scheduled('予定'),
  inProgress('試合中'),
  completed('完了'),
  cancelled('中止'),
  postponed('延期');

  const GameStatus(this.label);
  final String label;
}

class PennantRace {
  final String id;
  final int year;
  final SeasonPhase phase;
  final DateTime seasonStart;
  final DateTime seasonEnd;
  final DateTime currentDate;
  final int currentWeek;
  final int totalWeeks;
  final List<String> teamIds;
  final Map<String, dynamic> standings;
  final List<String> gameIds;
  final Map<String, dynamic> seasonStats;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PennantRace({
    required this.id,
    required this.year,
    required this.phase,
    required this.seasonStart,
    required this.seasonEnd,
    required this.currentDate,
    required this.currentWeek,
    required this.totalWeeks,
    required this.teamIds,
    required this.standings,
    required this.gameIds,
    required this.seasonStats,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PennantRace.initial({
    required String id,
    required int year,
    required List<String> teamIds,
  }) {
    final seasonStart = DateTime(year, 4, 1);
    final seasonEnd = DateTime(year, 10, 31);
    final now = DateTime.now();
    
    return PennantRace(
      id: id,
      year: year,
      phase: SeasonPhase.preseason,
      seasonStart: seasonStart,
      seasonEnd: seasonEnd,
      currentDate: now,
      currentWeek: 1,
      totalWeeks: 26, // 約6ヶ月
      teamIds: teamIds,
      standings: _createInitialStandings(teamIds),
      gameIds: [],
      seasonStats: _createInitialSeasonStats(),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  static Map<String, dynamic> _createInitialStandings(List<String> teamIds) {
    final standings = <String, dynamic>{};
    for (final teamId in teamIds) {
      standings[teamId] = {
        'wins': 0,
        'losses': 0,
        'ties': 0,
        'winPercentage': 0.0,
        'gamesBack': 0.0,
        'runsScored': 0,
        'runsAllowed': 0,
        'runDifferential': 0,
        'gamesPlayed': 0,
        'lastTen': '0-0',
        'streak': 0,
        'homeRecord': '0-0',
        'awayRecord': '0-0',
      };
    }
    return standings;
  }

  static Map<String, dynamic> _createInitialSeasonStats() {
    return {
      'totalGames': 0,
      'completedGames': 0,
      'totalRuns': 0,
      'totalHomeRuns': 0,
      'totalStolenBases': 0,
      'totalStrikeouts': 0,
      'totalWalks': 0,
      'averageGameLength': 0.0,
      'attendance': 0,
      'weatherDelays': 0,
      'extraInningGames': 0,
      'shutouts': 0,
      'noHitters': 0,
      'perfectGames': 0,
    };
  }

  PennantRace copyWith({
    String? id,
    int? year,
    SeasonPhase? phase,
    DateTime? seasonStart,
    DateTime? seasonEnd,
    DateTime? currentDate,
    int? currentWeek,
    int? totalWeeks,
    List<String>? teamIds,
    Map<String, dynamic>? standings,
    List<String>? gameIds,
    Map<String, dynamic>? seasonStats,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PennantRace(
      id: id ?? this.id,
      year: year ?? this.year,
      phase: phase ?? this.phase,
      seasonStart: seasonStart ?? this.seasonStart,
      seasonEnd: seasonEnd ?? this.seasonEnd,
      currentDate: currentDate ?? this.currentDate,
      currentWeek: currentWeek ?? this.currentWeek,
      totalWeeks: totalWeeks ?? this.totalWeeks,
      teamIds: teamIds ?? this.teamIds,
      standings: standings ?? this.standings,
      gameIds: gameIds ?? this.gameIds,
      seasonStats: seasonStats ?? this.seasonStats,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  PennantRace advanceWeek() {
    final nextWeek = currentWeek + 1;
    final nextDate = currentDate.add(const Duration(days: 7));
    
    SeasonPhase nextPhase = phase;
    if (nextDate.isAfter(seasonStart) && phase == SeasonPhase.preseason) {
      nextPhase = SeasonPhase.regularSeason;
    } else if (nextDate.isAfter(seasonEnd) && phase == SeasonPhase.regularSeason) {
      nextPhase = SeasonPhase.playoffs;
    } else if (nextDate.isAfter(seasonEnd.add(const Duration(days: 30))) && phase == SeasonPhase.playoffs) {
      nextPhase = SeasonPhase.offseason;
    }
    
    return copyWith(
      currentWeek: nextWeek,
      currentDate: nextDate,
      phase: nextPhase,
    );
  }

  PennantRace updatePhase(SeasonPhase newPhase) {
    return copyWith(phase: newPhase);
  }

  PennantRace addGame(String gameId) {
    if (!gameIds.contains(gameId)) {
      return copyWith(
        gameIds: [...gameIds, gameId],
      );
    }
    return this;
  }

  PennantRace removeGame(String gameId) {
    return copyWith(
      gameIds: gameIds.where((id) => id != gameId).toList(),
    );
  }

  PennantRace updateStandings(String teamId, Map<String, dynamic> newStats) {
    final updatedStandings = Map<String, dynamic>.from(standings);
    if (updatedStandings.containsKey(teamId)) {
      final currentStats = Map<String, dynamic>.from(updatedStandings[teamId]);
      currentStats.addAll(newStats);
      
      // 勝率を計算
      final wins = currentStats['wins'] ?? 0;
      final losses = currentStats['losses'] ?? 0;
      final ties = currentStats['ties'] ?? 0;
      final totalGames = wins + losses + ties;
      
      if (totalGames > 0) {
        currentStats['winPercentage'] = wins / totalGames;
        currentStats['gamesPlayed'] = totalGames;
      }
      
      // 得失点差を計算
      final runsScored = currentStats['runsScored'] ?? 0;
      final runsAllowed = currentStats['runsAllowed'] ?? 0;
      currentStats['runDifferential'] = runsScored - runsAllowed;
      
      updatedStandings[teamId] = currentStats;
    }
    
    return copyWith(standings: updatedStandings);
  }

  PennantRace updateSeasonStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(seasonStats);
    updatedStats.addAll(newStats);
    return copyWith(seasonStats: updatedStats);
  }

  PennantRace calculateStandings() {
    final updatedStandings = Map<String, dynamic>.from(standings);
    final teamRecords = <String, Map<String, dynamic>>{};
    
    // 各チームの記録を取得
    for (final teamId in teamIds) {
      if (updatedStandings.containsKey(teamId)) {
        teamRecords[teamId] = Map<String, dynamic>.from(updatedStandings[teamId]);
      }
    }
    
    // 勝率でソート
    final sortedTeams = teamRecords.entries.toList()
      ..sort((a, b) {
        final aWinPct = a.value['winPercentage'] ?? 0.0;
        final bWinPct = b.value['winPercentage'] ?? 0.0;
        return bWinPct.compareTo(aWinPct);
      });
    
    // ゲーム差を計算
    if (sortedTeams.isNotEmpty) {
      final leader = sortedTeams.first;
      final leaderWins = leader.value['wins'] ?? 0;
      final leaderLosses = leader.value['losses'] ?? 0;
      final leaderGames = leaderWins + leaderLosses;
      
      for (int i = 1; i < sortedTeams.length; i++) {
        final team = sortedTeams[i];
        final teamWins = team.value['wins'] ?? 0;
        final teamLosses = team.value['losses'] ?? 0;
        final teamGames = teamWins + teamLosses;
        
        if (leaderGames > 0 && teamGames > 0) {
          final gamesBack = ((leaderWins - leaderLosses) - (teamWins - teamLosses)) / 2.0;
          team.value['gamesBack'] = gamesBack.abs();
        }
      }
    }
    
    // 更新された順位表を適用
    for (final entry in sortedTeams) {
      updatedStandings[entry.key] = entry.value;
    }
    
    return copyWith(standings: updatedStandings);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'phase': phase.name,
      'seasonStart': seasonStart.toIso8601String(),
      'seasonEnd': seasonEnd.toIso8601String(),
      'currentDate': currentDate.toIso8601String(),
      'currentWeek': currentWeek,
      'totalWeeks': totalWeeks,
      'teamIds': teamIds,
      'standings': standings,
      'gameIds': gameIds,
      'seasonStats': seasonStats,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PennantRace.fromJson(Map<String, dynamic> json) {
    return PennantRace(
      id: json['id'] as String,
      year: json['year'] as int,
      phase: SeasonPhase.values.firstWhere((e) => e.name == json['phase']),
      seasonStart: DateTime.parse(json['seasonStart'] as String),
      seasonEnd: DateTime.parse(json['seasonEnd'] as String),
      currentDate: DateTime.parse(json['currentDate'] as String),
      currentWeek: json['currentWeek'] as int,
      totalWeeks: json['totalWeeks'] as int,
      teamIds: List<String>.from(json['teamIds']),
      standings: Map<String, dynamic>.from(json['standings']),
      gameIds: List<String>.from(json['gameIds']),
      seasonStats: Map<String, dynamic>.from(json['seasonStats']),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PennantRace && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PennantRace(id: $id, year: $year, phase: ${phase.label}, week: $currentWeek/$totalWeeks)';
  }
}
