import 'dart:math' show sqrt;

enum ReputationLevel {
  unknown('無名'),
  novice('初心者'),
  established('確立'),
  respected('尊敬'),
  renowned('著名'),
  legendary('伝説');

  const ReputationLevel(this.label);
  final String label;
}

enum ReputationCategory {
  playerEvaluation('選手評価'),
  informationAccuracy('情報精度'),
  networkInfluence('ネットワーク影響力'),
  ethicalConduct('倫理的行動'),
  overallReputation('総合評価');

  const ReputationCategory(this.label);
  final String label;
}

class ScoutReputation {
  final String id;
  final String scoutId;
  final String scoutName;
  final ReputationLevel overallLevel;
  final Map<ReputationCategory, double> categoryScores;
  final Map<ReputationCategory, int> categoryRatings;
  final int totalRatings;
  final double overallScore;
  final List<String> achievements;
  final List<String> endorsements;
  final Map<String, dynamic> reputationHistory;
  final DateTime lastUpdated;
  final bool isVerified;
  final String verificationNotes;

  const ScoutReputation({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.overallLevel,
    required this.categoryScores,
    required this.categoryRatings,
    required this.totalRatings,
    required this.overallScore,
    this.achievements = const [],
    this.endorsements = const [],
    this.reputationHistory = const {},
    required this.lastUpdated,
    this.isVerified = false,
    this.verificationNotes = '',
  });

  factory ScoutReputation.initial({
    required String scoutId,
    required String scoutName,
  }) {
    final initialScores = <ReputationCategory, double>{};
    final initialRatings = <ReputationCategory, int>{};
    
    for (final category in ReputationCategory.values) {
      initialScores[category] = 50.0;
      initialRatings[category] = 0;
    }
    
    return ScoutReputation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      overallLevel: ReputationLevel.unknown,
      categoryScores: initialScores,
      categoryRatings: initialRatings,
      totalRatings: 0,
      overallScore: 50.0,
      lastUpdated: DateTime.now(),
    );
  }

  ScoutReputation copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    ReputationLevel? overallLevel,
    Map<ReputationCategory, double>? categoryScores,
    Map<ReputationCategory, int>? categoryRatings,
    int? totalRatings,
    double? overallScore,
    List<String>? achievements,
    List<String>? endorsements,
    Map<String, dynamic>? reputationHistory,
    DateTime? lastUpdated,
    bool? isVerified,
    String? verificationNotes,
  }) {
    return ScoutReputation(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      overallLevel: overallLevel ?? this.overallLevel,
      categoryScores: categoryScores ?? this.categoryScores,
      categoryRatings: categoryRatings ?? this.categoryRatings,
      totalRatings: totalRatings ?? this.totalRatings,
      overallScore: overallScore ?? this.overallScore,
      achievements: achievements ?? this.achievements,
      endorsements: endorsements ?? this.endorsements,
      reputationHistory: reputationHistory ?? this.reputationHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isVerified: isVerified ?? this.isVerified,
      verificationNotes: verificationNotes ?? this.verificationNotes,
    );
  }

  // カテゴリスコアの更新
  ScoutReputation updateCategoryScore(ReputationCategory category, double newScore) {
    final updatedScores = Map<ReputationCategory, double>.from(categoryScores);
    updatedScores[category] = newScore.clamp(0.0, 100.0);
    
    return copyWith(
      categoryScores: updatedScores,
      lastUpdated: DateTime.now(),
    );
  }

  // カテゴリ評価の追加
  ScoutReputation addCategoryRating(ReputationCategory category, int rating) {
    final updatedRatings = Map<ReputationCategory, int>.from(categoryRatings);
    final currentRating = updatedRatings[category] ?? 0;
    updatedRatings[category] = currentRating + 1;
    
    // スコアの再計算
    final currentScore = categoryScores[category] ?? 50.0;
    final newScore = ((currentScore * currentRating) + rating) / (currentRating + 1);
    
    final updatedScores = Map<ReputationCategory, double>.from(categoryScores);
    updatedScores[category] = newScore.clamp(0.0, 100.0);
    
    return copyWith(
      categoryScores: updatedScores,
      categoryRatings: updatedRatings,
      totalRatings: totalRatings + 1,
      lastUpdated: DateTime.now(),
    );
  }

  // 総合スコアの更新
  ScoutReputation updateOverallScore() {
    double totalScore = 0.0;
    int validCategories = 0;
    
    for (final category in ReputationCategory.values) {
      final score = categoryScores[category];
      if (score != null && score > 0) {
        totalScore += score;
        validCategories++;
      }
    }
    
    final newOverallScore = validCategories > 0 ? totalScore / validCategories : 0.0;
    final newOverallLevel = _calculateReputationLevel(newOverallScore);
    
    return copyWith(
      overallScore: newOverallScore,
      overallLevel: newOverallLevel,
      lastUpdated: DateTime.now(),
    );
  }

  // 実績の追加
  ScoutReputation addAchievement(String achievement) {
    final updatedAchievements = List<String>.from(achievements);
    if (!updatedAchievements.contains(achievement)) {
      updatedAchievements.add(achievement);
    }
    
    return copyWith(
      achievements: updatedAchievements,
      lastUpdated: DateTime.now(),
    );
  }

  // 推薦の追加
  ScoutReputation addEndorsement(String endorsement) {
    final updatedEndorsements = List<String>.from(endorsements);
    if (!updatedEndorsements.contains(endorsement)) {
      updatedEndorsements.add(endorsement);
    }
    
    return copyWith(
      endorsements: updatedEndorsements,
      lastUpdated: DateTime.now(),
    );
  }

  // 履歴の更新
  ScoutReputation updateReputationHistory(String key, dynamic value) {
    final updatedHistory = Map<String, dynamic>.from(reputationHistory);
    updatedHistory[key] = value;
    
    return copyWith(
      reputationHistory: updatedHistory,
      lastUpdated: DateTime.now(),
    );
  }

  // 検証状態の更新
  ScoutReputation setVerificationStatus(bool verified, String notes) {
    return copyWith(
      isVerified: verified,
      verificationNotes: notes,
      lastUpdated: DateTime.now(),
    );
  }

  // 信頼性スコアの計算
  double get credibilityScore {
    double baseScore = overallScore;
    
    // 検証済みボーナス
    if (isVerified) baseScore += 10;
    
    // 評価数による調整
    if (totalRatings >= 100) baseScore += 5;
    else if (totalRatings >= 50) baseScore += 3;
    else if (totalRatings >= 20) baseScore += 1;
    
    // 実績による調整
    baseScore += (achievements.length * 2).clamp(0, 20);
    
    return baseScore.clamp(0.0, 100.0);
  }

  // 影響力スコアの計算
  double get influenceScore {
    double baseScore = 0.0;
    
    // ネットワーク影響力
    final networkScore = categoryScores[ReputationCategory.networkInfluence] ?? 0.0;
    baseScore += networkScore * 0.3;
    
    // 総合評価
    baseScore += overallScore * 0.4;
    
    // 推薦数による調整
    baseScore += (endorsements.length * 3).clamp(0, 30);
    
    return baseScore.clamp(0.0, 100.0);
  }

  // 専門性スコアの計算
  double get expertiseScore {
    double baseScore = 0.0;
    
    // 選手評価
    final playerScore = categoryScores[ReputationCategory.playerEvaluation] ?? 0.0;
    baseScore += playerScore * 0.4;
    
    // 情報精度
    final accuracyScore = categoryScores[ReputationCategory.informationAccuracy] ?? 0.0;
    baseScore += accuracyScore * 0.4;
    
    // 実績による調整
    baseScore += (achievements.length * 2).clamp(0, 20);
    
    return baseScore.clamp(0.0, 100.0);
  }

  // 成長率の計算
  double get growthRate {
    final history = reputationHistory['scoreHistory'] as List<dynamic>?;
    if (history == null || history.length < 2) return 0.0;
    
    final recentScores = history.take(5).map((e) => e as double).toList();
    if (recentScores.length < 2) return 0.0;
    
    final firstScore = recentScores.first;
    final lastScore = recentScores.last;
    final timeSpan = recentScores.length;
    
    if (firstScore == 0) return 0.0;
    return ((lastScore - firstScore) / firstScore / timeSpan * 100).toDouble();
  }

  // 評価の一貫性計算
  double get consistencyScore {
    final scores = categoryScores.values.toList();
    if (scores.length < 2) return 100.0;
    
    final mean = scores.reduce((a, b) => a + b) / scores.length;
    final variance = scores.map((score) => (score - mean) * (score - mean)).reduce((a, b) => a + b) / scores.length;
    final standardDeviation = sqrt(variance);
    
    // 標準偏差が小さいほど一貫性が高い
    return (100 - (standardDeviation * 2)).clamp(0.0, 100.0);
  }

  // レピュテーションレベルの計算
  ReputationLevel _calculateReputationLevel(double score) {
    if (score >= 90) return ReputationLevel.legendary;
    if (score >= 80) return ReputationLevel.renowned;
    if (score >= 70) return ReputationLevel.respected;
    if (score >= 60) return ReputationLevel.established;
    if (score >= 40) return ReputationLevel.novice;
    return ReputationLevel.unknown;
  }

  // カテゴリ別評価の取得
  double getCategoryScore(ReputationCategory category) {
    return categoryScores[category] ?? 0.0;
  }

  // カテゴリ別評価数の取得
  int getCategoryRatingCount(ReputationCategory category) {
    return categoryRatings[category] ?? 0;
  }

  // 評価の信頼性判定
  bool get isRatingReliable {
    return totalRatings >= 10 && isVerified;
  }

  // レピュテーションの有効性判定
  bool get isReputationValid {
    return overallScore > 0 && lastUpdated.isAfter(DateTime.now().subtract(Duration(days: 365)));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'overallLevel': overallLevel.name,
      'categoryScores': categoryScores.map((key, value) => MapEntry(key.name, value)),
      'categoryRatings': categoryRatings.map((key, value) => MapEntry(key.name, value)),
      'totalRatings': totalRatings,
      'overallScore': overallScore,
      'achievements': achievements,
      'endorsements': endorsements,
      'reputationHistory': reputationHistory,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isVerified': isVerified,
      'verificationNotes': verificationNotes,
    };
  }

  factory ScoutReputation.fromJson(Map<String, dynamic> json) {
    final categoryScores = <ReputationCategory, double>{};
    final categoryRatings = <ReputationCategory, int>{};
    
    final scoresMap = json['categoryScores'] as Map<String, dynamic>? ?? {};
    final ratingsMap = json['categoryRatings'] as Map<String, dynamic>? ?? {};
    
    for (final category in ReputationCategory.values) {
      categoryScores[category] = (scoresMap[category.name] as num?)?.toDouble() ?? 50.0;
      categoryRatings[category] = ratingsMap[category.name] as int? ?? 0;
    }
    
    return ScoutReputation(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      overallLevel: ReputationLevel.values.firstWhere(
        (e) => e.name == json['overallLevel'],
        orElse: () => ReputationLevel.unknown,
      ),
      categoryScores: categoryScores,
      categoryRatings: categoryRatings,
      totalRatings: json['totalRatings'] as int? ?? 0,
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 50.0,
      achievements: List<String>.from(json['achievements'] ?? []),
      endorsements: List<String>.from(json['endorsements'] ?? []),
      reputationHistory: Map<String, dynamic>.from(json['reputationHistory'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      verificationNotes: json['verificationNotes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoutReputation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScoutReputation(id: $id, scoutName: $scoutName, level: ${overallLevel.label}, score: ${overallScore.toStringAsFixed(1)})';
  }
}
