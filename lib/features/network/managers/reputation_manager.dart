import 'dart:async';
import '../../../core/domain/entities/scout_reputation.dart';
import '../../../core/domain/repositories/reputation_repository.dart';

class ReputationManager {
  final ReputationRepository _repository;
  final StreamController<List<ScoutReputation>> _reputationsController = StreamController<List<ScoutReputation>>.broadcast();
  final StreamController<ScoutReputation?> _currentReputationController = StreamController<ScoutReputation?>.broadcast();
  final StreamController<Map<String, dynamic>> _reputationStatsController = StreamController<Map<String, dynamic>>.broadcast();

  ReputationManager(this._repository);

  // ストリーム
  Stream<List<ScoutReputation>> get reputationsStream => _reputationsController.stream;
  Stream<ScoutReputation?> get currentReputationStream => _currentReputationController.stream;
  Stream<Map<String, dynamic>> get reputationStatsStream => _reputationStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllReputations();
  }

  Future<void> _loadAllReputations() async {
    if (await _repository.hasScoutReputationData()) {
      final reputations = await _repository.getAllScoutReputations();
      _reputationsController.add(reputations);
    }
  }

  // スカウトレピュテーションの管理
  Future<void> createScoutReputation(String scoutId, String scoutName) async {
    final reputation = ScoutReputation.initial(
      scoutId: scoutId,
      scoutName: scoutName,
    );
    
    await _repository.saveScoutReputation(reputation);
    await _loadAllReputations();
  }

  Future<void> updateScoutReputation(ScoutReputation reputation) async {
    await _repository.saveScoutReputation(reputation);
    await _loadAllReputations();
  }

  Future<void> deleteScoutReputation(String reputationId) async {
    await _repository.deleteScoutReputation(reputationId);
    await _loadAllReputations();
  }

  Future<ScoutReputation?> getScoutReputation(String reputationId) async {
    return await _repository.loadScoutReputation(reputationId);
  }

  Future<ScoutReputation?> getReputationByScoutId(String scoutId) async {
    return await _repository.getReputationByScoutId(scoutId);
  }

  Future<List<ScoutReputation>> getAllReputations() async {
    return await _repository.getAllScoutReputations();
  }

  // レピュテーションレベルによる検索
  Future<List<ScoutReputation>> getReputationsByLevel(String reputationLevel) async {
    return await _repository.getReputationsByLevel(reputationLevel);
  }

  Future<List<ScoutReputation>> getReputationsByScoreRange(double minScore, double maxScore) async {
    return await _repository.getReputationsByScoreRange(minScore, maxScore);
  }

  // レピュテーションの検索・フィルタリング
  Future<List<ScoutReputation>> searchReputationsByKeyword(String keyword) async {
    return await _repository.searchReputationsByKeyword(keyword);
  }

  Future<List<ScoutReputation>> getReputationsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getReputationsByDateRange(startDate, endDate);
  }

  Future<List<ScoutReputation>> getVerifiedReputations() async {
    return await _repository.getVerifiedReputations();
  }

  // カテゴリ別評価の管理
  Future<void> updateCategoryScore(String reputationId, String category, double score) async {
    await _repository.updateCategoryScore(reputationId, category, score);
    await _loadAllReputations();
  }

  Future<void> addCategoryRating(String reputationId, String category, int rating) async {
    await _repository.addCategoryRating(reputationId, category, rating);
    await _loadAllReputations();
  }

  Future<Map<String, dynamic>> getCategoryScores(String reputationId) async {
    return await _repository.getCategoryScores(reputationId);
  }

  // レピュテーションの更新・計算
  Future<void> updateOverallScore(String reputationId) async {
    await _repository.updateOverallScore(reputationId);
    await _loadAllReputations();
  }

  Future<void> recalculateReputationLevel(String reputationId) async {
    await _repository.recalculateReputationLevel(reputationId);
    await _loadAllReputations();
  }

  Future<void> updateReputationHistory(String reputationId, String key, dynamic value) async {
    await _repository.updateReputationHistory(reputationId, key, value);
    await _loadAllReputations();
  }

  // 実績・推薦の管理
  Future<void> addAchievement(String reputationId, String achievement) async {
    await _repository.addAchievement(reputationId, achievement);
    await _loadAllReputations();
  }

  Future<void> addEndorsement(String reputationId, String endorsement) async {
    await _repository.addEndorsement(reputationId, endorsement);
    await _loadAllReputations();
  }

  Future<List<String>> getAchievements(String reputationId) async {
    return await _repository.getAchievements(reputationId);
  }

  Future<List<String>> getEndorsements(String reputationId) async {
    return await _repository.getEndorsements(reputationId);
  }

  // レピュテーションの検証
  Future<void> setVerificationStatus(String reputationId, bool verified, String notes) async {
    await _repository.setVerificationStatus(reputationId, verified, notes);
    await _loadAllReputations();
  }

  Future<List<ScoutReputation>> getUnverifiedReputations() async {
    return await _repository.getUnverifiedReputations();
  }

  // レピュテーションの統計情報
  Future<Map<String, dynamic>> getReputationStatistics() async {
    return await _repository.getReputationStatistics();
  }

  Future<Map<String, dynamic>> getReputationTrends(String period) async {
    return await _repository.getReputationTrends(period);
  }

  Future<Map<String, dynamic>> getCategoryStatistics(String category) async {
    return await _repository.getCategoryStatistics(category);
  }

  // レピュテーションの比較分析
  Future<List<Map<String, dynamic>>> compareReputations(List<String> reputationIds) async {
    return await _repository.compareReputations(reputationIds);
  }

  Future<Map<String, dynamic>> getReputationCorrelations(String reputationId) async {
    return await _repository.getReputationCorrelations(reputationId);
  }

  // レピュテーションのランキング
  Future<List<Map<String, dynamic>>> getTopReputations(int limit) async {
    return await _repository.getTopReputations(limit);
  }

  Future<List<Map<String, dynamic>>> getReputationsByCategory(String category, int limit) async {
    return await _repository.getReputationsByCategory(category, limit);
  }

  Future<List<Map<String, dynamic>>> getMostImprovedReputations(int limit) async {
    return await _repository.getMostImprovedReputations(limit);
  }

  // レピュテーションの推奨システム
  Future<List<String>> getRecommendedScouts(String scoutId) async {
    return await _repository.getRecommendedScouts(scoutId);
  }

  Future<List<String>> getPotentialMentors(String scoutId) async {
    return await _repository.getPotentialMentors(scoutId);
  }

  Future<List<String>> getSimilarReputations(String reputationId) async {
    return await _repository.getSimilarReputations(reputationId);
  }

  // レピュテーションの履歴管理
  Future<List<Map<String, dynamic>>> getReputationHistory(String reputationId) async {
    return await _repository.getReputationHistory(reputationId);
  }

  Future<void> createReputationSnapshot(String reputationId) async {
    await _repository.createReputationSnapshot(reputationId);
  }

  Future<Map<String, dynamic>> getReputationGrowthAnalysis(String reputationId) async {
    return await _repository.getReputationGrowthAnalysis(reputationId);
  }

  // レピュテーションの分析・洞察
  Future<Map<String, dynamic>> getReputationInsights(String reputationId) async {
    return await _repository.getReputationInsights(reputationId);
  }

  Future<Map<String, dynamic>> getReputationPredictions(String reputationId) async {
    return await _repository.getReputationPredictions(reputationId);
  }

  Future<Map<String, dynamic>> getReputationRiskAssessment(String reputationId) async {
    return await _repository.getReputationRiskAssessment(reputationId);
  }

  // レピュテーションの監査・ログ
  Future<List<Map<String, dynamic>>> getReputationAuditLogs(String reputationId) async {
    return await _repository.getReputationAuditLogs(reputationId);
  }

  Future<void> logReputationChange(String reputationId, String changeType, Map<String, dynamic> details) async {
    await _repository.logReputationChange(reputationId, changeType, details);
  }

  // データ整合性・検証
  Future<bool> validateReputationData() async {
    return await _repository.validateReputationData();
  }

  Future<void> cleanupOldReputations(int daysToKeep) async {
    await _repository.cleanupOldReputations(daysToKeep);
    await _loadAllReputations();
  }

  Future<void> recalculateAllReputations() async {
    await _repository.recalculateAllReputations();
    await _loadAllReputations();
  }

  // 一括操作
  Future<void> saveReputationList(List<ScoutReputation> reputations) async {
    await _repository.saveReputationList(reputations);
    await _loadAllReputations();
  }

  Future<void> bulkUpdateReputations(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateReputations(updates);
    await _loadAllReputations();
  }

  // パフォーマンス最適化
  Future<void> createReputationIndexes() async {
    await _repository.createReputationIndexes();
  }

  Future<void> optimizeReputationQueries() async {
    await _repository.optimizeReputationQueries();
  }

  Future<Map<String, dynamic>> getReputationPerformanceMetrics() async {
    return await _repository.getReputationPerformanceMetrics();
  }

  // レピュテーションのエクスポート・インポート
  Future<String> exportReputationToJson(String reputationId) async {
    return await _repository.exportReputationToJson(reputationId);
  }

  Future<ScoutReputation> importReputationFromJson(String jsonData) async {
    return await _repository.importReputationFromJson(jsonData);
  }

  Future<void> bulkImportReputations(List<String> jsonDataList) async {
    await _repository.bulkImportReputations(jsonDataList);
    await _loadAllReputations();
  }

  // レピュテーションの通知・アラート
  Future<List<Map<String, dynamic>>> getReputationAlerts(String scoutId) async {
    return await _repository.getReputationAlerts(scoutId);
  }

  Future<void> setReputationAlert(String reputationId, String alertType, bool enabled) async {
    await _repository.setReputationAlert(reputationId, alertType, enabled);
  }

  // レピュテーション計算ヘルパー
  double calculateCredibilityScore(ScoutReputation reputation) {
    return reputation.credibilityScore;
  }

  double calculateInfluenceScore(ScoutReputation reputation) {
    return reputation.influenceScore;
  }

  double calculateExpertiseScore(ScoutReputation reputation) {
    return reputation.expertiseScore;
  }

  double calculateGrowthRate(ScoutReputation reputation) {
    return reputation.growthRate;
  }

  double calculateConsistencyScore(ScoutReputation reputation) {
    return reputation.consistencyScore;
  }

  // リソース解放
  void dispose() {
    _reputationsController.close();
    _currentReputationController.close();
    _reputationStatsController.close();
  }
}
