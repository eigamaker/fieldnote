enum AnalysisType {
  playerGrowth('選手成長'),
  talentAssessment('才能評価'),
  scoutingEffectiveness('スカウト効果'),
  performancePrediction('成績予測'),
  comparativeAnalysis('比較分析');

  const AnalysisType(this.label);
  final String label;
}

enum AnalysisPeriod {
  shortTerm('短期'),
  mediumTerm('中期'),
  longTerm('長期'),
  career('キャリア');

  const AnalysisPeriod(this.label);
  final String label;
}

class ScoutingAnalytics {
  final String id;
  final String playerId;
  final String playerName;
  final String scoutId;
  final String scoutName;
  final AnalysisType type;
  final AnalysisPeriod period;
  final DateTime analysisDate;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> growthMetrics;
  final Map<String, dynamic> talentScores;
  final Map<String, dynamic> scoutingMetrics;
  final Map<String, dynamic> predictionData;
  final Map<String, dynamic> comparativeData;
  final double confidenceLevel;
  final String analysisNotes;
  final DateTime lastUpdated;

  const ScoutingAnalytics({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.scoutId,
    required this.scoutName,
    required this.type,
    required this.period,
    required this.analysisDate,
    required this.startDate,
    required this.endDate,
    this.growthMetrics = const {},
    this.talentScores = const {},
    this.scoutingMetrics = const {},
    this.predictionData = const {},
    this.comparativeData = const {},
    this.confidenceLevel = 0.0,
    this.analysisNotes = '',
    required this.lastUpdated,
  });

  factory ScoutingAnalytics.initial({
    required String playerId,
    required String playerName,
    required String scoutId,
    required String scoutName,
    required AnalysisType type,
    required AnalysisPeriod period,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return ScoutingAnalytics(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playerId: playerId,
      playerName: playerName,
      scoutId: scoutId,
      scoutName: scoutName,
      type: type,
      period: period,
      startDate: startDate,
      endDate: endDate,
      analysisDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  ScoutingAnalytics copyWith({
    String? id,
    String? playerId,
    String? playerName,
    String? scoutId,
    String? scoutName,
    AnalysisType? type,
    AnalysisPeriod? period,
    DateTime? analysisDate,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? growthMetrics,
    Map<String, dynamic>? talentScores,
    Map<String, dynamic>? scoutingMetrics,
    Map<String, dynamic>? predictionData,
    Map<String, dynamic>? comparativeData,
    double? confidenceLevel,
    String? analysisNotes,
    DateTime? lastUpdated,
  }) {
    return ScoutingAnalytics(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      type: type ?? this.type,
      period: period ?? this.period,
      analysisDate: analysisDate ?? this.analysisDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      growthMetrics: growthMetrics ?? this.growthMetrics,
      talentScores: talentScores ?? this.talentScores,
      scoutingMetrics: scoutingMetrics ?? this.scoutingMetrics,
      predictionData: predictionData ?? this.predictionData,
      comparativeData: comparativeData ?? this.comparativeData,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      analysisNotes: analysisNotes ?? this.analysisNotes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // 成長指標の更新
  ScoutingAnalytics updateGrowthMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(growthMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      growthMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 才能スコアの更新
  ScoutingAnalytics updateTalentScores(Map<String, dynamic> newScores) {
    final updatedScores = Map<String, dynamic>.from(talentScores);
    updatedScores.addAll(newScores);
    
    return copyWith(
      talentScores: updatedScores,
      lastUpdated: DateTime.now(),
    );
  }

  // スカウト指標の更新
  ScoutingAnalytics updateScoutingMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(scoutingMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      scoutingMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 予測データの更新
  ScoutingAnalytics updatePredictionData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(predictionData);
    updatedData.addAll(newData);
    
    return copyWith(
      predictionData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // 比較データの更新
  ScoutingAnalytics updateComparativeData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(comparativeData);
    updatedData.addAll(newData);
    
    return copyWith(
      comparativeData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // 信頼度の更新
  ScoutingAnalytics updateConfidenceLevel(double newConfidence) {
    return copyWith(
      confidenceLevel: newConfidence.clamp(0.0, 1.0),
      lastUpdated: DateTime.now(),
    );
  }

  // 分析ノートの更新
  ScoutingAnalytics updateAnalysisNotes(String newNotes) {
    return copyWith(
      analysisNotes: newNotes,
      lastUpdated: DateTime.now(),
    );
  }

  // 成長率の計算
  double get growthRate {
    final initialValue = growthMetrics['initialValue'] as num? ?? 0;
    final currentValue = growthMetrics['currentValue'] as num? ?? 0;
    final timePeriod = endDate.difference(startDate).inDays;
    
    if (initialValue == 0 || timePeriod == 0) return 0.0;
    
    return ((currentValue - initialValue) / initialValue / timePeriod * 365).toDouble();
  }

  // 才能総合スコアの計算
  double get overallTalentScore {
    final scores = talentScores.values.whereType<num>().toList();
    if (scores.isEmpty) return 0.0;
    
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  // スカウト精度の計算
  double get scoutingAccuracy {
    final predictedValue = scoutingMetrics['predictedValue'] as num? ?? 0;
    final actualValue = scoutingMetrics['actualValue'] as num? ?? 0;
    
    if (predictedValue == 0) return 0.0;
    
    final accuracy = 1.0 - ((predictedValue - actualValue).abs() / predictedValue);
    return accuracy.clamp(0.0, 1.0);
  }

  // 予測信頼度の計算
  double get predictionConfidence {
    final predictionAccuracy = predictionData['accuracy'] as double? ?? 0.0;
    final dataQuality = predictionData['dataQuality'] as double? ?? 0.0;
    final sampleSize = predictionData['sampleSize'] as int? ?? 0;
    
    // サンプルサイズによる調整
    final sizeAdjustment = (sampleSize / 100).clamp(0.1, 1.0);
    
    return (predictionAccuracy * dataQuality * sizeAdjustment).clamp(0.0, 1.0);
  }

  // 比較優位性の計算
  double get comparativeAdvantage {
    final playerScore = comparativeData['playerScore'] as num? ?? 0;
    final averageScore = comparativeData['averageScore'] as num? ?? 0;
    final standardDeviation = comparativeData['standardDeviation'] as num? ?? 1;
    
    if (standardDeviation == 0) return 0.0;
    
    return ((playerScore - averageScore) / standardDeviation).toDouble();
  }

  // 分析の有効性判定
  bool get isAnalysisValid {
    return confidenceLevel >= 0.7 && 
           growthMetrics.isNotEmpty && 
           talentScores.isNotEmpty;
  }

  // 成長傾向の判定
  String get growthTrend {
    final rate = growthRate;
    if (rate > 0.1) return '急成長';
    if (rate > 0.05) return '成長';
    if (rate > 0.01) return '緩やかな成長';
    if (rate > -0.01) return '横ばい';
    if (rate > -0.05) return '緩やかな下降';
    return '下降';
  }

  // 才能レベルの判定
  String get talentLevel {
    final score = overallTalentScore;
    if (score >= 90) return 'S級';
    if (score >= 80) return 'A級';
    if (score >= 70) return 'B級';
    if (score >= 60) return 'C級';
    if (score >= 50) return 'D級';
    return 'E級';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'playerName': playerName,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'type': type.name,
      'period': period.name,
      'analysisDate': analysisDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'growthMetrics': growthMetrics,
      'talentScores': talentScores,
      'scoutingMetrics': scoutingMetrics,
      'predictionData': predictionData,
      'comparativeData': comparativeData,
      'confidenceLevel': confidenceLevel,
      'analysisNotes': analysisNotes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ScoutingAnalytics.fromJson(Map<String, dynamic> json) {
    return ScoutingAnalytics(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      type: AnalysisType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnalysisType.playerGrowth,
      ),
      period: AnalysisPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => AnalysisPeriod.mediumTerm,
      ),
      analysisDate: DateTime.parse(json['analysisDate'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      growthMetrics: Map<String, dynamic>.from(json['growthMetrics'] ?? {}),
      talentScores: Map<String, dynamic>.from(json['talentScores'] ?? {}),
      scoutingMetrics: Map<String, dynamic>.from(json['scoutingMetrics'] ?? {}),
      predictionData: Map<String, dynamic>.from(json['predictionData'] ?? {}),
      comparativeData: Map<String, dynamic>.from(json['comparativeData'] ?? {}),
      confidenceLevel: (json['confidenceLevel'] as num?)?.toDouble() ?? 0.0,
      analysisNotes: json['analysisNotes'] as String? ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoutingAnalytics && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScoutingAnalytics(id: $id, playerName: $playerName, type: ${type.label}, period: ${period.label})';
  }
}
