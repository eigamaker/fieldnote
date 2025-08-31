/// 試合の状態
enum MatchStatus {
  scheduled('予定'),
  inProgress('試合中'),
  completed('終了'),
  cancelled('中止');

  const MatchStatus(this.displayName);
  final String displayName;
}

/// 選手の活躍度
enum PlayerPerformance {
  excellent('優秀'),
  good('良好'),
  average('普通'),
  poor('不振'),
  terrible('最悪');

  const PlayerPerformance(this.displayName);
  final String displayName;
}

/// 試合結果エンティティ
class GameMatch {
  final String id;
  final String tournamentId;
  final String homeSchoolId;
  final String awaySchoolId;
  final DateTime scheduledDate;
  final MatchStatus status;
  final int? homeScore;
  final int? awayScore;
  final int? innings;
  final Map<String, dynamic> homeTeamStats;
  final Map<String, dynamic> awayTeamStats;
  final List<String> homePlayerIds;
  final List<String> awayPlayerIds;
  final Map<String, PlayerPerformance> playerPerformances;
  final String? winnerSchoolId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GameMatch({
    required this.id,
    required this.tournamentId,
    required this.homeSchoolId,
    required this.awaySchoolId,
    required this.scheduledDate,
    required this.status,
    this.homeScore,
    this.awayScore,
    this.innings,
    required this.homeTeamStats,
    required this.awayTeamStats,
    required this.homePlayerIds,
    required this.awayPlayerIds,
    required this.playerPerformances,
    this.winnerSchoolId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 初期試合の作成
  factory GameMatch.initial({
    required String tournamentId,
    required String homeSchoolId,
    required String awaySchoolId,
    required DateTime scheduledDate,
    required List<String> homePlayers,
    required List<String> awayPlayers,
  }) {
    final now = DateTime.now();
    return GameMatch(
      id: 'match_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      tournamentId: tournamentId,
      homeSchoolId: homeSchoolId,
      awaySchoolId: awaySchoolId,
      scheduledDate: scheduledDate,
      status: MatchStatus.scheduled,
      homeScore: null,
      awayScore: null,
      innings: null,
      homeTeamStats: {
        'hits': 0,
        'errors': 0,
        'walks': 0,
        'strikeouts': 0,
        'runs': 0,
      },
      awayTeamStats: {
        'hits': 0,
        'errors': 0,
        'walks': 0,
        'strikeouts': 0,
        'runs': 0,
      },
      homePlayerIds: List.from(homePlayers),
      awayPlayerIds: List.from(awayPlayers),
      playerPerformances: {},
      winnerSchoolId: null,
      notes: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 試合開始
  GameMatch start() {
    return copyWith(
      status: MatchStatus.inProgress,
      updatedAt: DateTime.now(),
    );
  }

  /// 試合終了
  GameMatch complete({
    required int homeScore,
    required int awayScore,
    required int innings,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required Map<String, PlayerPerformance> performances,
    String? notes,
  }) {
    final winnerId = homeScore > awayScore ? homeSchoolId : awaySchoolId;
    return copyWith(
      status: MatchStatus.completed,
      homeScore: homeScore,
      awayScore: awayScore,
      innings: innings,
      homeTeamStats: homeStats,
      awayTeamStats: awayStats,
      playerPerformances: performances,
      winnerSchoolId: winnerId,
      notes: notes,
      updatedAt: DateTime.now(),
    );
  }

  /// 試合中止
  GameMatch cancel({required String reason}) {
    return copyWith(
      status: MatchStatus.cancelled,
      notes: '中止理由: $reason',
      updatedAt: DateTime.now(),
    );
  }

  /// 選手の活躍度を設定
  GameMatch setPlayerPerformance(String playerId, PlayerPerformance performance) {
    final newPerformances = Map<String, PlayerPerformance>.from(playerPerformances);
    newPerformances[playerId] = performance;
    return copyWith(
      playerPerformances: newPerformances,
      updatedAt: DateTime.now(),
    );
  }

  /// 試合結果の要約を取得
  String get resultSummary {
    if (status != MatchStatus.completed) {
      return '${status.displayName}';
    }
    
    final winner = winnerSchoolId == homeSchoolId ? 'ホーム' : 'アウェイ';
    return '${homeScore}-${awayScore} (${innings}回) - $winner勝利';
  }

  /// 詳細情報を取得
  String get detailedInfo {
    return '''
試合詳細: $id
大会ID: $tournamentId
ホーム校: $homeSchoolId
アウェイ校: $awaySchoolId
予定日: ${scheduledDate.toString().substring(0, 10)}
状態: ${status.displayName}
結果: $resultSummary
ホーム校統計: $homeTeamStats
アウェイ校統計: $awayTeamStats
選手数: ホーム${homePlayerIds.length}名, アウェイ${awayPlayerIds.length}名
''';
  }

  /// 試合が終了しているかチェック
  bool get isCompleted => status == MatchStatus.completed;

  /// 試合が進行中かチェック
  bool get isInProgress => status == MatchStatus.inProgress;

  /// 試合が予定されているかチェック
  bool get isScheduled => status == MatchStatus.scheduled;

  GameMatch copyWith({
    String? id,
    String? tournamentId,
    String? homeSchoolId,
    String? awaySchoolId,
    DateTime? scheduledDate,
    MatchStatus? status,
    int? homeScore,
    int? awayScore,
    int? innings,
    Map<String, dynamic>? homeTeamStats,
    Map<String, dynamic>? awayTeamStats,
    List<String>? homePlayerIds,
    List<String>? awayPlayerIds,
    Map<String, PlayerPerformance>? playerPerformances,
    String? winnerSchoolId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameMatch(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      homeSchoolId: homeSchoolId ?? this.homeSchoolId,
      awaySchoolId: awaySchoolId ?? this.awaySchoolId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      innings: innings ?? this.innings,
      homeTeamStats: homeTeamStats ?? this.homeTeamStats,
      awayTeamStats: awayTeamStats ?? this.awayTeamStats,
      homePlayerIds: homePlayerIds ?? this.homePlayerIds,
      awayPlayerIds: awayPlayerIds ?? this.awayPlayerIds,
      playerPerformances: playerPerformances ?? this.playerPerformances,
      winnerSchoolId: winnerSchoolId ?? this.winnerSchoolId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'homeSchoolId': homeSchoolId,
      'awaySchoolId': awaySchoolId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'status': status.name,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'innings': innings,
      'homeTeamStats': homeTeamStats,
      'awayTeamStats': awayTeamStats,
      'homePlayerIds': homePlayerIds,
      'awayPlayerIds': awayPlayerIds,
      'playerPerformances': playerPerformances.map((key, value) => MapEntry(key, value.name)),
      'winnerSchoolId': winnerSchoolId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GameMatch.fromJson(Map<String, dynamic> json) {
    return GameMatch(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      homeSchoolId: json['homeSchoolId'] as String,
      awaySchoolId: json['awaySchoolId'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      status: MatchStatus.values.firstWhere((e) => e.name == json['status']),
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      innings: json['innings'] as int?,
      homeTeamStats: Map<String, dynamic>.from(json['homeTeamStats']),
      awayTeamStats: Map<String, dynamic>.from(json['awayTeamStats']),
      homePlayerIds: List<String>.from(json['homePlayerIds']),
      awayPlayerIds: List<String>.from(json['awayPlayerIds']),
      playerPerformances: (json['playerPerformances'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, PlayerPerformance.values.firstWhere((e) => e.name == value)),
      ),
      winnerSchoolId: json['winnerSchoolId'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameMatch && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GameMatch(id: $id, home: $homeSchoolId, away: $awaySchoolId, status: ${status.displayName})';
  }
}
