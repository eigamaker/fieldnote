import 'dart:async';
import '../../../core/domain/entities/market_analysis.dart';
import '../../../core/domain/repositories/market_repository.dart';

class MarketManager {
  final MarketRepository _repository;
  final StreamController<List<MarketAnalysis>> _analysesController = StreamController<List<MarketAnalysis>>.broadcast();
  final StreamController<MarketAnalysis?> _currentAnalysisController = StreamController<MarketAnalysis?>.broadcast();
  final StreamController<Map<String, dynamic>> _marketStatsController = StreamController<Map<String, dynamic>>.broadcast();

  MarketManager(this._repository);

  // ストリーム
  Stream<List<MarketAnalysis>> get analysesStream => _analysesController.stream;
  Stream<MarketAnalysis?> get currentAnalysisStream => _currentAnalysisController.stream;
  Stream<Map<String, dynamic>> get marketStatsStream => _marketStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllAnalyses();
  }

  Future<void> _loadAllAnalyses() async {
    if (await _repository.hasMarketAnalysisData()) {
      final analyses = await _repository.getAllMarketAnalyses();
      _analysesController.add(analyses);
    }
  }

  // 市場分析の管理
  Future<void> createMarketAnalysis({
    required String scoutId,
    required String scoutName,
    required String title,
    required String description,
    required MarketSegment segment,
  }) async {
    final analysis = MarketAnalysis.initial(
      scoutId: scoutId,
      scoutName: scoutName,
      title: title,
      description: description,
      segment: segment,
    );
    
    await _repository.saveMarketAnalysis(analysis);
    await _loadAllAnalyses();
  }

  Future<void> updateMarketAnalysis(MarketAnalysis analysis) async {
    await _repository.saveMarketAnalysis(analysis);
    await _loadAllAnalyses();
  }

  Future<void> deleteMarketAnalysis(String analysisId) async {
    await _repository.deleteMarketAnalysis(analysisId);
    await _loadAllAnalyses();
  }

  Future<MarketAnalysis?> getMarketAnalysis(String analysisId) async {
    return await _repository.loadMarketAnalysis(analysisId);
  }

  Future<List<MarketAnalysis>> getAnalysesByScoutId(String scoutId) async {
    return await _repository.getAnalysesByScoutId(scoutId);
  }

  Future<List<MarketAnalysis>> getAllAnalyses() async {
    return await _repository.getAllMarketAnalyses();
  }

  // 市場データの管理
  Future<void> updateMarketData(String analysisId, Map<String, dynamic> marketData) async {
    await _repository.updateMarketData(analysisId, marketData);
    await _updateMarketStats(analysisId);
  }

  Future<void> updateCompetitorData(String analysisId, Map<String, dynamic> competitorData) async {
    await _repository.updateCompetitorData(analysisId, competitorData);
    await _updateMarketStats(analysisId);
  }

  Future<void> updateOpportunityData(String analysisId, Map<String, dynamic> opportunityData) async {
    await _repository.updateOpportunityData(analysisId, opportunityData);
    await _updateMarketStats(analysisId);
  }

  Future<void> updateThreatData(String analysisId, Map<String, dynamic> threatData) async {
    await _repository.updateThreatData(analysisId, threatData);
    await _updateMarketStats(analysisId);
  }

  // トレンドデータの管理
  Future<void> addTrendData(String analysisId, Map<String, dynamic> trendRecord) async {
    await _repository.addTrendData(analysisId, trendRecord);
    await _updateMarketStats(analysisId);
  }

  Future<List<Map<String, dynamic>>> getTrendData(String analysisId) async {
    return await _repository.getTrendData(analysisId);
  }

  Future<void> updateTrendData(String analysisId, String trendId, Map<String, dynamic> newData) async {
    await _repository.updateTrendData(analysisId, trendId, newData);
    await _updateMarketStats(analysisId);
  }

  // 推奨事項の管理
  Future<void> updateRecommendations(String analysisId, Map<String, dynamic> recommendations) async {
    await _repository.updateRecommendations(analysisId, recommendations);
    await _updateMarketStats(analysisId);
  }

  Future<Map<String, dynamic>> getRecommendations(String analysisId) async {
    return await _repository.getRecommendations(analysisId);
  }

  // 市場分析の統計情報
  Future<Map<String, dynamic>> getMarketStatistics(String scoutId) async {
    return await _repository.getMarketStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getSegmentStatistics(String segment) async {
    return await _repository.getSegmentStatistics(segment);
  }

  Future<Map<String, dynamic>> getTrendStatistics(String period) async {
    return await _repository.getTrendStatistics(period);
  }

  Future<Map<String, dynamic>> getCompetitionStatistics() async {
    return await _repository.getCompetitionStatistics();
  }

  // 市場分析・洞察
  Future<Map<String, dynamic>> getMarketInsights(String analysisId) async {
    return await _repository.getMarketInsights(analysisId);
  }

  Future<Map<String, dynamic>> getCompetitiveAnalysis(String analysisId) async {
    return await _repository.getCompetitiveAnalysis(analysisId);
  }

  Future<Map<String, dynamic>> getOpportunityAnalysis(String analysisId) async {
    return await _repository.getOpportunityAnalysis(analysisId);
  }

  Future<Map<String, dynamic>> getThreatAnalysis(String analysisId) async {
    return await _repository.getThreatAnalysis(analysisId);
  }

  // 市場予測・シミュレーション
  Future<Map<String, dynamic>> getMarketForecast(String analysisId, int months) async {
    return await _repository.getMarketForecast(analysisId, months);
  }

  Future<Map<String, dynamic>> getScenarioAnalysis(String analysisId, List<String> scenarios) async {
    return await _repository.getScenarioAnalysis(analysisId, scenarios);
  }

  Future<Map<String, dynamic>> getRiskAssessment(String analysisId) async {
    return await _repository.getRiskAssessment(analysisId);
  }

  // 市場レポート
  Future<Map<String, dynamic>> generateMarketReport(String analysisId) async {
    return await _repository.generateMarketReport(analysisId);
  }

  Future<Map<String, dynamic>> generateCompetitiveReport(String analysisId) async {
    return await _repository.generateCompetitiveReport(analysisId);
  }

  Future<Map<String, dynamic>> generateTrendReport(String analysisId, DateTime startDate, DateTime endDate) async {
    return await _repository.generateTrendReport(analysisId, startDate, endDate);
  }

  // 市場データの検証・整合性
  Future<bool> validateMarketData() async {
    return await _repository.validateMarketData();
  }

  Future<void> recalculateMarketMetrics(String analysisId) async {
    await _repository.recalculateMarketMetrics(analysisId);
    await _updateMarketStats(analysisId);
  }

  Future<void> cleanupOldAnalyses(int daysToKeep) async {
    await _repository.cleanupOldAnalyses(daysToKeep);
    await _loadAllAnalyses();
  }

  // 市場分析の履歴
  Future<List<Map<String, dynamic>>> getAnalysisHistory(String analysisId) async {
    return await _repository.getAnalysisHistory(analysisId);
  }

  Future<void> createAnalysisSnapshot(String analysisId) async {
    await _repository.createAnalysisSnapshot(analysisId);
  }

  Future<Map<String, dynamic>> getAnalysisVersionHistory(String analysisId) async {
    return await _repository.getAnalysisVersionHistory(analysisId);
  }

  // 市場比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareMarkets(List<String> analysisIds) async {
    return await _repository.compareMarkets(analysisIds);
  }

  Future<Map<String, dynamic>> getMarketBenchmarks(String segment) async {
    return await _repository.getMarketBenchmarks(segment);
  }

  Future<Map<String, dynamic>> getCompetitiveBenchmarks(String analysisId) async {
    return await _repository.getCompetitiveBenchmarks(analysisId);
  }

  // 市場アラート・通知
  Future<List<Map<String, dynamic>>> getMarketAlerts(String scoutId) async {
    return await _repository.getMarketAlerts(scoutId);
  }

  Future<void> setMarketAlert(String analysisId, String alertType, bool enabled) async {
    await _repository.setMarketAlert(analysisId, alertType, enabled);
  }

  Future<void> setTrendThreshold(String analysisId, String metric, double threshold) async {
    await _repository.setTrendThreshold(analysisId, metric, threshold);
  }

  // 市場データの検索・フィルタリング
  Future<List<MarketAnalysis>> searchAnalysesByKeyword(String keyword) async {
    return await _repository.searchAnalysesByKeyword(keyword);
  }

  Future<List<MarketAnalysis>> getAnalysesBySegment(String segment) async {
    return await _repository.getAnalysesBySegment(segment);
  }

  Future<List<MarketAnalysis>> getAnalysesByTrend(String trend) async {
    return await _repository.getAnalysesByTrend(trend);
  }

  Future<List<MarketAnalysis>> getAnalysesByCompetitionLevel(String level) async {
    return await _repository.getAnalysesByCompetitionLevel(level);
  }

  Future<List<MarketAnalysis>> getAnalysesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getAnalysesByDateRange(startDate, endDate);
  }

  // 一括操作
  Future<void> saveAnalysisList(List<MarketAnalysis> analyses) async {
    await _repository.saveAnalysisList(analyses);
    await _loadAllAnalyses();
  }

  Future<void> bulkUpdateAnalyses(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateAnalyses(updates);
    await _loadAllAnalyses();
  }

  // パフォーマンス最適化
  Future<void> createMarketIndexes() async {
    await _repository.createMarketIndexes();
  }

  Future<void> optimizeMarketQueries() async {
    await _repository.optimizeMarketQueries();
  }

  Future<Map<String, dynamic>> getMarketPerformanceMetrics() async {
    return await _repository.getMarketPerformanceMetrics();
  }

  // 市場データのエクスポート・インポート
  Future<String> exportMarketAnalysisToJson(String analysisId) async {
    return await _repository.exportMarketAnalysisToJson(analysisId);
  }

  Future<MarketAnalysis> importMarketAnalysisFromJson(String jsonData) async {
    final analysis = await _repository.importMarketAnalysisFromJson(jsonData);
    await _loadAllAnalyses();
    return analysis;
  }

  Future<void> bulkImportAnalyses(List<String> jsonDataList) async {
    await _repository.bulkImportAnalyses(jsonDataList);
    await _loadAllAnalyses();
  }

  // 市場データのバックアップ・復元
  Future<void> backupMarketData(String analysisId) async {
    await _repository.backupMarketData(analysisId);
  }

  Future<void> restoreMarketData(String analysisId, String backupId) async {
    await _repository.restoreMarketData(analysisId, backupId);
    await _loadAllAnalyses();
  }

  Future<List<Map<String, dynamic>>> getMarketBackups(String analysisId) async {
    return await _repository.getMarketBackups(analysisId);
  }

  // 市場データの統合・集約
  Future<Map<String, dynamic>> aggregateMarketData(String segment, DateTime startDate, DateTime endDate) async {
    return await _repository.aggregateMarketData(segment, startDate, endDate);
  }

  Future<Map<String, dynamic>> consolidateMarketInsights(String scoutId) async {
    return await _repository.consolidateMarketInsights(scoutId);
  }

  Future<Map<String, dynamic>> generateMarketIntelligence(String segment) async {
    return await _repository.generateMarketIntelligence(segment);
  }

  // 市場計算ヘルパー
  double calculateMarketAttractiveness(MarketAnalysis analysis) {
    return analysis.marketAttractiveness;
  }

  double calculateCompetitiveAdvantage(MarketAnalysis analysis) {
    return analysis.competitiveAdvantage;
  }

  double calculateMarketRisk(MarketAnalysis analysis) {
    return analysis.marketRisk;
  }

  double calculateMarketOpportunity(MarketAnalysis analysis) {
    return analysis.marketOpportunity;
  }

  double calculateOverallMarketScore(MarketAnalysis analysis) {
    return analysis.overallMarketScore;
  }

  String getMarketMaturity(MarketAnalysis analysis) {
    return analysis.marketMaturity;
  }

  String getEntryRecommendation(MarketAnalysis analysis) {
    return analysis.entryRecommendation;
  }

  Map<String, dynamic> getTrendAnalysis(MarketAnalysis analysis) {
    return analysis.trendAnalysis;
  }

  Map<String, dynamic> getCompetitorAnalysis(MarketAnalysis analysis) {
    return analysis.competitorAnalysis;
  }

  Map<String, dynamic> getSwotAnalysis(MarketAnalysis analysis) {
    return analysis.swotAnalysis;
  }

  // 統計の更新
  Future<void> _updateMarketStats(String analysisId) async {
    final stats = await _repository.getMarketStatistics(analysisId);
    _marketStatsController.add(stats);
  }

  // リソース解放
  void dispose() {
    _analysesController.close();
    _currentAnalysisController.close();
    _marketStatsController.close();
  }
}
