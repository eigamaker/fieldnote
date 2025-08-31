enum TeamStatType {
  offensive('攻撃'),
  defensive('守備'),
  pitching('投球'),
  overall('総合'),
  situational('状況別');

  const TeamStatType(this.label);
  final String label;
}

enum LeagueType {
  highSchool('高校'),
  professional('プロ'),
  amateur('アマチュア');

  const LeagueType(this.label);
  final String label;
}

class TeamStatistics {
  final String id;
  final String teamId;
  final String teamName;
  final LeagueType leagueType;
  final int season;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> offensiveStats;
  final Map<String, dynamic> defensiveStats;
  final Map<String, dynamic> pitchingStats;
  final Map<String, dynamic> overallStats;
  final Map<String, dynamic> situationalStats;
  final Map<String, dynamic> playerContributions;
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int ties;
  final DateTime lastUpdated;

  const TeamStatistics({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.leagueType,
    required this.season,
    required this.startDate,
    required this.endDate,
    this.offensiveStats = const {},
    this.defensiveStats = const {},
    this.pitchingStats = const {},
    this.overallStats = const {},
    this.situationalStats = const {},
    this.playerContributions = const {},
    this.gamesPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.ties = 0,
    required this.lastUpdated,
  });

  factory TeamStatistics.initial({
    required String teamId,
    required String teamName,
    required LeagueType leagueType,
    required int season,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return TeamStatistics(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      teamId: teamId,
      teamName: teamName,
      leagueType: leagueType,
      season: season,
      startDate: startDate,
      endDate: endDate,
      lastUpdated: DateTime.now(),
    );
  }

  TeamStatistics copyWith({
    String? id,
    String? teamId,
    String? teamName,
    LeagueType? leagueType,
    int? season,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? offensiveStats,
    Map<String, dynamic>? defensiveStats,
    Map<String, dynamic>? pitchingStats,
    Map<String, dynamic>? overallStats,
    Map<String, dynamic>? situationalStats,
    Map<String, dynamic>? playerContributions,
    int? gamesPlayed,
    int? wins,
    int? losses,
    int? ties,
    DateTime? lastUpdated,
  }) {
    return TeamStatistics(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      leagueType: leagueType ?? this.leagueType,
      season: season ?? this.season,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      offensiveStats: offensiveStats ?? this.offensiveStats,
      defensiveStats: defensiveStats ?? this.defensiveStats,
      pitchingStats: pitchingStats ?? this.pitchingStats,
      overallStats: overallStats ?? this.overallStats,
      situationalStats: situationalStats ?? this.situationalStats,
      playerContributions: playerContributions ?? this.playerContributions,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      ties: ties ?? this.ties,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // 攻撃統計の更新
  TeamStatistics updateOffensiveStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(offensiveStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      offensiveStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 守備統計の更新
  TeamStatistics updateDefensiveStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(defensiveStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      defensiveStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 投球統計の更新
  TeamStatistics updatePitchingStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(pitchingStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      pitchingStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 総合統計の更新
  TeamStatistics updateOverallStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(overallStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      overallStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 状況別統計の更新
  TeamStatistics updateSituationalStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(situationalStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      situationalStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 選手貢献度の更新
  TeamStatistics updatePlayerContribution(String playerId, Map<String, dynamic> contribution) {
    final updatedContributions = Map<String, dynamic>.from(playerContributions);
    updatedContributions[playerId] = contribution;
    
    return copyWith(
      playerContributions: updatedContributions,
      lastUpdated: DateTime.now(),
    );
  }

  // 試合結果の更新
  TeamStatistics updateGameResult(bool isWin, bool isTie) {
    int newWins = wins;
    int newLosses = losses;
    int newTies = ties;
    
    if (isTie) {
      newTies++;
    } else if (isWin) {
      newWins++;
    } else {
      newLosses++;
    }
    
    return copyWith(
      wins: newWins,
      losses: newLosses,
      ties: newTies,
      gamesPlayed: gamesPlayed + 1,
      lastUpdated: DateTime.now(),
    );
  }

  // 勝率の計算
  double get winningPercentage {
    if (gamesPlayed == 0) return 0.0;
    return (wins / gamesPlayed).toDouble();
  }

  // チーム打率の計算
  double get teamBattingAverage {
    final atBats = offensiveStats['atBats'] as int? ?? 0;
    final hits = offensiveStats['hits'] as int? ?? 0;
    
    if (atBats == 0) return 0.0;
    return (hits / atBats).toDouble();
  }

  // チーム防御率の計算
  double get teamEarnedRunAverage {
    final innings = pitchingStats['innings'] as double? ?? 0.0;
    final earnedRuns = pitchingStats['earnedRuns'] as int? ?? 0;
    
    if (innings == 0.0) return 0.0;
    return (earnedRuns * 9 / innings).toDouble();
  }

  // チーム出塁率の計算
  double get teamOnBasePercentage {
    final atBats = offensiveStats['atBats'] as int? ?? 0;
    final hits = offensiveStats['hits'] as int? ?? 0;
    final walks = offensiveStats['walks'] as int? ?? 0;
    final hitByPitch = offensiveStats['hitByPitch'] as int? ?? 0;
    final sacrificeFlies = offensiveStats['sacrificeFlies'] as int? ?? 0;
    
    final plateAppearances = atBats + walks + hitByPitch + sacrificeFlies;
    if (plateAppearances == 0) return 0.0;
    
    return ((hits + walks + hitByPitch) / plateAppearances).toDouble();
  }

  // チーム長打率の計算
  double get teamSluggingPercentage {
    final atBats = offensiveStats['atBats'] as int? ?? 0;
    final hits = offensiveStats['hits'] as int? ?? 0;
    final doubles = offensiveStats['doubles'] as int? ?? 0;
    final triples = offensiveStats['triples'] as int? ?? 0;
    final homeRuns = offensiveStats['homeRuns'] as int? ?? 0;
    
    if (atBats == 0) return 0.0;
    
    final totalBases = hits + doubles + (triples * 2) + (homeRuns * 3);
    return (totalBases / atBats).toDouble();
  }

  // チームOPSの計算
  double get teamOnBasePlusSlugging {
    return teamOnBasePercentage + teamSluggingPercentage;
  }

  // 守備率の計算
  double get fieldingPercentage {
    final putouts = defensiveStats['putouts'] as int? ?? 0;
    final assists = defensiveStats['assists'] as int? ?? 0;
    final errors = defensiveStats['errors'] as int? ?? 0;
    
    final totalChances = putouts + assists + errors;
    if (totalChances == 0) return 0.0;
    
    return ((putouts + assists) / totalChances).toDouble();
  }

  // 得点効率の計算
  double get runEfficiency {
    final runsScored = offensiveStats['runsScored'] as int? ?? 0;
    final runsAllowed = defensiveStats['runsAllowed'] as int? ?? 0;
    
    if (runsAllowed == 0) return 0.0;
    return (runsScored / runsAllowed).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamId': teamId,
      'teamName': teamName,
      'leagueType': leagueType.name,
      'season': season,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'offensiveStats': offensiveStats,
      'defensiveStats': defensiveStats,
      'pitchingStats': pitchingStats,
      'overallStats': overallStats,
      'situationalStats': situationalStats,
      'playerContributions': playerContributions,
      'gamesPlayed': gamesPlayed,
      'wins': wins,
      'losses': losses,
      'ties': ties,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory TeamStatistics.fromJson(Map<String, dynamic> json) {
    return TeamStatistics(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      leagueType: LeagueType.values.firstWhere(
        (e) => e.name == json['leagueType'],
        orElse: () => LeagueType.highSchool,
      ),
      season: json['season'] as int? ?? 2024,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      offensiveStats: Map<String, dynamic>.from(json['offensiveStats'] ?? {}),
      defensiveStats: Map<String, dynamic>.from(json['defensiveStats'] ?? {}),
      pitchingStats: Map<String, dynamic>.from(json['pitchingStats'] ?? {}),
      overallStats: Map<String, dynamic>.from(json['overallStats'] ?? {}),
      situationalStats: Map<String, dynamic>.from(json['situationalStats'] ?? {}),
      playerContributions: Map<String, dynamic>.from(json['playerContributions'] ?? {}),
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      ties: json['ties'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamStatistics && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TeamStatistics(id: $id, teamName: $teamName, season: $season, wins: $wins, losses: $losses)';
  }
}
