import 'dart:convert';

/// 選手成長エンティティ
/// 選手の成長履歴、練習効果、才能による成長率の個体差を管理
class PlayerGrowth {
  final String id;
  final String playerId;
  final String playerName;
  
  // 成長パラメータ
  final double talentLevel;        // 才能レベル（0.5-2.0）
  final double growthRate;         // 成長率（才能レベルに基づく）
  final int practiceCount;         // 練習回数
  final int totalGrowthPoints;     // 総成長ポイント
  
  // 成長履歴
  final List<GrowthEvent> growthHistory;
  
  // メタデータ
  final DateTime createdAt;
  final DateTime lastGrowthDate;

  const PlayerGrowth({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.talentLevel,
    required this.growthRate,
    required this.practiceCount,
    required this.totalGrowthPoints,
    required this.growthHistory,
    required this.createdAt,
    required this.lastGrowthDate,
  });

  /// 初期成長データ
  factory PlayerGrowth.initial({
    required String playerId,
    required String playerName,
  }) {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // 才能レベルを0.5-2.0の範囲でランダム生成
    final talentLevel = 0.5 + (random % 150) / 100.0;
    
    // 成長率は才能レベルに基づく（基本1.0、才能による変動±0.5）
    final growthRate = 1.0 + (talentLevel - 1.25) * 0.4;
    
    return PlayerGrowth(
      id: 'growth_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      playerId: playerId,
      playerName: playerName,
      talentLevel: talentLevel,
      growthRate: growthRate.clamp(0.5, 1.5),
      practiceCount: 0,
      totalGrowthPoints: 0,
      growthHistory: [],
      createdAt: now,
      lastGrowthDate: now,
    );
  }

  /// 練習による成長処理
  PlayerGrowth processPractice({
    required int practiceIntensity, // 練習強度（1-5）
    required DateTime practiceDate,
  }) {
    // 練習効果の計算
    final baseGrowth = practiceIntensity * 2; // 基本成長ポイント
    final talentBonus = (talentLevel - 1.0) * baseGrowth * 0.5; // 才能ボーナス
    final growthPoints = (baseGrowth + talentBonus).round();
    
    // 成長イベントの記録
    final growthEvent = GrowthEvent(
      id: 'event_${practiceDate.millisecondsSinceEpoch}_${practiceDate.millisecondsSinceEpoch % 10000}',
      eventType: 'practice',
      description: '練習による成長',
      growthPoints: growthPoints,
      practiceIntensity: practiceIntensity,
      date: practiceDate,
    );
    
    final newHistory = List<GrowthEvent>.from(growthHistory)..add(growthEvent);
    
    return copyWith(
      practiceCount: practiceCount + 1,
      totalGrowthPoints: totalGrowthPoints + growthPoints,
      growthHistory: newHistory,
      lastGrowthDate: practiceDate,
    );
  }

  /// 週進行時の自動成長処理
  PlayerGrowth processWeeklyGrowth({
    required DateTime weekDate,
    required int baseGrowthPoints,
  }) {
    // 週進行による基本成長
    final weeklyGrowth = (baseGrowthPoints * growthRate).round();
    
    // 成長イベントの記録
    final growthEvent = GrowthEvent(
      id: 'event_${weekDate.millisecondsSinceEpoch}_${weekDate.millisecondsSinceEpoch % 10000}',
      eventType: 'weekly',
      description: '週進行による成長',
      growthPoints: weeklyGrowth,
      practiceIntensity: null,
      date: weekDate,
    );
    
    final newHistory = List<GrowthEvent>.from(growthHistory)..add(growthEvent);
    
    return copyWith(
      totalGrowthPoints: totalGrowthPoints + weeklyGrowth,
      growthHistory: newHistory,
      lastGrowthDate: weekDate,
    );
  }

  /// 才能レベルのテキスト表現
  String get talentLevelText {
    if (talentLevel >= 1.8) return '天才';
    if (talentLevel >= 1.5) return '優秀';
    if (talentLevel >= 1.2) return '良好';
    if (talentLevel >= 0.8) return '普通';
    return '平凡';
  }

  /// 成長率のテキスト表現
  String get growthRateText {
    if (growthRate >= 1.3) return '非常に高い';
    if (growthRate >= 1.1) return '高い';
    if (growthRate >= 0.9) return '普通';
    return '低い';
  }

  /// 最近の成長傾向
  String get recentGrowthTrend {
    if (growthHistory.isEmpty) return '成長データなし';
    
    final recentEvents = growthHistory.take(3).toList();
    final totalRecentGrowth = recentEvents.fold<int>(0, (sum, event) => sum + event.growthPoints);
    final averageRecentGrowth = totalRecentGrowth / recentEvents.length;
    
    if (averageRecentGrowth >= 8) return '急成長中';
    if (averageRecentGrowth >= 5) return '順調に成長';
    if (averageRecentGrowth >= 3) return '緩やかに成長';
    return '成長停滞';
  }

  /// 成長詳細情報
  String get detailedInfo {
    return '''
選手成長詳細: $playerName
才能レベル: $talentLevelText (${talentLevel.toStringAsFixed(2)})
成長率: $growthRateText (${growthRate.toStringAsFixed(2)})
練習回数: $practiceCount回
総成長ポイント: ${totalGrowthPoints}pt

最近の成長傾向: $recentGrowthTrend
最終成長日: ${lastGrowthDate.toString().substring(0, 10)}
''';
  }

  /// 成長サマリー
  String get summary {
    return '${talentLevelText} (${growthRate.toStringAsFixed(1)}x)';
  }

  PlayerGrowth copyWith({
    String? id,
    String? playerId,
    String? playerName,
    double? talentLevel,
    double? growthRate,
    int? practiceCount,
    int? totalGrowthPoints,
    List<GrowthEvent>? growthHistory,
    DateTime? createdAt,
    DateTime? lastGrowthDate,
  }) {
    return PlayerGrowth(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      talentLevel: talentLevel ?? this.talentLevel,
      growthRate: growthRate ?? this.growthRate,
      practiceCount: practiceCount ?? this.practiceCount,
      totalGrowthPoints: totalGrowthPoints ?? this.totalGrowthPoints,
      growthHistory: growthHistory ?? this.growthHistory,
      createdAt: createdAt ?? this.createdAt,
      lastGrowthDate: lastGrowthDate ?? this.lastGrowthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'playerName': playerName,
      'talentLevel': talentLevel,
      'growthRate': growthRate,
      'practiceCount': practiceCount,
      'totalGrowthPoints': totalGrowthPoints,
      'growthHistory': growthHistory.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastGrowthDate': lastGrowthDate.toIso8601String(),
    };
  }

  factory PlayerGrowth.fromJson(Map<String, dynamic> json) {
    return PlayerGrowth(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      talentLevel: json['talentLevel'] as double,
      growthRate: json['growthRate'] as double,
      practiceCount: json['practiceCount'] as int,
      totalGrowthPoints: json['totalGrowthPoints'] as int,
      growthHistory: (json['growthHistory'] as List)
          .map((e) => GrowthEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastGrowthDate: DateTime.parse(json['lastGrowthDate'] as String),
    );
  }
}

/// 成長イベントエンティティ
class GrowthEvent {
  final String id;
  final String eventType;      // 'practice' または 'weekly'
  final String description;    // イベントの説明
  final int growthPoints;      // 獲得成長ポイント
  final int? practiceIntensity; // 練習強度（練習イベントのみ）
  final DateTime date;         // イベント発生日

  const GrowthEvent({
    required this.id,
    required this.eventType,
    required this.description,
    required this.growthPoints,
    this.practiceIntensity,
    required this.date,
  });

  /// イベント詳細情報
  String get eventInfo {
    final dateStr = date.toString().substring(0, 10);
    if (eventType == 'practice' && practiceIntensity != null) {
      return '$dateStr: $description (強度$practiceIntensity, +${growthPoints}pt)';
    }
    return '$dateStr: $description (+${growthPoints}pt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'description': description,
      'growthPoints': growthPoints,
      'practiceIntensity': practiceIntensity,
      'date': date.toIso8601String(),
    };
  }

  factory GrowthEvent.fromJson(Map<String, dynamic> json) {
    return GrowthEvent(
      id: json['id'] as String,
      eventType: json['eventType'] as String,
      description: json['description'] as String,
      growthPoints: json['growthPoints'] as int,
      practiceIntensity: json['practiceIntensity'] as int?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
