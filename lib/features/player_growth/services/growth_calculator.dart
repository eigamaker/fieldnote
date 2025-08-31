import 'dart:math';

/// 選手成長計算サービス
/// 練習効果、才能による成長率、週進行時の成長計算を提供
class GrowthCalculator {
  static final Random _random = Random();

  /// 練習効果の計算
  /// [practiceIntensity]: 練習強度（1-5）
  /// [talentLevel]: 才能レベル（0.5-2.0）
  /// [currentLevel]: 現在の能力レベル（1-100）
  /// [motivation]: モチベーション（0.8-1.2）
  static int calculatePracticeGrowth({
    required int practiceIntensity,
    required double talentLevel,
    required int currentLevel,
    double motivation = 1.0,
  }) {
    // 基本練習効果
    final baseGrowth = practiceIntensity * 2;
    
    // 才能ボーナス（才能レベルが高いほど効果大）
    final talentBonus = (talentLevel - 1.0) * baseGrowth * 0.5;
    
    // 現在レベルによる減衰（レベルが高いほど成長しにくい）
    final levelDecay = max(0.5, 1.0 - (currentLevel - 1) * 0.005);
    
    // モチベーション効果
    final motivationEffect = motivation.clamp(0.8, 1.2);
    
    // ランダム要素（±20%）
    final randomFactor = 0.8 + (_random.nextDouble() * 0.4);
    
    final totalGrowth = (baseGrowth + talentBonus) * levelDecay * motivationEffect * randomFactor;
    
    return totalGrowth.round().clamp(1, 15); // 最小1、最大15
  }

  /// 週進行時の成長計算
  /// [baseGrowthPoints]: 基本成長ポイント
  /// [talentLevel]: 才能レベル
  /// [age]: 年齢（15-18）
  /// [grade]: 学年（1-3）
  /// [schoolLevel]: 学校レベル（1-5）
  static int calculateWeeklyGrowth({
    required int baseGrowthPoints,
    required double talentLevel,
    required int age,
    required int grade,
    required int schoolLevel,
  }) {
    // 基本成長
    final baseGrowth = baseGrowthPoints;
    
    // 才能による成長率
    final talentGrowthRate = 1.0 + (talentLevel - 1.25) * 0.4;
    
    // 年齢による成長減衰（年齢が高いほど成長しにくい）
    final ageDecay = max(0.7, 1.0 - (age - 15) * 0.1);
    
    // 学年による成長ボーナス（学年が高いほど成長しやすい）
    final gradeBonus = 1.0 + (grade - 1) * 0.1;
    
    // 学校レベルによる成長ボーナス
    final schoolBonus = 1.0 + (schoolLevel - 1) * 0.05;
    
    // ランダム要素（±15%）
    final randomFactor = 0.85 + (_random.nextDouble() * 0.3);
    
    final totalGrowth = baseGrowth * talentGrowthRate * ageDecay * gradeBonus * schoolBonus * randomFactor;
    
    return totalGrowth.round().clamp(1, 10); // 最小1、最大10
  }

  /// 才能レベルの評価
  /// [talentLevel]: 才能レベル
  static String evaluateTalentLevel(double talentLevel) {
    if (talentLevel >= 1.8) return '天才';
    if (talentLevel >= 1.5) return '優秀';
    if (talentLevel >= 1.2) return '良好';
    if (talentLevel >= 0.8) return '普通';
    return '平凡';
  }

  /// 成長率の評価
  /// [growthRate]: 成長率
  static String evaluateGrowthRate(double growthRate) {
    if (growthRate >= 1.3) return '非常に高い';
    if (growthRate >= 1.1) return '高い';
    if (growthRate >= 0.9) return '普通';
    return '低い';
  }

  /// 練習強度の推奨
  /// [talentLevel]: 才能レベル
  /// [currentLevel]: 現在の能力レベル
  /// [motivation]: モチベーション
  static int getRecommendedPracticeIntensity({
    required double talentLevel,
    required int currentLevel,
    double motivation = 1.0,
  }) {
    // 才能レベルが高いほど強度を上げる
    final talentBasedIntensity = (talentLevel * 2.5).round().clamp(1, 5);
    
    // 現在レベルが高いほど強度を下げる（疲労防止）
    final levelBasedIntensity = max(1, 5 - (currentLevel ~/ 20));
    
    // モチベーションによる調整
    final motivationBasedIntensity = (motivation * 2.5).round().clamp(1, 5);
    
    // 平均を取って推奨強度を決定
    final recommendedIntensity = ((talentBasedIntensity + levelBasedIntensity + motivationBasedIntensity) / 3).round();
    
    return recommendedIntensity.clamp(1, 5);
  }

  /// 成長予測の計算
  /// [currentLevel]: 現在の能力レベル
  /// [talentLevel]: 才能レベル
  /// [practiceFrequency]: 週間練習回数
  /// [weeks]: 予測週数
  static Map<String, dynamic> predictGrowth({
    required int currentLevel,
    required double talentLevel,
    required int practiceFrequency,
    required int weeks,
  }) {
    // 週進行による成長
    final weeklyGrowth = weeks * 3; // 基本週成長3ポイント
    
    // 練習による成長
    final practiceGrowth = weeks * practiceFrequency * 4; // 基本練習成長4ポイント
    
    // 才能による成長率
    final talentGrowthRate = 1.0 + (talentLevel - 1.25) * 0.4;
    
    // 現在レベルによる減衰
    final levelDecay = max(0.5, 1.0 - (currentLevel - 1) * 0.005);
    
    // 総予測成長
    final totalPredictedGrowth = (weeklyGrowth + practiceGrowth) * talentGrowthRate * levelDecay;
    
    // 予測最終レベル
    final predictedFinalLevel = min(100, currentLevel + totalPredictedGrowth.round());
    
    // 成長可能性
    final growthPotential = predictedFinalLevel - currentLevel;
    
    return {
      'currentLevel': currentLevel,
      'predictedFinalLevel': predictedFinalLevel,
      'totalPredictedGrowth': totalPredictedGrowth.round(),
      'growthPotential': growthPotential,
      'weeklyGrowth': weeklyGrowth,
      'practiceGrowth': practiceGrowth,
      'talentEffect': talentGrowthRate,
      'levelDecay': levelDecay,
    };
  }

  /// 練習効率の計算
  /// [growthPoints]: 獲得成長ポイント
  /// [practiceIntensity]: 練習強度
  /// [timeSpent]: 練習時間（分）
  static double calculatePracticeEfficiency({
    required int growthPoints,
    required int practiceIntensity,
    required int timeSpent,
  }) {
    if (timeSpent <= 0) return 0.0;
    
    // 時間あたりの成長ポイント
    final growthPerMinute = growthPoints / timeSpent;
    
    // 強度あたりの効率
    final intensityEfficiency = growthPerMinute / practiceIntensity;
    
    // 効率評価（0.0-1.0）
    return (intensityEfficiency / 0.1).clamp(0.0, 1.0); // 0.1を基準として正規化
  }

  /// 成長イベントの重要度評価
  /// [growthPoints]: 成長ポイント
  /// [eventType]: イベントタイプ
  static String evaluateGrowthEventImportance(int growthPoints, String eventType) {
    if (eventType == 'practice') {
      if (growthPoints >= 10) return '重要';
      if (growthPoints >= 6) return '中程度';
      return '軽微';
    } else if (eventType == 'weekly') {
      if (growthPoints >= 8) return '重要';
      if (growthPoints >= 4) return '中程度';
      return '軽微';
    }
    return '不明';
  }
}
