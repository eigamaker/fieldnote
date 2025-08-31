enum LeagueType {
  central('セ・リーグ'),
  pacific('パ・リーグ');

  const LeagueType(this.label);
  final String label;
}

class LeagueStandings {
  final String id;
  final String pennantRaceId;
  final LeagueType league;
  final int year;
  final List<String> teamIds;
  final Map<String, dynamic> teamStandings;
  final Map<String, dynamic> leagueStats;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeagueStandings({
    required this.id,
    required this.pennantRaceId,
    required this.league,
    required this.year,
    required this.teamIds,
    required this.teamStandings,
    required this.leagueStats,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeagueStandings.initial({
    required String id,
    required String pennantRaceId,
    required LeagueType league,
    required int year,
    required List<String> teamIds,
  }) {
    final now = DateTime.now();
    
    return LeagueStandings(
      id: id,
      pennantRaceId: pennantRaceId,
      league: league,
      year: year,
      teamIds: teamIds,
      teamStandings: _createInitialTeamStandings(teamIds),
      leagueStats: _createInitialLeagueStats(),
      lastUpdated: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  static Map<String, dynamic> _createInitialTeamStandings(List<String> teamIds) {
    final standings = <String, dynamic>{};
    for (final teamId in teamIds) {
      standings[teamId] = {
        'rank': 0,
        'wins': 0,
        'losses': 0,
        'ties': 0,
        'winPercentage': 0.0,
        'gamesBack': 0.0,
        'gamesPlayed': 0,
        'runsScored': 0,
        'runsAllowed': 0,
        'runDifferential': 0,
        'homeRecord': '0-0',
        'awayRecord': '0-0',
        'lastTen': '0-0',
        'streak': 0,
        'battingAverage': 0.0,
        'earnedRunAverage': 0.0,
        'fieldingPercentage': 0.0,
        'stolenBases': 0,
        'caughtStealing': 0,
        'homeRuns': 0,
        'runsBattedIn': 0,
        'walks': 0,
        'strikeouts': 0,
        'hits': 0,
        'atBats': 0,
        'inningsPitched': 0.0,
        'hitsAllowed': 0,
        'walksAllowed': 0,
        'strikeoutsPitched': 0,
        'homeRunsAllowed': 0,
        'earnedRuns': 0,
        'saves': 0,
        'holds': 0,
        'blownSaves': 0,
        'qualityStarts': 0,
        'completeGames': 0,
        'shutouts': 0,
      };
    }
    return standings;
  }

  static Map<String, dynamic> _createInitialLeagueStats() {
    return {
      'totalGames': 0,
      'totalRuns': 0,
      'totalHomeRuns': 0,
      'totalStolenBases': 0,
      'totalStrikeouts': 0,
      'totalWalks': 0,
      'totalHits': 0,
      'totalAtBats': 0,
      'totalInningsPitched': 0.0,
      'totalHitsAllowed': 0,
      'totalWalksAllowed': 0,
      'totalStrikeoutsPitched': 0,
      'totalHomeRunsAllowed': 0,
      'totalEarnedRuns': 0,
      'totalSaves': 0,
      'totalHolds': 0,
      'totalBlownSaves': 0,
      'totalQualityStarts': 0,
      'totalCompleteGames': 0,
      'totalShutouts': 0,
      'leagueBattingAverage': 0.0,
      'leagueEarnedRunAverage': 0.0,
      'leagueFieldingPercentage': 0.0,
      'averageRunsPerGame': 0.0,
      'averageHomeRunsPerGame': 0.0,
      'averageStolenBasesPerGame': 0.0,
      'averageStrikeoutsPerGame': 0.0,
      'averageWalksPerGame': 0.0,
      'averageHitsPerGame': 0.0,
      'averageAtBatsPerGame': 0.0,
      'averageInningsPitchedPerGame': 0.0,
      'averageHitsAllowedPerGame': 0.0,
      'averageWalksAllowedPerGame': 0.0,
      'averageStrikeoutsPitchedPerGame': 0.0,
      'averageHomeRunsAllowedPerGame': 0.0,
      'averageEarnedRunsPerGame': 0.0,
      'averageSavesPerGame': 0.0,
      'averageHoldsPerGame': 0.0,
      'averageBlownSavesPerGame': 0.0,
      'averageQualityStartsPerGame': 0.0,
      'averageCompleteGamesPerGame': 0.0,
      'averageShutoutsPerGame': 0.0,
    };
  }

  LeagueStandings copyWith({
    String? id,
    String? pennantRaceId,
    LeagueType? league,
    int? year,
    List<String>? teamIds,
    Map<String, dynamic>? teamStandings,
    Map<String, dynamic>? leagueStats,
    DateTime? lastUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeagueStandings(
      id: id ?? this.id,
      pennantRaceId: pennantRaceId ?? this.pennantRaceId,
      league: league ?? this.league,
      year: year ?? this.year,
      teamIds: teamIds ?? this.teamIds,
      teamStandings: teamStandings ?? this.teamStandings,
      leagueStats: leagueStats ?? this.leagueStats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  LeagueStandings updateTeamStandings(String teamId, Map<String, dynamic> newStats) {
    final updatedStandings = Map<String, dynamic>.from(teamStandings);
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
    
    return copyWith(
      teamStandings: updatedStandings,
      lastUpdated: DateTime.now(),
    );
  }

  LeagueStandings updateLeagueStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(leagueStats);
    updatedStats.addAll(newStats);
    
    // リーグ全体の平均値を計算
    final totalGames = updatedStats['totalGames'] ?? 0;
    if (totalGames > 0) {
      updatedStats['averageRunsPerGame'] = (updatedStats['totalRuns'] ?? 0) / totalGames;
      updatedStats['averageHomeRunsPerGame'] = (updatedStats['totalHomeRuns'] ?? 0) / totalGames;
      updatedStats['averageStolenBasesPerGame'] = (updatedStats['totalStolenBases'] ?? 0) / totalGames;
      updatedStats['averageStrikeoutsPerGame'] = (updatedStats['totalStrikeouts'] ?? 0) / totalGames;
      updatedStats['averageWalksPerGame'] = (updatedStats['totalWalks'] ?? 0) / totalGames;
      updatedStats['averageHitsPerGame'] = (updatedStats['totalHits'] ?? 0) / totalGames;
      updatedStats['averageAtBatsPerGame'] = (updatedStats['totalAtBats'] ?? 0) / totalGames;
      updatedStats['averageInningsPitchedPerGame'] = (updatedStats['totalInningsPitched'] ?? 0.0) / totalGames;
      updatedStats['averageHitsAllowedPerGame'] = (updatedStats['totalHitsAllowed'] ?? 0) / totalGames;
      updatedStats['averageWalksAllowedPerGame'] = (updatedStats['totalWalksAllowed'] ?? 0) / totalGames;
      updatedStats['averageStrikeoutsPitchedPerGame'] = (updatedStats['totalStrikeoutsPitched'] ?? 0) / totalGames;
      updatedStats['averageHomeRunsAllowedPerGame'] = (updatedStats['totalHomeRunsAllowed'] ?? 0) / totalGames;
      updatedStats['averageEarnedRunsPerGame'] = (updatedStats['totalEarnedRuns'] ?? 0) / totalGames;
      updatedStats['averageSavesPerGame'] = (updatedStats['totalSaves'] ?? 0) / totalGames;
      updatedStats['averageHoldsPerGame'] = (updatedStats['totalHolds'] ?? 0) / totalGames;
      updatedStats['averageBlownSavesPerGame'] = (updatedStats['totalBlownSaves'] ?? 0) / totalGames;
      updatedStats['averageQualityStartsPerGame'] = (updatedStats['totalQualityStarts'] ?? 0) / totalGames;
      updatedStats['averageCompleteGamesPerGame'] = (updatedStats['totalCompleteGames'] ?? 0) / totalGames;
      updatedStats['averageShutoutsPerGame'] = (updatedStats['totalShutouts'] ?? 0) / totalGames;
    }
    
    // リーグ全体の打率を計算
    final totalAtBats = updatedStats['totalAtBats'] ?? 0;
    final totalHits = updatedStats['totalHits'] ?? 0;
    if (totalAtBats > 0) {
      updatedStats['leagueBattingAverage'] = totalHits / totalAtBats;
    }
    
    // リーグ全体の防御率を計算
    final totalInningsPitched = updatedStats['totalInningsPitched'] ?? 0.0;
    final totalEarnedRuns = updatedStats['totalEarnedRuns'] ?? 0;
    if (totalInningsPitched > 0) {
      updatedStats['leagueEarnedRunAverage'] = (totalEarnedRuns * 9) / totalInningsPitched;
    }
    
    return copyWith(
      leagueStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  LeagueStandings calculateRankings() {
    final updatedStandings = Map<String, dynamic>.from(teamStandings);
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
    
    // 順位とゲーム差を設定
    if (sortedTeams.isNotEmpty) {
      final leader = sortedTeams.first;
      final leaderWins = leader.value['wins'] ?? 0;
      final leaderLosses = leader.value['losses'] ?? 0;
      final leaderGames = leaderWins + leaderLosses;
      
      for (int i = 0; i < sortedTeams.length; i++) {
        final team = sortedTeams[i];
        final teamWins = team.value['wins'] ?? 0;
        final teamLosses = team.value['losses'] ?? 0;
        final teamGames = teamWins + teamLosses;
        
        // 順位を設定
        team.value['rank'] = i + 1;
        
        // ゲーム差を計算
        if (i > 0 && leaderGames > 0 && teamGames > 0) {
          final gamesBack = ((leaderWins - leaderLosses) - (teamWins - teamLosses)) / 2.0;
          team.value['gamesBack'] = gamesBack.abs();
        } else {
          team.value['gamesBack'] = 0.0;
        }
      }
    }
    
    // 更新された順位表を適用
    for (final entry in sortedTeams) {
      updatedStandings[entry.key] = entry.value;
    }
    
    return copyWith(
      teamStandings: updatedStandings,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pennantRaceId': pennantRaceId,
      'league': league.name,
      'year': year,
      'teamIds': teamIds,
      'teamStandings': teamStandings,
      'leagueStats': leagueStats,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory LeagueStandings.fromJson(Map<String, dynamic> json) {
    return LeagueStandings(
      id: json['id'] as String,
      pennantRaceId: json['pennantRaceId'] as String,
      league: LeagueType.values.firstWhere((e) => e.name == json['league']),
      year: json['year'] as int,
      teamIds: List<String>.from(json['teamIds']),
      teamStandings: Map<String, dynamic>.from(json['teamStandings']),
      leagueStats: Map<String, dynamic>.from(json['leagueStats']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeagueStandings && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LeagueStandings(id: $id, league: ${league.label}, year: $year)';
  }
}
