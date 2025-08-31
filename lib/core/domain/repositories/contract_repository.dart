import '../entities/revenue_stream.dart';

abstract class ContractRepository {
  // 契約の基本的なCRUD操作
  Future<void> saveContract(RevenueStream contract);
  Future<RevenueStream?> loadContract(String contractId);
  Future<void> deleteContract(String contractId);
  Future<bool> hasContractData();

  // スカウトIDによる契約の取得
  Future<List<RevenueStream>> getContractsByScoutId(String scoutId);
  Future<List<RevenueStream>> getAllContracts();

  // 契約の一括操作
  Future<void> saveContractList(List<RevenueStream> contracts);
  Future<void> bulkUpdateContracts(List<Map<String, dynamic>> updates);

  // 契約の検索・フィルタリング
  Future<List<RevenueStream>> searchContractsByKeyword(String keyword);
  Future<List<RevenueStream>> getContractsByType(String contractType);
  Future<List<RevenueStream>> getContractsByStatus(String status);
  Future<List<RevenueStream>> getContractsByCustomerType(String customerType);
  Future<List<RevenueStream>> getContractsByDateRange(DateTime startDate, DateTime endDate);

  // 契約統計情報
  Future<Map<String, dynamic>> getContractStatistics(String scoutId);
  Future<Map<String, dynamic>> getNegotiationStatistics(String scoutId);
  Future<Map<String, dynamic>> getContractPerformanceStatistics(String contractId);

  // 契約分析・洞察
  Future<Map<String, dynamic>> getContractAnalysis(String contractId);
  Future<Map<String, dynamic>> getNegotiationAnalysis(String contractId);
  Future<Map<String, dynamic>> getContractRiskAssessment(String contractId);

  // 契約レポート
  Future<Map<String, dynamic>> generateContractReport(String contractId);
  Future<Map<String, dynamic>> generateNegotiationReport(String contractId);
  Future<Map<String, dynamic>> generateContractSummary(String scoutId);

  // 契約データの検証・整合性
  Future<bool> validateContractData();
  Future<void> recalculateContractMetrics(String contractId);
  Future<void> cleanupOldContractData(String contractId, int daysToKeep);

  // 契約履歴
  Future<List<Map<String, dynamic>>> getContractHistory(String contractId);
  Future<void> createContractSnapshot(String contractId);

  // 契約比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareContracts(List<String> contractIds);
  Future<Map<String, dynamic>> getContractBenchmarks(String contractType);

  // 契約アラート・通知
  Future<List<Map<String, dynamic>>> getContractAlerts(String scoutId);
  Future<void> setContractAlert(String contractId, String alertType, bool enabled);

  // パフォーマンス最適化
  Future<void> createContractIndexes();
  Future<void> optimizeContractQueries();
  Future<Map<String, dynamic>> getContractPerformanceMetrics();

  // 契約データのエクスポート・インポート
  Future<String> exportContractToJson(String contractId);
  Future<RevenueStream> importContractFromJson(String jsonData);
  Future<void> bulkImportContracts(List<String> jsonDataList);

  // 契約データのバックアップ・復元
  Future<void> backupContractData(String contractId);
  Future<void> restoreContractData(String contractId, String backupId);
  Future<List<Map<String, dynamic>>> getContractBackups(String contractId);
}
