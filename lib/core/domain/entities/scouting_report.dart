enum ReportStatus {
  draft('下書き'),
  inProgress('作成中'),
  completed('完了'),
  reviewed('レビュー済み'),
  archived('アーカイブ');

  const ReportStatus(this.label);
  final String label;
}

enum ReportConfidence {
  low('低'),
  medium('中'),
  high('高'),
  veryHigh('非常に高い');

  const ReportConfidence(this.label);
  final String label;
}

class ScoutingReport {
  final String id;
  final String title;
  final String playerId;
  final String playerName;
  final String scoutId;
  final String scoutName;
  final DateTime scoutingDate;
  final DateTime reportDate;
  final ReportStatus status;
  final ReportConfidence confidence;
  final String executiveSummary;
  final String detailedAnalysis;
  final Map<String, dynamic> playerAttributes;
  final Map<String, dynamic> performanceData;
  final Map<String, dynamic> scoutingMetrics;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final Map<String, dynamic> comparisonData;
  final Map<String, dynamic> projectionData;
  final List<String> tags;
  final Map<String, dynamic> attachments;
  final String notes;
  final DateTime lastUpdated;
  final bool isPublic;
  final List<String> sharedWithScoutIds;

  const ScoutingReport({
    required this.id,
    required this.title,
    required this.playerId,
    required this.playerName,
    required this.scoutId,
    required this.scoutName,
    required this.scoutingDate,
    required this.reportDate,
    required this.status,
    required this.confidence,
    required this.executiveSummary,
    required this.detailedAnalysis,
    this.playerAttributes = const {},
    this.performanceData = const {},
    this.scoutingMetrics = const {},
    this.strengths = const [],
    this.weaknesses = const [],
    this.recommendations = const [],
    this.comparisonData = const {},
    this.projectionData = const {},
    this.tags = const [],
    this.attachments = const {},
    this.notes = '',
    required this.lastUpdated,
    this.isPublic = false,
    this.sharedWithScoutIds = const [],
  });

  factory ScoutingReport.initial({
    required String title,
    required String playerId,
    required String playerName,
    required String scoutId,
    required String scoutName,
  }) {
    return ScoutingReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      playerId: playerId,
      playerName: playerName,
      scoutId: scoutId,
      scoutName: scoutName,
      scoutingDate: DateTime.now(),
      reportDate: DateTime.now(),
      status: ReportStatus.draft,
      confidence: ReportConfidence.medium,
      executiveSummary: '',
      detailedAnalysis: '',
      lastUpdated: DateTime.now(),
    );
  }

  ScoutingReport copyWith({
    String? id,
    String? title,
    String? playerId,
    String? playerName,
    String? scoutId,
    String? scoutName,
    DateTime? scoutingDate,
    DateTime? reportDate,
    ReportStatus? status,
    ReportConfidence? confidence,
    String? executiveSummary,
    String? detailedAnalysis,
    Map<String, dynamic>? playerAttributes,
    Map<String, dynamic>? performanceData,
    Map<String, dynamic>? scoutingMetrics,
    List<String>? strengths,
    List<String>? weaknesses,
    List<String>? recommendations,
    Map<String, dynamic>? comparisonData,
    Map<String, dynamic>? projectionData,
    List<String>? tags,
    Map<String, dynamic>? attachments,
    String? notes,
    DateTime? lastUpdated,
    bool? isPublic,
    List<String>? sharedWithScoutIds,
  }) {
    return ScoutingReport(
      id: id ?? this.id,
      title: title ?? this.title,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      scoutingDate: scoutingDate ?? this.scoutingDate,
      reportDate: reportDate ?? this.reportDate,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      executiveSummary: executiveSummary ?? this.executiveSummary,
      detailedAnalysis: detailedAnalysis ?? this.detailedAnalysis,
      playerAttributes: playerAttributes ?? this.playerAttributes,
      performanceData: performanceData ?? this.performanceData,
      scoutingMetrics: scoutingMetrics ?? this.scoutingMetrics,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      recommendations: recommendations ?? this.recommendations,
      comparisonData: comparisonData ?? this.comparisonData,
      projectionData: projectionData ?? this.projectionData,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPublic: isPublic ?? this.isPublic,
      sharedWithScoutIds: sharedWithScoutIds ?? this.sharedWithScoutIds,
    );
  }

  // ステータスの更新
  ScoutingReport updateStatus(ReportStatus newStatus) {
    return copyWith(
      status: newStatus,
      lastUpdated: DateTime.now(),
    );
  }

  // 信頼度の更新
  ScoutingReport updateConfidence(ReportConfidence newConfidence) {
    return copyWith(
      confidence: newConfidence,
      lastUpdated: DateTime.now(),
    );
  }

  // 実行サマリーの更新
  ScoutingReport updateExecutiveSummary(String newSummary) {
    return copyWith(
      executiveSummary: newSummary,
      lastUpdated: DateTime.now(),
    );
  }

  // 詳細分析の更新
  ScoutingReport updateDetailedAnalysis(String newAnalysis) {
    return copyWith(
      detailedAnalysis: newAnalysis,
      lastUpdated: DateTime.now(),
    );
  }

  // 選手属性の更新
  ScoutingReport updatePlayerAttributes(Map<String, dynamic> newAttributes) {
    final updatedAttributes = Map<String, dynamic>.from(playerAttributes);
    updatedAttributes.addAll(newAttributes);
    
    return copyWith(
      playerAttributes: updatedAttributes,
      lastUpdated: DateTime.now(),
    );
  }

  // パフォーマンスデータの更新
  ScoutingReport updatePerformanceData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(performanceData);
    updatedData.addAll(newData);
    
    return copyWith(
      performanceData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // スカウト指標の更新
  ScoutingReport updateScoutingMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(scoutingMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      scoutingMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 強みの追加
  ScoutingReport addStrength(String strength) {
    final updatedStrengths = List<String>.from(strengths);
    if (!updatedStrengths.contains(strength)) {
      updatedStrengths.add(strength);
    }
    
    return copyWith(
      strengths: updatedStrengths,
      lastUpdated: DateTime.now(),
    );
  }

  // 弱みの追加
  ScoutingReport addWeakness(String weakness) {
    final updatedWeaknesses = List<String>.from(weaknesses);
    if (!updatedWeaknesses.contains(weakness)) {
      updatedWeaknesses.add(weakness);
    }
    
    return copyWith(
      weaknesses: updatedWeaknesses,
      lastUpdated: DateTime.now(),
    );
  }

  // 推奨事項の追加
  ScoutingReport addRecommendation(String recommendation) {
    final updatedRecommendations = List<String>.from(recommendations);
    if (!updatedRecommendations.contains(recommendation)) {
      updatedRecommendations.add(recommendation);
    }
    
    return copyWith(
      recommendations: updatedRecommendations,
      lastUpdated: DateTime.now(),
    );
  }

  // タグの追加
  ScoutingReport addTag(String tag) {
    final updatedTags = List<String>.from(tags);
    if (!updatedTags.contains(tag)) {
      updatedTags.add(tag);
    }
    
    return copyWith(
      tags: updatedTags,
      lastUpdated: DateTime.now(),
    );
  }

  // 共有の追加
  ScoutingReport addShare(String scoutId) {
    final updatedShares = List<String>.from(sharedWithScoutIds);
    if (!updatedShares.contains(scoutId)) {
      updatedShares.add(scoutId);
    }
    
    return copyWith(
      sharedWithScoutIds: updatedShares,
      lastUpdated: DateTime.now(),
    );
  }

  // 共有の削除
  ScoutingReport removeShare(String scoutId) {
    final updatedShares = sharedWithScoutIds.where((id) => id != scoutId).toList();
    
    return copyWith(
      sharedWithScoutIds: updatedShares,
      lastUpdated: DateTime.now(),
    );
  }

  // レポートの完了
  ScoutingReport markAsCompleted() {
    return copyWith(
      status: ReportStatus.completed,
      reportDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  // レポートのレビュー完了
  ScoutingReport markAsReviewed() {
    return copyWith(
      status: ReportStatus.reviewed,
      lastUpdated: DateTime.now(),
    );
  }

  // レポートのアーカイブ
  ScoutingReport archive() {
    return copyWith(
      status: ReportStatus.archived,
      lastUpdated: DateTime.now(),
    );
  }

  // レポートの公開設定
  ScoutingReport setPublic(bool isPublic) {
    return copyWith(
      isPublic: isPublic,
      lastUpdated: DateTime.now(),
    );
  }

  // レポートの有効性判定
  bool get isReportValid {
    return status != ReportStatus.draft && status != ReportStatus.archived;
  }

  // レポートの完全性判定
  bool get isReportComplete {
    return executiveSummary.isNotEmpty && 
           detailedAnalysis.isNotEmpty && 
           strengths.isNotEmpty && 
           weaknesses.isNotEmpty && 
           recommendations.isNotEmpty;
  }

  // レポートの品質スコア計算
  double get qualityScore {
    double score = 0.0;
    
    // 基本情報
    if (executiveSummary.isNotEmpty) score += 20;
    if (detailedAnalysis.isNotEmpty) score += 30;
    
    // 分析内容
    if (strengths.isNotEmpty) score += 15;
    if (weaknesses.isNotEmpty) score += 15;
    if (recommendations.isNotEmpty) score += 20;
    
    // 信頼度
    score += (confidence.index + 1) * 5;
    
    return score.clamp(0.0, 100.0);
  }

  // レポートの新鮮度計算
  double get freshnessScore {
    final daysSinceScouting = DateTime.now().difference(scoutingDate).inDays;
    if (daysSinceScouting <= 7) return 1.0;
    if (daysSinceScouting <= 30) return 0.8;
    if (daysSinceScouting <= 90) return 0.6;
    if (daysSinceScouting <= 180) return 0.4;
    return 0.2;
  }

  // 総合評価スコア
  double get overallScore {
    return qualityScore * 0.7 + (freshnessScore * 100) * 0.3;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'playerId': playerId,
      'playerName': playerName,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'scoutingDate': scoutingDate.toIso8601String(),
      'reportDate': reportDate.toIso8601String(),
      'status': status.name,
      'confidence': confidence.name,
      'executiveSummary': executiveSummary,
      'detailedAnalysis': detailedAnalysis,
      'playerAttributes': playerAttributes,
      'performanceData': performanceData,
      'scoutingMetrics': scoutingMetrics,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'recommendations': recommendations,
      'comparisonData': comparisonData,
      'projectionData': projectionData,
      'tags': tags,
      'attachments': attachments,
      'notes': notes,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isPublic': isPublic,
      'sharedWithScoutIds': sharedWithScoutIds,
    };
  }

  factory ScoutingReport.fromJson(Map<String, dynamic> json) {
    return ScoutingReport(
      id: json['id'] as String,
      title: json['title'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      scoutingDate: DateTime.parse(json['scoutingDate'] as String),
      reportDate: DateTime.parse(json['reportDate'] as String),
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.draft,
      ),
      confidence: ReportConfidence.values.firstWhere(
        (e) => e.name == json['confidence'],
        orElse: () => ReportConfidence.medium,
      ),
      executiveSummary: json['executiveSummary'] as String,
      detailedAnalysis: json['detailedAnalysis'] as String,
      playerAttributes: Map<String, dynamic>.from(json['playerAttributes'] ?? {}),
      performanceData: Map<String, dynamic>.from(json['performanceData'] ?? {}),
      scoutingMetrics: Map<String, dynamic>.from(json['scoutingMetrics'] ?? {}),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      comparisonData: Map<String, dynamic>.from(json['comparisonData'] ?? {}),
      projectionData: Map<String, dynamic>.from(json['projectionData'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      attachments: Map<String, dynamic>.from(json['attachments'] ?? {}),
      notes: json['notes'] as String? ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isPublic: json['isPublic'] as bool? ?? false,
      sharedWithScoutIds: List<String>.from(json['sharedWithScoutIds'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoutingReport && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScoutingReport(id: $id, title: $title, playerName: $playerName, status: ${status.label})';
  }
}
