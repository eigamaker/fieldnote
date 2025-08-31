import '../entities/office_management.dart';

abstract class OfficeRepository {
  // オフィス管理の基本的なCRUD操作
  Future<void> saveOfficeManagement(OfficeManagement office);
  Future<OfficeManagement?> loadOfficeManagement(String officeId);
  Future<void> deleteOfficeManagement(String officeId);
  Future<bool> hasOfficeManagementData();

  // スカウトIDによるオフィス管理の取得
  Future<OfficeManagement?> getOfficeByScoutId(String scoutId);
  Future<List<OfficeManagement>> getAllOfficeManagements();

  // オフィス管理の一括操作
  Future<void> saveOfficeList(List<OfficeManagement> offices);
  Future<void> bulkUpdateOffices(List<Map<String, dynamic>> updates);

  // オフィス管理の検索・フィルタリング
  Future<List<OfficeManagement>> searchOfficesByKeyword(String keyword);
  Future<List<OfficeManagement>> getOfficesByLevel(String level);
  Future<List<OfficeManagement>> getOfficesByLocation(String location);
  Future<List<OfficeManagement>> getOfficesByDateRange(DateTime startDate, DateTime endDate);

  // オフィス統計情報
  Future<Map<String, dynamic>> getOfficeStatistics(String officeId);
  Future<Map<String, dynamic>> getEquipmentStatistics(String officeId);
  Future<Map<String, dynamic>> getStaffStatistics(String officeId);
  Future<Map<String, dynamic>> getFacilityStatistics(String officeId);

  // オフィス分析・洞察
  Future<Map<String, dynamic>> getOfficeEfficiencyAnalysis(String officeId);
  Future<Map<String, dynamic>> getProductivityAnalysis(String officeId);
  Future<Map<String, dynamic>> getCostEfficiencyAnalysis(String officeId);
  Future<Map<String, dynamic>> getGrowthPotentialAnalysis(String officeId);

  // オフィスレポート
  Future<Map<String, dynamic>> generateOfficeReport(String officeId);
  Future<Map<String, dynamic>> generateEquipmentReport(String officeId);
  Future<Map<String, dynamic>> generateStaffReport(String officeId);

  // オフィスデータの検証・整合性
  Future<bool> validateOfficeData();
  Future<void> recalculateOfficeMetrics(String officeId);
  Future<void> cleanupOldOfficeData(String officeId, int daysToKeep);

  // オフィス履歴
  Future<List<Map<String, dynamic>>> getOfficeHistory(String officeId);
  Future<void> createOfficeSnapshot(String officeId);

  // オフィス比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareOffices(List<String> officeIds);
  Future<Map<String, dynamic>> getOfficeBenchmarks(String level);

  // オフィスアラート・通知
  Future<List<Map<String, dynamic>>> getOfficeAlerts(String officeId);
  Future<void> setOfficeAlert(String officeId, String alertType, bool enabled);

  // パフォーマンス最適化
  Future<void> createOfficeIndexes();
  Future<void> optimizeOfficeQueries();
  Future<Map<String, dynamic>> getOfficePerformanceMetrics();

  // オフィスデータのエクスポート・インポート
  Future<String> exportOfficeToJson(String officeId);
  Future<OfficeManagement> importOfficeFromJson(String jsonData);
  Future<void> bulkImportOffices(List<String> jsonDataList);

  // オフィスデータのバックアップ・復元
  Future<void> backupOfficeData(String officeId);
  Future<void> restoreOfficeData(String officeId, String backupId);
  Future<List<Map<String, dynamic>>> getOfficeBackups(String officeId);
}
