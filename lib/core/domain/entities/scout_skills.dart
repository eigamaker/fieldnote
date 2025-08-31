import 'dart:convert';

/// スカウトスキルエンティティ
/// 6つの基本スキルとそのレベル、経験値を管理
class ScoutSkills {
  final String id;
  final String scoutId;
  
  // 基本スキル（各1-100レベル）
  final int exploration;      // 探索力
  final int observation;      // 観察力
  final int analysis;         // 分析力
  final int insight;          // 洞察力
  final int negotiation;      // 交渉力
  final int stamina;          // スタミナ
  
  // 経験値システム
  final int totalExperience;  // 総経験値
  final int availableSkillPoints; // 使用可能なスキルポイント
  
  // メタデータ
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScoutSkills({
    required this.id,
    required this.scoutId,
    required this.exploration,
    required this.observation,
    required this.analysis,
    required this.insight,
    required this.negotiation,
    required this.stamina,
    required this.totalExperience,
    required this.availableSkillPoints,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 初期スキル（全スキル1レベル、スキルポイント10）
  factory ScoutSkills.initial({required String scoutId}) {
    final now = DateTime.now();
    return ScoutSkills(
      id: 'skills_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      scoutId: scoutId,
      exploration: 1,
      observation: 1,
      analysis: 1,
      insight: 1,
      negotiation: 1,
      stamina: 1,
      totalExperience: 0,
      availableSkillPoints: 10,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// スキルの合計レベル
  int get totalSkillLevel => exploration + observation + analysis + insight + negotiation + stamina;

  /// 平均スキルレベル
  double get averageSkillLevel => totalSkillLevel / 6.0;

  /// スカウト成功率の計算（スキルレベルに基づく）
  double get scoutingSuccessRate {
    final baseRate = 0.3; // 基本成功率30%
    final skillBonus = (averageSkillLevel - 1) * 0.005; // スキル1レベルにつき0.5%向上
    return (baseRate + skillBonus).clamp(0.1, 0.95); // 10%〜95%の範囲
  }

  /// 発見選手の品質向上率
  double get playerQualityBonus {
    final baseBonus = 0.0;
    final skillBonus = (averageSkillLevel - 1) * 0.02; // スキル1レベルにつき2%向上
    return (baseBonus + skillBonus).clamp(0.0, 0.5); // 0%〜50%の範囲
  }

  /// 特定スキルのレベルを取得
  int getSkillLevel(String skillName) {
    switch (skillName.toLowerCase()) {
      case 'exploration':
        return exploration;
      case 'observation':
        return observation;
      case 'analysis':
        return analysis;
      case 'insight':
        return insight;
      case 'negotiation':
        return negotiation;
      case 'stamina':
        return stamina;
      default:
        return 0;
    }
  }

  /// スキルレベルアップ（スキルポイント使用）
  ScoutSkills levelUpSkill(String skillName) {
    if (availableSkillPoints <= 0) return this;
    
    final currentLevel = getSkillLevel(skillName);
    if (currentLevel >= 100) return this; // 最大レベル
    
    final newSkills = _updateSkillLevel(skillName, currentLevel + 1);
    return copyWith(
      availableSkillPoints: availableSkillPoints - 1,
      updatedAt: DateTime.now(),
    );
  }

  /// 経験値獲得
  ScoutSkills gainExperience(int experience) {
    final newTotalExperience = totalExperience + experience;
    final newSkillPoints = availableSkillPoints + _calculateSkillPointsFromExperience(experience);
    
    return copyWith(
      totalExperience: newTotalExperience,
      availableSkillPoints: newSkillPoints,
      updatedAt: DateTime.now(),
    );
  }

  /// スキルポイント計算（経験値100につき1ポイント）
  int _calculateSkillPointsFromExperience(int experience) {
    return experience ~/ 100;
  }

  /// スキルレベル更新のヘルパーメソッド
  ScoutSkills _updateSkillLevel(String skillName, int newLevel) {
    switch (skillName.toLowerCase()) {
      case 'exploration':
        return copyWith(exploration: newLevel);
      case 'observation':
        return copyWith(observation: newLevel);
      case 'analysis':
        return copyWith(analysis: newLevel);
      case 'insight':
        return copyWith(insight: newLevel);
      case 'negotiation':
        return copyWith(negotiation: newLevel);
      case 'stamina':
        return copyWith(stamina: newLevel);
      default:
        return this;
    }
  }

  /// スキル詳細情報
  String get detailedInfo {
    return '''
スカウトスキル詳細:
探索力: $exploration/100
観察力: $observation/100
分析力: $analysis/100
洞察力: $insight/100
交渉力: $negotiation/100
スタミナ: $stamina/100

総スキルレベル: $totalSkillLevel
平均スキルレベル: ${averageSkillLevel.toStringAsFixed(1)}
スカウト成功率: ${(scoutingSuccessRate * 100).toStringAsFixed(1)}%
選手品質向上率: ${(playerQualityBonus * 100).toStringAsFixed(1)}%

総経験値: $totalExperience
使用可能スキルポイント: $availableSkillPoints
''';
  }

  /// スキルサマリー
  String get summary {
    return 'Lv.${averageSkillLevel.toStringAsFixed(1)} (${totalSkillLevel}pt)';
  }

  ScoutSkills copyWith({
    String? id,
    String? scoutId,
    int? exploration,
    int? observation,
    int? analysis,
    int? insight,
    int? negotiation,
    int? stamina,
    int? totalExperience,
    int? availableSkillPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScoutSkills(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      exploration: exploration ?? this.exploration,
      observation: observation ?? this.observation,
      analysis: analysis ?? this.analysis,
      insight: insight ?? this.insight,
      negotiation: negotiation ?? this.negotiation,
      stamina: stamina ?? this.stamina,
      totalExperience: totalExperience ?? this.totalExperience,
      availableSkillPoints: availableSkillPoints ?? this.availableSkillPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'exploration': exploration,
      'observation': observation,
      'analysis': analysis,
      'insight': insight,
      'negotiation': negotiation,
      'stamina': stamina,
      'totalExperience': totalExperience,
      'availableSkillPoints': availableSkillPoints,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ScoutSkills.fromJson(Map<String, dynamic> json) {
    return ScoutSkills(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      exploration: json['exploration'] as int,
      observation: json['observation'] as int,
      analysis: json['analysis'] as int,
      insight: json['insight'] as int,
      negotiation: json['negotiation'] as int,
      stamina: json['stamina'] as int,
      totalExperience: json['totalExperience'] as int,
      availableSkillPoints: json['availableSkillPoints'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
