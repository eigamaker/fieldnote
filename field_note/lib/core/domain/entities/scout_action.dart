/// スカウトアクションを管理するエンティティクラス
class ScoutAction {
  final String id;
  final String schoolId;
  final String schoolName;
  final double scoutSkill;
  final DateTime executionDate;
  final List<String> discoveredPlayerIds;
  final bool isCompleted;

  const ScoutAction({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.scoutSkill,
    required this.executionDate,
    required this.discoveredPlayerIds,
    required this.isCompleted,
  });

  /// 発見した選手数を取得
  int get playerCount => discoveredPlayerIds.length;

  /// スカウトアクションの成功度を取得
  String get successLevel {
    if (playerCount == 0) return '失敗';
    if (playerCount == 1) return '成功';
    if (playerCount == 2) return '大成功';
    return '超大成功';
  }

  /// スカウトアクションの詳細情報を取得
  String get detailedInfo {
    return '''
スカウト対象校: $schoolName
実行日: ${executionDate.toString().substring(0, 10)}
使用スカウトスキル: ${scoutSkill.toStringAsFixed(1)}
発見選手数: ${playerCount}名
結果: $successLevel
''';
  }

  /// プロパティを更新したコピーを作成
  ScoutAction copyWith({
    String? id,
    String? schoolId,
    String? schoolName,
    double? scoutSkill,
    DateTime? executionDate,
    List<String>? discoveredPlayerIds,
    bool? isCompleted,
  }) {
    return ScoutAction(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      scoutSkill: scoutSkill ?? this.scoutSkill,
      executionDate: executionDate ?? this.executionDate,
      discoveredPlayerIds: discoveredPlayerIds ?? this.discoveredPlayerIds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// 発見した選手を追加
  ScoutAction addDiscoveredPlayer(String playerId) {
    if (!discoveredPlayerIds.contains(playerId)) {
      final newPlayerIds = List<String>.from(discoveredPlayerIds)..add(playerId);
      return copyWith(
        discoveredPlayerIds: newPlayerIds,
        isCompleted: true,
      );
    }
    return this;
  }

  /// スカウトアクションを完了
  ScoutAction complete() {
    return copyWith(isCompleted: true);
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'scoutSkill': scoutSkill,
      'executionDate': executionDate.toIso8601String(),
      'discoveredPlayerIds': discoveredPlayerIds,
      'isCompleted': isCompleted,
    };
  }

  /// JSON形式から復元
  factory ScoutAction.fromJson(Map<String, dynamic> json) {
    return ScoutAction(
      id: json['id'],
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      scoutSkill: json['scoutSkill']?.toDouble() ?? 0.0,
      executionDate: DateTime.parse(json['executionDate']),
      discoveredPlayerIds: List<String>.from(json['discoveredPlayerIds'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// 新しいスカウトアクションを作成
  factory ScoutAction.create({
    required String schoolId,
    required String schoolName,
    required double scoutSkill,
  }) {
    final now = DateTime.now();
    
    return ScoutAction(
      id: 'scout_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      schoolId: schoolId,
      schoolName: schoolName,
      scoutSkill: scoutSkill,
      executionDate: now,
      discoveredPlayerIds: [],
      isCompleted: false,
    );
  }
}
