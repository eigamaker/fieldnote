import '../entities/scouting_report.dart';

abstract class ReportRepository {
  // スカウトレポートの基本的なCRUD操作
  Future<void> saveScoutingReport(ScoutingReport report);
  Future<ScoutingReport?> loadScoutingReport(String reportId);
  Future<void> deleteScoutingReport(String reportId);
  Future<bool> hasScoutingReportData();

  // レポートの一括操作
  Future<void> saveReportList(List<ScoutingReport> reports);
  Future<List<ScoutingReport>> loadAllScoutingReports();

  // スカウトIDによるレポートの取得
  Future<List<ScoutingReport>> getReportsByScoutId(String scoutId);
  Future<List<ScoutingReport>> getReportsByPlayerId(String playerId);

  // レポートステータスによる検索
  Future<List<ScoutingReport>> getReportsByStatus(String status);
  Future<List<ScoutingReport>> getReportsByConfidence(String confidence);

  // レポートの検索・フィルタリング
  Future<List<ScoutingReport>> searchReportsByKeyword(String keyword);
  Future<List<ScoutingReport>> getReportsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<ScoutingReport>> getReportsByTags(List<String> tags);

  // レポートの共有管理
  Future<void> shareReportWithScout(String reportId, String scoutId);
  Future<void> unshareReportWithScout(String reportId, String scoutId);
  Future<List<String>> getReportSharedScouts(String reportId);

  // レポートの公開設定
  Future<void> setReportPublic(String reportId, bool isPublic);
  Future<List<ScoutingReport>> getPublicReports();

  // レポートの品質評価
  Future<Map<String, dynamic>> getReportQualityMetrics(String reportId);
  Future<List<Map<String, dynamic>>> getTopQualityReports(int limit);

  // レポートの統計情報
  Future<Map<String, dynamic>> getReportStatistics(String scoutId);
  Future<Map<String, dynamic>> getPlayerReportHistory(String playerId);
  Future<Map<String, dynamic>> getScoutReportSummary(String scoutId);

  // レポートの比較分析
  Future<List<Map<String, dynamic>>> compareReports(List<String> reportIds);
  Future<Map<String, dynamic>> getReportTrends(String scoutId, String period);

  // レポートのアーカイブ管理
  Future<void> archiveReport(String reportId);
  Future<void> restoreReport(String reportId);
  Future<List<ScoutingReport>> getArchivedReports();

  // レポートの検証・レビュー
  Future<void> markReportAsReviewed(String reportId);
  Future<void> updateReportConfidence(String reportId, String confidence);

  // データ整合性・検証
  Future<bool> validateReportData();
  Future<void> cleanupOldReports(int daysToKeep);
  Future<void> recalculateReportScores();

  // レポートの履歴管理
  Future<List<Map<String, dynamic>>> getReportVersionHistory(String reportId);
  Future<void> createReportSnapshot(String reportId);

  // レポートのテンプレート管理
  Future<List<Map<String, dynamic>>> getReportTemplates();
  Future<void> saveReportTemplate(Map<String, dynamic> template);
  Future<void> deleteReportTemplate(String templateId);

  // パフォーマンス最適化
  Future<void> createReportIndexes();
  Future<void> optimizeReportQueries();
  Future<Map<String, dynamic>> getReportPerformanceMetrics();

  // レポートのエクスポート・インポート
  Future<String> exportReportToJson(String reportId);
  Future<ScoutingReport> importReportFromJson(String jsonData);
  Future<void> bulkImportReports(List<String> jsonDataList);
}
