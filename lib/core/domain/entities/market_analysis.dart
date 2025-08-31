enum MarketTrend {
  growing('成長'),
  stable('安定'),
  declining('減少'),
  volatile('変動'),
  emerging('新興'),
  mature('成熟');

  const MarketTrend(this.label);
  final String label;
}

enum CompetitionLevel {
  low('低'),
  medium('中'),
  high('高'),
  intense('激しい'),
  monopoly('独占');

  const CompetitionLevel(this.label);
  final String label;
}

enum MarketSegment {
  highSchool('高校野球'),
  university('大学野球'),
  professional('プロ野球'),
  independent('独立リーグ'),
  international('国際'),
  amateur('アマチュア'),
  other('その他');

  const MarketSegment(this.label);
  final String label;
}

class MarketAnalysis {
  final String id;
  final String scoutId;
  final String scoutName;
  final String title;
  final String description;
  final MarketSegment segment;
  final MarketTrend trend;
  final CompetitionLevel competitionLevel;
  final DateTime analysisDate;
  final DateTime lastUpdated;
  final Map<String, dynamic> marketData;
  final Map<String, dynamic> competitorData;
  final Map<String, dynamic> opportunityData;
  final Map<String, dynamic> threatData;
  final List<Map<String, dynamic>> trendData;
  final Map<String, dynamic> recommendations;
  final String notes;

  const MarketAnalysis({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.title,
    required this.description,
    required this.segment,
    required this.trend,
    required this.competitionLevel,
    required this.analysisDate,
    required this.lastUpdated,
    this.marketData = const {},
    this.competitorData = const {},
    this.opportunityData = const {},
    this.threatData = const {},
    this.trendData = const [],
    this.recommendations = const {},
    this.notes = '',
  });

  factory MarketAnalysis.initial({
    required String scoutId,
    required String scoutName,
    required String title,
    required String description,
    required MarketSegment segment,
  }) {
    return MarketAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      title: title,
      description: description,
      segment: segment,
      trend: MarketTrend.stable,
      competitionLevel: CompetitionLevel.medium,
      analysisDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  MarketAnalysis copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    String? title,
    String? description,
    MarketSegment? segment,
    MarketTrend? trend,
    CompetitionLevel? competitionLevel,
    DateTime? analysisDate,
    DateTime? lastUpdated,
    Map<String, dynamic>? marketData,
    Map<String, dynamic>? competitorData,
    Map<String, dynamic>? opportunityData,
    Map<String, dynamic>? threatData,
    List<Map<String, dynamic>>? trendData,
    Map<String, dynamic>? recommendations,
    String? notes,
  }) {
    return MarketAnalysis(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      title: title ?? this.title,
      description: description ?? this.description,
      segment: segment ?? this.segment,
      trend: trend ?? this.trend,
      competitionLevel: competitionLevel ?? this.competitionLevel,
      analysisDate: analysisDate ?? this.analysisDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      marketData: marketData ?? this.marketData,
      competitorData: competitorData ?? this.competitorData,
      opportunityData: opportunityData ?? this.opportunityData,
      threatData: threatData ?? this.threatData,
      trendData: trendData ?? this.trendData,
      recommendations: recommendations ?? this.recommendations,
      notes: notes ?? this.notes,
    );
  }

  // 市場データの更新
  MarketAnalysis updateMarketData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(marketData);
    updatedData.addAll(newData);
    
    return copyWith(
      marketData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // 競合データの更新
  MarketAnalysis updateCompetitorData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(competitorData);
    updatedData.addAll(newData);
    
    return copyWith(
      competitorData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // 機会データの更新
  MarketAnalysis updateOpportunityData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(opportunityData);
    updatedData.addAll(newData);
    
    return copyWith(
      opportunityData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // 脅威データの更新
  MarketAnalysis updateThreatData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(threatData);
    updatedData.addAll(newData);
    
    return copyWith(
      threatData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // トレンドデータの追加
  MarketAnalysis addTrendData(Map<String, dynamic> trendRecord) {
    final updatedTrends = List<Map<String, dynamic>>.from(trendData);
    updatedTrends.add(trendRecord);
    
    return copyWith(
      trendData: updatedTrends,
      lastUpdated: DateTime.now(),
    );
  }

  // 推奨事項の更新
  MarketAnalysis updateRecommendations(Map<String, dynamic> newRecommendations) {
    final updatedRecs = Map<String, dynamic>.from(recommendations);
    updatedRecs.addAll(newRecommendations);
    
    return copyWith(
      recommendations: updatedRecs,
      lastUpdated: DateTime.now(),
    );
  }

  // 市場トレンドの更新
  MarketAnalysis updateMarketTrend(MarketTrend newTrend) {
    return copyWith(
      trend: newTrend,
      lastUpdated: DateTime.now(),
    );
  }

  // 競争レベルの更新
  MarketAnalysis updateCompetitionLevel(CompetitionLevel newLevel) {
    return copyWith(
      competitionLevel: newLevel,
      lastUpdated: DateTime.now(),
    );
  }

  // 市場規模の取得
  double get marketSize {
    return marketData['marketSize'] as double? ?? 0.0;
  }

  // 市場成長率の取得
  double get marketGrowthRate {
    return marketData['growthRate'] as double? ?? 0.0;
  }

  // 市場シェアの取得
  double get marketShare {
    return marketData['marketShare'] as double? ?? 0.0;
  }

  // 競合他社数
  int get competitorCount {
    return competitorData['competitorCount'] as int? ?? 0;
  }

  // 主要競合他社
  List<String> get majorCompetitors {
    return List<String>.from(competitorData['majorCompetitors'] ?? []);
  }

  // 機会の数
  int get opportunityCount {
    return opportunityData['opportunityCount'] as int? ?? 0;
  }

  // 脅威の数
  int get threatCount {
    return threatData['threatCount'] as int? ?? 0;
  }

  // 市場の魅力度計算
  double get marketAttractiveness {
    double score = 0.0;
    
    // 市場成長率 (30点)
    if (marketGrowthRate >= 10) score += 30;
    else if (marketGrowthRate >= 5) score += 25;
    else if (marketGrowthRate >= 0) score += 20;
    else if (marketGrowthRate >= -5) score += 10;
    
    // 市場規模 (25点)
    if (marketSize >= 1000000000) score += 25; // 10億円以上
    else if (marketSize >= 100000000) score += 20; // 1億円以上
    else if (marketSize >= 10000000) score += 15; // 1000万円以上
    else if (marketSize >= 1000000) score += 10; // 100万円以上
    
    // 競争レベル (25点)
    switch (competitionLevel) {
      case CompetitionLevel.low:
        score += 25;
        break;
      case CompetitionLevel.medium:
        score += 20;
        break;
      case CompetitionLevel.high:
        score += 15;
        break;
      case CompetitionLevel.intense:
        score += 10;
        break;
      case CompetitionLevel.monopoly:
        score += 5;
        break;
    }
    
    // 機会の数 (20点)
    score += (opportunityCount * 5).clamp(0, 20);
    
    return score.clamp(0.0, 100.0);
  }

  // 競争優位性の計算
  double get competitiveAdvantage {
    double score = 0.0;
    
    // 市場シェア (40点)
    if (marketShare >= 30) score += 40;
    else if (marketShare >= 20) score += 30;
    else if (marketShare >= 10) score += 20;
    else if (marketShare >= 5) score += 10;
    
    // 競合他社数 (30点)
    if (competitorCount <= 3) score += 30;
    else if (competitorCount <= 5) score += 25;
    else if (competitorCount <= 10) score += 20;
    else if (competitorCount <= 20) score += 15;
    else score += 10;
    
    // 脅威の数 (30点)
    score += (30 - (threatCount * 3)).clamp(0, 30);
    
    return score.clamp(0.0, 100.0);
  }

  // 市場リスクの計算
  double get marketRisk {
    double risk = 0.0;
    
    // 競争レベルのリスク
    switch (competitionLevel) {
      case CompetitionLevel.intense:
        risk += 30;
        break;
      case CompetitionLevel.high:
        risk += 25;
        break;
      case CompetitionLevel.medium:
        risk += 20;
        break;
      case CompetitionLevel.low:
        risk += 15;
        break;
      case CompetitionLevel.monopoly:
        risk += 10;
        break;
    }
    
    // 市場トレンドのリスク
    switch (trend) {
      case MarketTrend.declining:
        risk += 25;
        break;
      case MarketTrend.volatile:
        risk += 20;
        break;
      case MarketTrend.mature:
        risk += 15;
        break;
      case MarketTrend.stable:
        risk += 10;
        break;
      case MarketTrend.growing:
        risk += 5;
        break;
      case MarketTrend.emerging:
        risk += 15;
        break;
    }
    
    // 脅威の数によるリスク
    risk += (threatCount * 5).clamp(0, 25);
    
    return risk.clamp(0.0, 100.0);
  }

  // 市場機会の計算
  double get marketOpportunity {
    double opportunity = 0.0;
    
    // 機会の数
    opportunity += (opportunityCount * 10).clamp(0, 40);
    
    // 市場成長率による機会
    if (marketGrowthRate >= 10) opportunity += 30;
    else if (marketGrowthRate >= 5) opportunity += 25;
    else if (marketGrowthRate >= 0) opportunity += 20;
    else if (marketGrowthRate >= -5) opportunity += 15;
    
    // 市場トレンドによる機会
    switch (trend) {
      case MarketTrend.emerging:
        opportunity += 30;
        break;
      case MarketTrend.growing:
        opportunity += 25;
        break;
      case MarketTrend.stable:
        opportunity += 20;
        break;
      case MarketTrend.mature:
        opportunity += 15;
        break;
      case MarketTrend.volatile:
        opportunity += 10;
        break;
      case MarketTrend.declining:
        opportunity += 5;
        break;
    }
    
    return opportunity.clamp(0.0, 100.0);
  }

  // 総合市場評価
  double get overallMarketScore {
    return (marketAttractiveness * 0.3 + 
            competitiveAdvantage * 0.3 + 
            marketOpportunity * 0.25 + 
            (100 - marketRisk) * 0.15).clamp(0.0, 100.0);
  }

  // 市場の成熟度
  String get marketMaturity {
    if (overallMarketScore >= 80) return '高成熟度';
    if (overallMarketScore >= 60) return '中成熟度';
    if (overallMarketScore >= 40) return '低成熟度';
    return '未成熟';
  }

  // 参入の推奨度
  String get entryRecommendation {
    if (overallMarketScore >= 80) return '強く推奨';
    if (overallMarketScore >= 60) return '推奨';
    if (overallMarketScore >= 40) return '条件付き推奨';
    if (overallMarketScore >= 20) return '慎重に検討';
    return '非推奨';
  }

  // 市場トレンドの分析
  Map<String, dynamic> get trendAnalysis {
    if (trendData.isEmpty) return {};
    
    final recentTrends = trendData.take(6).toList();
    final trendValues = recentTrends.map((t) => t['value'] as double).toList();
    
    if (trendValues.isEmpty) return {};
    
    final mean = trendValues.reduce((a, b) => a + b) / trendValues.length;
    final variance = trendValues.map((value) => (value - mean) * (value - mean)).reduce((a, b) => a + b) / trendValues.length;
    
    return {
      'mean': mean,
      'variance': variance,
      'trendDirection': trendValues.last > trendValues.first ? '上昇' : '下降',
      'trendStrength': variance > 100 ? '強い' : variance > 50 ? '中程度' : '弱い',
      'dataPoints': trendValues.length,
    };
  }

  // 競合分析
  Map<String, dynamic> get competitorAnalysis {
    return {
      'competitorCount': competitorCount,
      'majorCompetitors': majorCompetitors,
      'competitionLevel': competitionLevel.label,
      'marketShare': marketShare,
      'competitivePosition': marketShare >= 20 ? 'リーダー' : 
                           marketShare >= 10 ? 'チャレンジャー' : 
                           marketShare >= 5 ? 'フォロワー' : 'ニッチャー',
    };
  }

  // SWOT分析
  Map<String, dynamic> get swotAnalysis {
    return {
      'strengths': recommendations['strengths'] ?? [],
      'weaknesses': recommendations['weaknesses'] ?? [],
      'opportunities': opportunityData['opportunities'] ?? [],
      'threats': threatData['threats'] ?? [],
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'title': title,
      'description': description,
      'segment': segment.name,
      'trend': trend.name,
      'competitionLevel': competitionLevel.name,
      'analysisDate': analysisDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'marketData': marketData,
      'competitorData': competitorData,
      'opportunityData': opportunityData,
      'threatData': threatData,
      'trendData': trendData,
      'recommendations': recommendations,
      'notes': notes,
    };
  }

  factory MarketAnalysis.fromJson(Map<String, dynamic> json) {
    return MarketAnalysis(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      segment: MarketSegment.values.firstWhere(
        (e) => e.name == json['segment'],
        orElse: () => MarketSegment.other,
      ),
      trend: MarketTrend.values.firstWhere(
        (e) => e.name == json['trend'],
        orElse: () => MarketTrend.stable,
      ),
      competitionLevel: CompetitionLevel.values.firstWhere(
        (e) => e.name == json['competitionLevel'],
        orElse: () => CompetitionLevel.medium,
      ),
      analysisDate: DateTime.parse(json['analysisDate'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      marketData: Map<String, dynamic>.from(json['marketData'] ?? {}),
      competitorData: Map<String, dynamic>.from(json['competitorData'] ?? {}),
      opportunityData: Map<String, dynamic>.from(json['opportunityData'] ?? {}),
      threatData: Map<String, dynamic>.from(json['threatData'] ?? {}),
      trendData: List<Map<String, dynamic>>.from(json['trendData'] ?? []),
      recommendations: Map<String, dynamic>.from(json['recommendations'] ?? {}),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarketAnalysis && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MarketAnalysis(id: $id, title: $title, segment: ${segment.label}, trend: ${trend.label})';
  }
}
