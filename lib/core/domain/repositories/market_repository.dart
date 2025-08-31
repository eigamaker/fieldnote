import '../entities/market_analysis.dart';

abstract class MarketRepository {
  // 市場分析の基本的なCRUD操作
  Future<void> saveMarketAnalysis(MarketAnalysis analysis);
  Future<MarketAnalysis?> loadMarketAnalysis(String analysisId);
  Future<void> deleteMarketAnalysis(String analysisId);
  Future<bool> hasMarketAnalysisData();

  // スカウトIDによる市場分析の取得
  Future<List<MarketAnalysis>> getAnalysesByScoutId(String scoutId);
  Future<List<MarketAnalysis>> getAllMarketAnalyses();

  // 市場分析の一括操作
  Future<void> saveAnalysisList(List<MarketAnalysis> analyses);
  Future<void> bulkUpdateAnalyses(List<Map<String, dynamic>> updates);

  // 市場分析の検索・フィルタリング
  Future<List<MarketAnalysis>> searchAnalysesByKeyword(String keyword);
  Future<List<MarketAnalysis>> getAnalysesBySegment(String segment);
  Future<List<MarketAnalysis>> getAnalysesByTrend(String trend);
  Future<List<MarketAnalysis>> getAnalysesByCompetitionLevel(String level);
  Future<List<MarketAnalysis>> getAnalysesByDateRange(DateTime startDate, DateTime endDate);

  // 市場データの管理
  Future<void> updateMarketData(String analysisId, Map<String, dynamic> marketData);
  Future<void> updateCompetitorData(String analysisId, Map<String, dynamic> competitorData);
  Future<void> updateOpportunityData(String analysisId, Map<String, dynamic> opportunityData);
  Future<void> updateThreatData(String analysisId, Map<String, dynamic> threatData);

  // トレンドデータの管理
  Future<void> addTrendData(String analysisId, Map<String, dynamic> trendRecord);
  Future<List<Map<String, dynamic>>> getTrendData(String analysisId);
  Future<void> updateTrendData(String analysisId, String trendId, Map<String, dynamic> newData);

  // 推奨事項の管理
  Future<void> updateRecommendations(String analysisId, Map<String, dynamic> recommendations);
  Future<Map<String, dynamic>> getRecommendations(String analysisId);

  // 市場分析の統計情報
  Future<Map<String, dynamic>> getMarketStatistics(String scoutId);
  Future<Map<String, dynamic>> getSegmentStatistics(String segment);
  Future<Map<String, dynamic>> getTrendStatistics(String period);
  Future<Map<String, dynamic>> getCompetitionStatistics();

  // 市場分析・洞察
  Future<Map<String, dynamic>> getMarketInsights(String analysisId);
  Future<Map<String, dynamic>> getCompetitiveAnalysis(String analysisId);
  Future<Map<String, dynamic>> getOpportunityAnalysis(String analysisId);
  Future<Map<String, dynamic>> getThreatAnalysis(String analysisId);

  // 市場予測・シミュレーション
  Future<Map<String, dynamic>> getMarketForecast(String analysisId, int months);
  Future<Map<String, dynamic>> getScenarioAnalysis(String analysisId, List<String> scenarios);
  Future<Map<String, dynamic>> getRiskAssessment(String analysisId);

  // 市場レポート
  Future<Map<String, dynamic>> generateMarketReport(String analysisId);
  Future<Map<String, dynamic>> generateCompetitiveReport(String analysisId);
  Future<Map<String, dynamic>> generateTrendReport(String analysisId, DateTime startDate, DateTime endDate);

  // 市場データの検証・整合性
  Future<bool> validateMarketData();
  Future<void> recalculateMarketMetrics(String analysisId);
  Future<void> cleanupOldAnalyses(int daysToKeep);

  // 市場分析の履歴
  Future<List<Map<String, dynamic>>> getAnalysisHistory(String analysisId);
  Future<void> createAnalysisSnapshot(String analysisId);
  Future<Map<String, dynamic>> getAnalysisVersionHistory(String analysisId);

  // 市場比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareMarkets(List<String> analysisIds);
  Future<Map<String, dynamic>> getMarketBenchmarks(String segment);
  Future<Map<String, dynamic>> getCompetitiveBenchmarks(String analysisId);

  // 市場アラート・通知
  Future<List<Map<String, dynamic>>> getMarketAlerts(String scoutId);
  Future<void> setMarketAlert(String analysisId, String alertType, bool enabled);
  Future<void> setTrendThreshold(String analysisId, String metric, double threshold);

  // パフォーマンス最適化
  Future<void> createMarketIndexes();
  Future<void> optimizeMarketQueries();
  Future<Map<String, dynamic>> getMarketPerformanceMetrics();

  // 市場データのエクスポート・インポート
  Future<String> exportMarketAnalysisToJson(String analysisId);
  Future<MarketAnalysis> importMarketAnalysisFromJson(String jsonData);
  Future<void> bulkImportAnalyses(List<String> jsonDataList);

  // 市場データのバックアップ・復元
  Future<void> backupMarketData(String analysisId);
  Future<void> restoreMarketData(String analysisId, String backupId);
  Future<List<Map<String, dynamic>>> getMarketBackups(String analysisId);

  // 市場データの統合・集約
  Future<Map<String, dynamic>> aggregateMarketData(String segment, DateTime startDate, DateTime endDate);
  Future<Map<String, dynamic>> consolidateMarketInsights(String scoutId);
  Future<Map<String, dynamic>> generateMarketIntelligence(String segment);
}
