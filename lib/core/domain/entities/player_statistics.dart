enum StatCategory {
  batting('打撃'),
  pitching('投球'),
  fielding('守備'),
  running('走塁'),
  overall('総合');

  const StatCategory(this.label);
  final String label;
}

enum StatPeriod {
  game('試合'),
  week('週'),
  month('月'),
  season('シーズン'),
  career('通算');

  const StatPeriod(this.label);
  final String label;
}

class PlayerStatistics {
  final String id;
  final String playerId;
  final String playerName;
  final String teamId;
  final String teamName;
  final StatCategory category;
  final StatPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> battingStats;
  final Map<String, dynamic> pitchingStats;
  final Map<String, dynamic> fieldingStats;
  final Map<String, dynamic> runningStats;
  final Map<String, dynamic> overallStats;
  final int gamesPlayed;
  final DateTime lastUpdated;

  const PlayerStatistics({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.teamName,
    required this.category,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.battingStats = const {},
    this.pitchingStats = const {},
    this.fieldingStats = const {},
    this.runningStats = const {},
    this.overallStats = const {},
    this.gamesPlayed = 0,
    required this.lastUpdated,
  });

  factory PlayerStatistics.initial({
    required String playerId,
    required String playerName,
    required String teamId,
    required String teamName,
    required StatCategory category,
    required StatPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return PlayerStatistics(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playerId: playerId,
      playerName: playerName,
      teamId: teamId,
      teamName: teamName,
      category: category,
      period: period,
      startDate: startDate,
      endDate: endDate,
      lastUpdated: DateTime.now(),
    );
  }

  PlayerStatistics copyWith({
    String? id,
    String? playerId,
    String? playerName,
    String? teamId,
    String? teamName,
    StatCategory? category,
    StatPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? battingStats,
    Map<String, dynamic>? pitchingStats,
    Map<String, dynamic>? fieldingStats,
    Map<String, dynamic>? runningStats,
    Map<String, dynamic>? overallStats,
    int? gamesPlayed,
    DateTime? lastUpdated,
  }) {
    return PlayerStatistics(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      category: category ?? this.category,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      battingStats: battingStats ?? this.battingStats,
      pitchingStats: pitchingStats ?? this.pitchingStats,
      fieldingStats: fieldingStats ?? this.fieldingStats,
      runningStats: runningStats ?? this.runningStats,
      overallStats: overallStats ?? this.overallStats,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // 打撃統計の更新
  PlayerStatistics updateBattingStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(battingStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      battingStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 投球統計の更新
  PlayerStatistics updatePitchingStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(pitchingStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      pitchingStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 守備統計の更新
  PlayerStatistics updateFieldingStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(fieldingStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      fieldingStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 走塁統計の更新
  PlayerStatistics updateRunningStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(runningStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      runningStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 総合統計の更新
  PlayerStatistics updateOverallStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(overallStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      overallStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 試合数の更新
  PlayerStatistics incrementGamesPlayed() {
    return copyWith(
      gamesPlayed: gamesPlayed + 1,
      lastUpdated: DateTime.now(),
    );
  }

  // 打率の計算
  double get battingAverage {
    final atBats = battingStats['atBats'] as int? ?? 0;
    final hits = battingStats['hits'] as int? ?? 0;
    
    if (atBats == 0) return 0.0;
    return (hits / atBats).toDouble();
  }

  // 防御率の計算
  double get earnedRunAverage {
    final innings = pitchingStats['innings'] as double? ?? 0.0;
    final earnedRuns = pitchingStats['earnedRuns'] as int? ?? 0;
    
    if (innings == 0.0) return 0.0;
    return (earnedRuns * 9 / innings).toDouble();
  }

  // 出塁率の計算
  double get onBasePercentage {
    final atBats = battingStats['atBats'] as int? ?? 0;
    final hits = battingStats['hits'] as int? ?? 0;
    final walks = battingStats['walks'] as int? ?? 0;
    final hitByPitch = battingStats['hitByPitch'] as int? ?? 0;
    final sacrificeFlies = battingStats['sacrificeFlies'] as int? ?? 0;
    
    final plateAppearances = atBats + walks + hitByPitch + sacrificeFlies;
    if (plateAppearances == 0) return 0.0;
    
    return ((hits + walks + hitByPitch) / plateAppearances).toDouble();
  }

  // 長打率の計算
  double get sluggingPercentage {
    final atBats = battingStats['atBats'] as int? ?? 0;
    final hits = battingStats['hits'] as int? ?? 0;
    final doubles = battingStats['doubles'] as int? ?? 0;
    final triples = battingStats['triples'] as int? ?? 0;
    final homeRuns = battingStats['homeRuns'] as int? ?? 0;
    
    if (atBats == 0) return 0.0;
    
    final totalBases = hits + doubles + (triples * 2) + (homeRuns * 3);
    return (totalBases / atBats).toDouble();
  }

  // OPSの計算
  double get onBasePlusSlugging {
    return onBasePercentage + sluggingPercentage;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'playerName': playerName,
      'teamId': teamId,
      'teamName': teamName,
      'category': category.name,
      'period': period.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'battingStats': battingStats,
      'pitchingStats': pitchingStats,
      'fieldingStats': fieldingStats,
      'runningStats': runningStats,
      'overallStats': overallStats,
      'gamesPlayed': gamesPlayed,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PlayerStatistics.fromJson(Map<String, dynamic> json) {
    return PlayerStatistics(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      category: StatCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => StatCategory.overall,
      ),
      period: StatPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => StatPeriod.season,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      battingStats: Map<String, dynamic>.from(json['battingStats'] ?? {}),
      pitchingStats: Map<String, dynamic>.from(json['pitchingStats'] ?? {}),
      fieldingStats: Map<String, dynamic>.from(json['fieldingStats'] ?? {}),
      runningStats: Map<String, dynamic>.from(json['runningStats'] ?? {}),
      overallStats: Map<String, dynamic>.from(json['overallStats'] ?? {}),
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerStatistics && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PlayerStatistics(id: $id, playerName: $playerName, category: ${category.label}, period: ${period.label})';
  }
}
