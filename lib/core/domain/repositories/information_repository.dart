import '../entities/information_share.dart';

abstract class InformationRepository {
  // 情報共有の基本的なCRUD操作
  Future<void> saveInformationShare(InformationShare information);
  Future<InformationShare?> loadInformationShare(String informationId);
  Future<void> deleteInformationShare(String informationId);
  Future<bool> hasInformationShareData();

  // 情報の一括操作
  Future<void> saveInformationList(List<InformationShare> informationList);
  Future<List<InformationShare>> loadAllInformationShares();

  // スカウトIDによる情報の取得
  Future<List<InformationShare>> getInformationByOwnerScout(String scoutId);
  Future<List<InformationShare>> getInformationSharedWithScout(String scoutId);

  // 情報タイプによる検索
  Future<List<InformationShare>> getInformationByType(String informationType);
  Future<List<InformationShare>> getInformationByQuality(String quality);
  Future<List<InformationShare>> getInformationByPermission(String permission);

  // 情報の検索・フィルタリング
  Future<List<InformationShare>> searchInformationByKeyword(String keyword);
  Future<List<InformationShare>> getInformationByDateRange(DateTime startDate, DateTime endDate);
  Future<List<InformationShare>> getInformationByTags(List<String> tags);

  // 情報の共有管理
  Future<void> shareInformationWithScout(String informationId, String scoutId, String scoutName);
  Future<void> unshareInformationWithScout(String informationId, String scoutId);
  Future<List<String>> getInformationSharedScouts(String informationId);

  // 情報の公開設定
  Future<void> setInformationPublic(String informationId, bool isPublic);
  Future<List<InformationShare>> getPublicInformation();

  // 情報の価値評価
  Future<Map<String, dynamic>> getInformationValueMetrics(String informationId);
  Future<List<Map<String, dynamic>>> getTopValueInformation(int limit);
  Future<double> calculateInformationValue(String informationId);

  // 情報の統計情報
  Future<Map<String, dynamic>> getInformationStatistics(String scoutId);
  Future<Map<String, dynamic>> getInformationTrends(String period);
  Future<Map<String, dynamic>> getInformationMarketAnalysis();

  // 情報の比較分析
  Future<List<Map<String, dynamic>>> compareInformation(List<String> informationIds);
  Future<Map<String, dynamic>> getInformationCorrelations(String informationId);

  // 情報の有効期限管理
  Future<void> setInformationExpiration(String informationId, DateTime expirationDate);
  Future<List<InformationShare>> getExpiredInformation();
  Future<void> cleanupExpiredInformation();

  // 情報の閲覧・共有統計
  Future<void> incrementInformationViewCount(String informationId);
  Future<Map<String, dynamic>> getInformationEngagementMetrics(String informationId);

  // 情報の品質管理
  Future<void> updateInformationQuality(String informationId, String quality);
  Future<void> updateInformationValueScore(String informationId, double valueScore);

  // データ整合性・検証
  Future<bool> validateInformationData();
  Future<void> cleanupOldInformation(int daysToKeep);
  Future<void> recalculateInformationScores();

  // 情報の履歴管理
  Future<List<Map<String, dynamic>>> getInformationVersionHistory(String informationId);
  Future<void> createInformationSnapshot(String informationId);

  // 情報のテンプレート管理
  Future<List<Map<String, dynamic>>> getInformationTemplates();
  Future<void> saveInformationTemplate(Map<String, dynamic> template);
  Future<void> deleteInformationTemplate(String templateId);

  // 情報の推奨システム
  Future<List<String>> getRecommendedInformation(String scoutId);
  Future<List<String>> getTrendingInformation();
  Future<List<String>> getPersonalizedInformation(String scoutId);

  // パフォーマンス最適化
  Future<void> createInformationIndexes();
  Future<void> optimizeInformationQueries();
  Future<Map<String, dynamic>> getInformationPerformanceMetrics();

  // 情報のエクスポート・インポート
  Future<String> exportInformationToJson(String informationId);
  Future<InformationShare> importInformationFromJson(String jsonData);
  Future<void> bulkImportInformation(List<String> jsonDataList);

  // 情報のセキュリティ・プライバシー
  Future<bool> validateInformationAccess(String informationId, String scoutId);
  Future<void> auditInformationAccess(String informationId, String scoutId, String action);
  Future<List<Map<String, dynamic>>> getInformationAccessLogs(String informationId);
}
