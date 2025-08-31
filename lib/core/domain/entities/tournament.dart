import 'package:flutter/foundation.dart';

/// 大会の種類
enum TournamentType {
  spring('春の大会'),
  summer('夏の大会'),
  fall('秋の大会');

  const TournamentType(this.displayName);
  final String displayName;
}

/// 大会の段階
enum TournamentStage {
  prefectural('県大会'),
  regional('地区大会'),
  national('全国大会');

  const TournamentStage(this.displayName);
  final String displayName;
}

/// 大会の状態
enum TournamentStatus {
  upcoming('開催予定'),
  inProgress('開催中'),
  completed('終了');

  const TournamentStatus(this.displayName);
  final String displayName;
}

/// 高校野球大会エンティティ
class Tournament {
  final String id;
  final String name;
  final TournamentType type;
  final TournamentStage stage;
  final TournamentStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> participatingSchoolIds;
  final List<String> matchIds;
  final String? winnerSchoolId;
  final Map<String, dynamic> statistics;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tournament({
    required this.id,
    required this.name,
    required this.type,
    required this.stage,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.participatingSchoolIds,
    required this.matchIds,
    this.winnerSchoolId,
    required this.statistics,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 初期大会の作成
  factory Tournament.initial({
    required String name,
    required TournamentType type,
    required TournamentStage stage,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> schoolIds,
  }) {
    final now = DateTime.now();
    return Tournament(
      id: 'tournament_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      name: name,
      type: type,
      stage: stage,
      status: TournamentStatus.upcoming,
      startDate: startDate,
      endDate: endDate,
      participatingSchoolIds: List.from(schoolIds),
      matchIds: [],
      winnerSchoolId: null,
      statistics: {
        'totalMatches': 0,
        'completedMatches': 0,
        'totalRuns': 0,
        'totalHits': 0,
        'totalErrors': 0,
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 大会開始
  Tournament start() {
    return copyWith(
      status: TournamentStatus.inProgress,
      updatedAt: DateTime.now(),
    );
  }

  /// 大会終了
  Tournament complete({required String winnerId}) {
    return copyWith(
      status: TournamentStatus.completed,
      winnerSchoolId: winnerId,
      updatedAt: DateTime.now(),
    );
  }

  /// 試合を追加
  Tournament addMatch(String matchId) {
    final newMatchIds = List<String>.from(matchIds)..add(matchId);
    return copyWith(
      matchIds: newMatchIds,
      statistics: {
        ...statistics,
        'totalMatches': newMatchIds.length,
      },
      updatedAt: DateTime.now(),
    );
  }

  /// 統計を更新
  Tournament updateStatistics(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(statistics);
    updatedStats.addAll(newStats);
    return copyWith(
      statistics: updatedStats,
      updatedAt: DateTime.now(),
    );
  }

  /// 参加校数を取得
  int get participantCount => participatingSchoolIds.length;

  /// 進行状況を取得
  double get progress {
    if (status == TournamentStatus.upcoming) return 0.0;
    if (status == TournamentStatus.completed) return 1.0;
    
    final totalDays = endDate.difference(startDate).inDays;
    final elapsedDays = DateTime.now().difference(startDate).inDays;
    return (elapsedDays / totalDays).clamp(0.0, 1.0);
  }

  /// 詳細情報を取得
  String get detailedInfo {
    return '''
大会詳細: $name
種類: ${type.displayName}
段階: ${stage.displayName}
状態: ${status.displayName}
開催期間: ${startDate.toString().substring(0, 10)} 〜 ${endDate.toString().substring(0, 10)}
参加校数: $participantCount校
試合数: ${matchIds.length}試合
進行状況: ${(progress * 100).toStringAsFixed(1)}%
優勝校: ${winnerSchoolId ?? '未決定'}
''';
  }

  Tournament copyWith({
    String? id,
    String? name,
    TournamentType? type,
    TournamentStage? stage,
    TournamentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? participatingSchoolIds,
    List<String>? matchIds,
    String? winnerSchoolId,
    Map<String, dynamic>? statistics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      participatingSchoolIds: participatingSchoolIds ?? this.participatingSchoolIds,
      matchIds: matchIds ?? this.matchIds,
      winnerSchoolId: winnerSchoolId ?? this.winnerSchoolId,
      statistics: statistics ?? this.statistics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'stage': stage.name,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participatingSchoolIds': participatingSchoolIds,
      'matchIds': matchIds,
      'winnerSchoolId': winnerSchoolId,
      'statistics': statistics,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      type: TournamentType.values.firstWhere((e) => e.name == json['type']),
      stage: TournamentStage.values.firstWhere((e) => e.name == json['stage']),
      status: TournamentStatus.values.firstWhere((e) => e.name == json['status']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      participatingSchoolIds: List<String>.from(json['participatingSchoolIds']),
      matchIds: List<String>.from(json['matchIds']),
      winnerSchoolId: json['winnerSchoolId'] as String?,
      statistics: Map<String, dynamic>.from(json['statistics']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tournament && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, type: ${type.displayName}, stage: ${stage.displayName})';
  }
}
