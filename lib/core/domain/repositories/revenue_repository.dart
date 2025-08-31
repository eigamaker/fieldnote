import '../entities/revenue_stream.dart';

abstract class RevenueRepository {
  // 収益ストリームの基本的なCRUD操作
  Future<void> saveRevenueStream(RevenueStream revenue);
  Future<RevenueStream?> loadRevenueStream(String revenueId);
  Future<void> deleteRevenueStream(String revenueId);
  Future<bool> hasRevenueStreamData();

  // スカウトIDによる収益ストリームの取得
  Future<List<RevenueStream>> getRevenuesByScoutId(String scoutId);
  Future<List<RevenueStream>> getAllRevenueStreams();

  // 収益ストリームの一括操作
  Future<void> saveRevenueList(List<RevenueStream> revenues);
  Future<void> bulkUpdateRevenues(List<Map<String, dynamic>> updates);

  // 収益ストリームの検索・フィルタリング
  Future<List<RevenueStream>> searchRevenuesByKeyword(String keyword);
  Future<List<RevenueStream>> getRevenuesByContractType(String contractType);
  Future<List<RevenueStream>> getRevenuesByStatus(String status);
  Future<List<RevenueStream>> getRevenuesByCustomerType(String customerType);
  Future<List<RevenueStream>> getRevenuesByDateRange(DateTime startDate, DateTime endDate);

  // 収益統計情報
  Future<Map<String, dynamic>> getRevenueStatistics(String scoutId);
  Future<Map<String, dynamic>> getContractStatistics(String revenueId);
  Future<Map<String, dynamic>> getCustomerStatistics(String revenueId);
  Future<Map<String, dynamic>> getPerformanceStatistics(String revenueId);

  // 収益分析・予測
  Future<Map<String, dynamic>> getRevenueAnalysis(String revenueId);
  Future<Map<String, dynamic>> getProfitabilityAnalysis(String revenueId);
  Future<Map<String, dynamic>> getGrowthTrendAnalysis(String revenueId);
  Future<Map<String, dynamic>> getRiskAssessment(String revenueId);

  // 収益レポート
  Future<Map<String, dynamic>> generateRevenueReport(String revenueId);
  Future<Map<String, dynamic>> generateContractReport(String revenueId);
  Future<Map<String, dynamic>> generateCustomerReport(String revenueId);

  // 収益データの検証・整合性
  Future<bool> validateRevenueData();
  Future<void> recalculateRevenueMetrics(String revenueId);
  Future<void> cleanupOldRevenueData(String revenueId, int daysToKeep);

  // 収益履歴
  Future<List<Map<String, dynamic>>> getRevenueHistory(String revenueId);
  Future<void> createRevenueSnapshot(String revenueId);

  // 収益比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareRevenues(List<String> revenueIds);
  Future<Map<String, dynamic>> getRevenueBenchmarks(String contractType);

  // 収益アラート・通知
  Future<List<Map<String, dynamic>>> getRevenueAlerts(String scoutId);
  Future<void> setRevenueAlert(String revenueId, String alertType, bool enabled);

  // パフォーマンス最適化
  Future<void> createRevenueIndexes();
  Future<void> optimizeRevenueQueries();
  Future<Map<String, dynamic>> getRevenuePerformanceMetrics();

  // 収益データのエクスポート・インポート
  Future<String> exportRevenueToJson(String revenueId);
  Future<RevenueStream> importRevenueFromJson(String jsonData);
  Future<void> bulkImportRevenues(List<String> jsonDataList);

  // 収益データのバックアップ・復元
  Future<void> backupRevenueData(String revenueId);
  Future<void> restoreRevenueData(String revenueId, String backupId);
  Future<List<Map<String, dynamic>>> getRevenueBackups(String revenueId);
}
