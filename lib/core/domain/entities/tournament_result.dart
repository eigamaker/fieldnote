/// 大会結果のエンティティ
class TournamentResult {
  final String id;
  final String tournamentId;
  final String tournamentName;
  final DateTime tournamentDate;
  final List<String> participatingSchoolIds;
  final List<String> matchResults;
  final String winnerSchoolId;
  final String runnerUpSchoolId;
  final Map<String, dynamic> tournamentStats;
  final Map<String, dynamic> schoolResults;
  final Map<String, dynamic> playerHighlights;
  final List<String> notableEvents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TournamentResult({
    required this.id,
    required this.tournamentId,
    required this.tournamentName,
    required this.tournamentDate,
    required this.participatingSchoolIds,
    required this.matchResults,
    required this.winnerSchoolId,
    required this.runnerUpSchoolId,
    required this.tournamentStats,
    required this.schoolResults,
    required this.playerHighlights,
    required this.notableEvents,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 初期大会結果の作成
  factory TournamentResult.initial({
    required String tournamentId,
    required String tournamentName,
    required DateTime tournamentDate,
    required List<String> schoolIds,
  }) {
    final now = DateTime.now();
    return TournamentResult(
      id: 'result_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      tournamentId: tournamentId,
      tournamentName: tournamentName,
      tournamentDate: tournamentDate,
      participatingSchoolIds: List.from(schoolIds),
      matchResults: [],
      winnerSchoolId: '',
      runnerUpSchoolId: '',
      tournamentStats: {
        'totalMatches': 0,
        'totalRuns': 0,
        'totalHits': 0,
        'totalErrors': 0,
        'averageScore': 0.0,
        'closestMatch': null,
        'highestScoringMatch': null,
      },
      schoolResults: {},
      playerHighlights: {},
      notableEvents: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 試合結果を追加
  TournamentResult addMatchResult(String matchId) {
    final newResults = List<String>.from(matchResults)..add(matchId);
    return copyWith(
      matchResults: newResults,
      updatedAt: DateTime.now(),
    );
  }

  /// 優勝校と準優勝校を設定
  TournamentResult setWinners({
    required String winnerId,
    required String runnerUpId,
  }) {
    return copyWith(
      winnerSchoolId: winnerId,
      runnerUpSchoolId: runnerUpId,
      updatedAt: DateTime.now(),
    );
  }

  /// 大会統計を更新
  TournamentResult updateTournamentStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(tournamentStats);
    updatedStats.addAll(newStats);
    return copyWith(
      tournamentStats: updatedStats,
      updatedAt: DateTime.now(),
    );
  }

  /// 学校別結果を設定
  TournamentResult setSchoolResult(String schoolId, Map<String, dynamic> result) {
    final newSchoolResults = Map<String, dynamic>.from(schoolResults);
    newSchoolResults[schoolId] = result;
    return copyWith(
      schoolResults: newSchoolResults,
      updatedAt: DateTime.now(),
    );
  }

  /// 選手の活躍を記録
  TournamentResult addPlayerHighlight(String playerId, Map<String, dynamic> highlight) {
    final newHighlights = Map<String, dynamic>.from(playerHighlights);
    newHighlights[playerId] = highlight;
    return copyWith(
      playerHighlights: newHighlights,
      updatedAt: DateTime.now(),
    );
  }

  /// 注目イベントを追加
  TournamentResult addNotableEvent(String event) {
    final newEvents = List<String>.from(notableEvents)..add(event);
    return copyWith(
      notableEvents: newEvents,
      updatedAt: DateTime.now(),
    );
  }

  /// 参加校数を取得
  int get participantCount => participatingSchoolIds.length;

  /// 試合数を取得
  int get matchCount => matchResults.length;

  /// 大会結果の要約を取得
  String get resultSummary {
    if (winnerSchoolId.isEmpty) {
      return '結果未確定';
    }
    return '優勝: $winnerSchoolId, 準優勝: $runnerUpSchoolId';
  }

  /// 詳細情報を取得
  String get detailedInfo {
    return '''
大会結果詳細: $tournamentName
開催日: ${tournamentDate.toString().substring(0, 10)}
参加校数: $participantCount校
試合数: $matchCount試合
結果: $resultSummary
総得点: ${tournamentStats['totalRuns'] ?? 0}点
総安打: ${tournamentStats['totalHits'] ?? 0}本
総失策: ${tournamentStats['totalErrors'] ?? 0}回
注目イベント数: ${notableEvents.length}件
''';
  }

  /// 学校の結果を取得
  Map<String, dynamic>? getSchoolResult(String schoolId) {
    return schoolResults[schoolId];
  }

  /// 選手の活躍を取得
  Map<String, dynamic>? getPlayerHighlight(String playerId) {
    return playerHighlights[playerId];
  }

  /// 統計の平均値を計算
  double get averageScore {
    final totalRuns = tournamentStats['totalRuns'] ?? 0;
    final matchCount = this.matchCount;
    if (matchCount == 0) return 0.0;
    return totalRuns / matchCount;
  }

  TournamentResult copyWith({
    String? id,
    String? tournamentId,
    String? tournamentName,
    DateTime? tournamentDate,
    List<String>? participatingSchoolIds,
    List<String>? matchResults,
    String? winnerSchoolId,
    String? runnerUpSchoolId,
    Map<String, dynamic>? tournamentStats,
    Map<String, dynamic>? schoolResults,
    Map<String, dynamic>? playerHighlights,
    List<String>? notableEvents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TournamentResult(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      tournamentName: tournamentName ?? this.tournamentName,
      tournamentDate: tournamentDate ?? this.tournamentDate,
      participatingSchoolIds: participatingSchoolIds ?? this.participatingSchoolIds,
      matchResults: matchResults ?? this.matchResults,
      winnerSchoolId: winnerSchoolId ?? this.winnerSchoolId,
      runnerUpSchoolId: runnerUpSchoolId ?? this.runnerUpSchoolId,
      tournamentStats: tournamentStats ?? this.tournamentStats,
      schoolResults: schoolResults ?? this.schoolResults,
      playerHighlights: playerHighlights ?? this.playerHighlights,
      notableEvents: notableEvents ?? this.notableEvents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'tournamentName': tournamentName,
      'tournamentDate': tournamentDate.toIso8601String(),
      'participatingSchoolIds': participatingSchoolIds,
      'matchResults': matchResults,
      'winnerSchoolId': winnerSchoolId,
      'runnerUpSchoolId': runnerUpSchoolId,
      'tournamentStats': tournamentStats,
      'schoolResults': schoolResults,
      'playerHighlights': playerHighlights,
      'notableEvents': notableEvents,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TournamentResult.fromJson(Map<String, dynamic> json) {
    return TournamentResult(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      tournamentName: json['tournamentName'] as String,
      tournamentDate: DateTime.parse(json['tournamentDate'] as String),
      participatingSchoolIds: List<String>.from(json['participatingSchoolIds']),
      matchResults: List<String>.from(json['matchResults']),
      winnerSchoolId: json['winnerSchoolId'] as String,
      runnerUpSchoolId: json['runnerUpSchoolId'] as String,
      tournamentStats: Map<String, dynamic>.from(json['tournamentStats']),
      schoolResults: Map<String, dynamic>.from(json['schoolResults']),
      playerHighlights: Map<String, dynamic>.from(json['playerHighlights']),
      notableEvents: List<String>.from(json['notableEvents']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TournamentResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TournamentResult(id: $id, tournament: $tournamentName, winner: $winnerSchoolId)';
  }
}
