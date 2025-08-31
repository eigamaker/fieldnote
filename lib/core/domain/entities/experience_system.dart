import 'dart:convert';

/// 経験値システムエンティティ
/// スカウトの経験値獲得、レベルアップ、スキルポイント付与を管理
class ExperienceSystem {
  final String id;
  final String scoutId;
  final String scoutName;
  
  // 経験値パラメータ
  final int currentLevel;         // 現在のレベル
  final int currentExperience;    // 現在の経験値
  final int experienceToNextLevel; // 次のレベルまでの必要経験値
  final int totalExperience;      // 総獲得経験値
  
  // スキルポイント
  final int availableSkillPoints; // 使用可能なスキルポイント
  final int totalSkillPointsEarned; // 総獲得スキルポイント
  
  // メタデータ
  final DateTime createdAt;
  final DateTime lastExperienceGain;

  const ExperienceSystem({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.currentLevel,
    required this.currentExperience,
    required this.experienceToNextLevel,
    required this.totalExperience,
    required this.availableSkillPoints,
    required this.totalSkillPointsEarned,
    required this.createdAt,
    required this.lastExperienceGain,
  });

  /// 初期経験値データ
  factory ExperienceSystem.initial({
    required String scoutId,
    required String scoutName,
  }) {
    final now = DateTime.now();
    return ExperienceSystem(
      id: 'exp_${now.millisecondsSinceEpoch}_${now.millisecondsSinceEpoch % 10000}',
      scoutId: scoutId,
      scoutName: scoutName,
      currentLevel: 1,
      currentExperience: 0,
      experienceToNextLevel: _calculateExperienceForLevel(2),
      totalExperience: 0,
      availableSkillPoints: 10,
      totalSkillPointsEarned: 10,
      createdAt: now,
      lastExperienceGain: now,
    );
  }

  /// 経験値獲得処理
  ExperienceSystem gainExperience(int experience) {
    final newCurrentExperience = currentExperience + experience;
    final newTotalExperience = totalExperience + experience;
    
    // レベルアップチェック
    if (newCurrentExperience >= experienceToNextLevel) {
      return _processLevelUp(newCurrentExperience, newTotalExperience);
    }
    
    return copyWith(
      currentExperience: newCurrentExperience,
      totalExperience: newTotalExperience,
      lastExperienceGain: DateTime.now(),
    );
  }

  /// レベルアップ処理
  ExperienceSystem _processLevelUp(int newCurrentExperience, int newTotalExperience) {
    final newLevel = currentLevel + 1;
    final remainingExperience = newCurrentExperience - experienceToNextLevel;
    final newExperienceToNextLevel = _calculateExperienceForLevel(newLevel + 1);
    final skillPointsGained = _calculateSkillPointsForLevel(newLevel);
    
    return copyWith(
      currentLevel: newLevel,
      currentExperience: remainingExperience,
      experienceToNextLevel: newExperienceToNextLevel,
      totalExperience: newTotalExperience,
      availableSkillPoints: availableSkillPoints + skillPointsGained,
      totalSkillPointsEarned: totalSkillPointsEarned + skillPointsGained,
      lastExperienceGain: DateTime.now(),
    );
  }

  /// レベルに応じた必要経験値計算
  static int _calculateExperienceForLevel(int level) {
    // レベル2: 100, レベル3: 250, レベル4: 450, レベル5: 700...
    // 基本式: 50 * level * (level - 1)
    return 50 * level * (level - 1);
  }

  /// レベルアップ時のスキルポイント計算
  static int _calculateSkillPointsForLevel(int level) {
    // レベル2: 2pt, レベル3: 3pt, レベル4: 4pt...
    return level;
  }

  /// スカウト成功時の経験値計算
  static int calculateScoutingExperience({
    required int discoveredPlayerCount,
    required double playerQuality,
    required int schoolLevel,
  }) {
    // 基本経験値: 発見選手数 × 10
    final baseExperience = discoveredPlayerCount * 10;
    
    // 選手品質ボーナス: 品質0.5-1.0の範囲で0-20ポイント
    final qualityBonus = (playerQuality - 0.5) * 40;
    
    // 学校レベルボーナス: レベル1-5の範囲で0-10ポイント
    final schoolBonus = (schoolLevel - 1) * 2.5;
    
    final totalExperience = (baseExperience + qualityBonus + schoolBonus).round();
    return totalExperience.clamp(5, 100); // 最小5、最大100
  }

  /// レベル進行度（0.0-1.0）
  double get levelProgress {
    if (experienceToNextLevel == 0) return 1.0;
    return currentExperience / experienceToNextLevel;
  }

  /// レベル進行度のパーセンテージ
  String get levelProgressText {
    return '${(levelProgress * 100).toStringAsFixed(1)}%';
  }

  /// 次のレベルまでの残り経験値
  int get remainingExperience => experienceToNextLevel - currentExperience;

  /// 経験値詳細情報
  String get detailedInfo {
    return '''
経験値システム詳細: $scoutName
現在レベル: $currentLevel
現在経験値: $currentExperience / $experienceToNextLevel
レベル進行度: $levelProgressText
次のレベルまで: ${remainingExperience}exp

総獲得経験値: $totalExperience
使用可能スキルポイント: $availableSkillPoints
総獲得スキルポイント: $totalSkillPointsEarned

最終経験値獲得: ${lastExperienceGain.toString().substring(0, 10)}
''';
  }

  /// 経験値サマリー
  String get summary {
    return 'Lv.$currentLevel (${levelProgressText})';
  }

  ExperienceSystem copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    int? currentLevel,
    int? currentExperience,
    int? experienceToNextLevel,
    int? totalExperience,
    int? availableSkillPoints,
    int? totalSkillPointsEarned,
    DateTime? createdAt,
    DateTime? lastExperienceGain,
  }) {
    return ExperienceSystem(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      currentLevel: currentLevel ?? this.currentLevel,
      currentExperience: currentExperience ?? this.currentExperience,
      experienceToNextLevel: experienceToNextLevel ?? this.experienceToNextLevel,
      totalExperience: totalExperience ?? this.totalExperience,
      availableSkillPoints: availableSkillPoints ?? this.availableSkillPoints,
      totalSkillPointsEarned: totalSkillPointsEarned ?? this.totalSkillPointsEarned,
      createdAt: createdAt ?? this.createdAt,
      lastExperienceGain: lastExperienceGain ?? this.lastExperienceGain,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'currentLevel': currentLevel,
      'currentExperience': currentExperience,
      'experienceToNextLevel': experienceToNextLevel,
      'totalExperience': totalExperience,
      'availableSkillPoints': availableSkillPoints,
      'totalSkillPointsEarned': totalSkillPointsEarned,
      'createdAt': createdAt.toIso8601String(),
      'lastExperienceGain': lastExperienceGain.toIso8601String(),
    };
  }

  factory ExperienceSystem.fromJson(Map<String, dynamic> json) {
    return ExperienceSystem(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      currentLevel: json['currentLevel'] as int,
      currentExperience: json['currentExperience'] as int,
      experienceToNextLevel: json['experienceToNextLevel'] as int,
      totalExperience: json['totalExperience'] as int,
      availableSkillPoints: json['availableSkillPoints'] as int,
      totalSkillPointsEarned: json['totalSkillPointsEarned'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastExperienceGain: DateTime.parse(json['lastExperienceGain'] as String),
    );
  }
}
