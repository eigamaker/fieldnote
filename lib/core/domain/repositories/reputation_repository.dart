import '../entities/scout_reputation.dart';

abstract class ReputationRepository {
  // スカウトレピュテーションの基本的なCRUD操作
  Future<void> saveScoutReputation(ScoutReputation reputation);
  Future<ScoutReputation?> loadScoutReputation(String reputationId);
  Future<void> deleteScoutReputation(String reputationId);
  Future<bool> hasScoutReputationData();

  // スカウトIDによるレピュテーションの取得
  Future<ScoutReputation?> getReputationByScoutId(String scoutId);
  Future<List<ScoutReputation>> getAllScoutReputations();

  // レピュテーションレベルによる検索
  Future<List<ScoutReputation>> getReputationsByLevel(String reputationLevel);
  Future<List<ScoutReputation>> getReputationsByScoreRange(double minScore, double maxScore);

  // レピュテーションの検索・フィルタリング
  Future<List<ScoutReputation>> searchReputationsByKeyword(String keyword);
  Future<List<ScoutReputation>> getReputationsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<ScoutReputation>> getVerifiedReputations();

  // カテゴリ別評価の管理
  Future<void> updateCategoryScore(String reputationId, String category, double score);
  Future<void> addCategoryRating(String reputationId, String category, int rating);
  Future<Map<String, dynamic>> getCategoryScores(String reputationId);

  // レピュテーションの更新・計算
  Future<void> updateOverallScore(String reputationId);
  Future<void> recalculateReputationLevel(String reputationId);
  Future<void> updateReputationHistory(String reputationId, String key, dynamic value);

  // 実績・推薦の管理
  Future<void> addAchievement(String reputationId, String achievement);
  Future<void> addEndorsement(String reputationId, String endorsement);
  Future<List<String>> getAchievements(String reputationId);
  Future<List<String>> getEndorsements(String reputationId);

  // レピュテーションの検証
  Future<void> setVerificationStatus(String reputationId, bool verified, String notes);
  Future<List<ScoutReputation>> getUnverifiedReputations();

  // レピュテーションの統計情報
  Future<Map<String, dynamic>> getReputationStatistics();
  Future<Map<String, dynamic>> getReputationTrends(String period);
  Future<Map<String, dynamic>> getCategoryStatistics(String category);

  // レピュテーションの比較分析
  Future<List<Map<String, dynamic>>> compareReputations(List<String> reputationIds);
  Future<Map<String, dynamic>> getReputationCorrelations(String reputationId);

  // レピュテーションのランキング
  Future<List<Map<String, dynamic>>> getTopReputations(int limit);
  Future<List<Map<String, dynamic>>> getReputationsByCategory(String category, int limit);
  Future<List<Map<String, dynamic>>> getMostImprovedReputations(int limit);

  // レピュテーションの推奨システム
  Future<List<String>> getRecommendedScouts(String scoutId);
  Future<List<String>> getPotentialMentors(String scoutId);
  Future<List<String>> getSimilarReputations(String reputationId);

  // レピュテーションの履歴管理
  Future<List<Map<String, dynamic>>> getReputationHistory(String reputationId);
  Future<void> createReputationSnapshot(String reputationId);
  Future<Map<String, dynamic>> getReputationGrowthAnalysis(String reputationId);

  // データ整合性・検証
  Future<bool> validateReputationData();
  Future<void> cleanupOldReputations(int daysToKeep);
  Future<void> recalculateAllReputations();

  // レピュテーションの分析・洞察
  Future<Map<String, dynamic>> getReputationInsights(String reputationId);
  Future<Map<String, dynamic>> getReputationPredictions(String reputationId);
  Future<Map<String, dynamic>> getReputationRiskAssessment(String reputationId);

  // レピュテーションの監査・ログ
  Future<List<Map<String, dynamic>>> getReputationAuditLogs(String reputationId);
  Future<void> logReputationChange(String reputationId, String changeType, Map<String, dynamic> details);

  // 一括操作
  Future<void> saveReputationList(List<ScoutReputation> reputations);
  Future<void> bulkUpdateReputations(List<Map<String, dynamic>> updates);

  // パフォーマンス最適化
  Future<void> createReputationIndexes();
  Future<void> optimizeReputationQueries();
  Future<Map<String, dynamic>> getReputationPerformanceMetrics();

  // レピュテーションのエクスポート・インポート
  Future<String> exportReputationToJson(String reputationId);
  Future<ScoutReputation> importReputationFromJson(String jsonData);
  Future<void> bulkImportReputations(List<String> jsonDataList);

  // レピュテーションの通知・アラート
  Future<List<Map<String, dynamic>>> getReputationAlerts(String scoutId);
  Future<void> setReputationAlert(String reputationId, String alertType, bool enabled);
}
