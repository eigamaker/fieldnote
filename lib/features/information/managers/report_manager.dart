import 'dart:async';
import '../../../core/domain/entities/scouting_report.dart';
import '../../../core/domain/repositories/report_repository.dart';

class ReportManager {
  final ReportRepository _repository;
  final StreamController<List<ScoutingReport>> _reportsController = StreamController<List<ScoutingReport>>.broadcast();
  final StreamController<ScoutingReport?> _currentReportController = StreamController<ScoutingReport?>.broadcast();
  final StreamController<Map<String, dynamic>> _reportStatsController = StreamController<Map<String, dynamic>>.broadcast();

  ReportManager(this._repository);

  // ストリーム
  Stream<List<ScoutingReport>> get reportsStream => _reportsController.stream;
  Stream<ScoutingReport?> get currentReportStream => _currentReportController.stream;
  Stream<Map<String, dynamic>> get reportStatsStream => _reportStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllReports();
  }

  Future<void> _loadAllReports() async {
    if (await _repository.hasScoutingReportData()) {
      final reports = await _repository.loadAllScoutingReports();
      _reportsController.add(reports);
    }
  }

  // スカウトレポートの管理
  Future<void> createScoutingReport({
    required String title,
    required String playerId,
    required String playerName,
    required String scoutId,
    required String scoutName,
  }) async {
    final report = ScoutingReport.initial(
      title: title,
      playerId: playerId,
      playerName: playerName,
      scoutId: scoutId,
      scoutName: scoutName,
    );
    
    await _repository.saveScoutingReport(report);
    await _loadAllReports();
  }

  Future<void> updateScoutingReport(ScoutingReport report) async {
    await _repository.saveScoutingReport(report);
    await _loadAllReports();
  }

  Future<void> deleteScoutingReport(String reportId) async {
    await _repository.deleteScoutingReport(reportId);
    await _loadAllReports();
  }

  Future<ScoutingReport?> getScoutingReport(String reportId) async {
    return await _repository.loadScoutingReport(reportId);
  }

  Future<List<ScoutingReport>> getAllReports() async {
    return await _repository.loadAllScoutingReports();
  }

  // スカウトIDによるレポートの取得
  Future<List<ScoutingReport>> getReportsByScoutId(String scoutId) async {
    return await _repository.getReportsByScoutId(scoutId);
  }

  Future<List<ScoutingReport>> getReportsByPlayerId(String playerId) async {
    return await _repository.getReportsByPlayerId(playerId);
  }

  // レポートステータスによる検索
  Future<List<ScoutingReport>> getReportsByStatus(String status) async {
    return await _repository.getReportsByStatus(status);
  }

  Future<List<ScoutingReport>> getReportsByConfidence(String confidence) async {
    return await _repository.getReportsByConfidence(confidence);
  }

  // レポートの検索・フィルタリング
  Future<List<ScoutingReport>> searchReportsByKeyword(String keyword) async {
    return await _repository.searchReportsByKeyword(keyword);
  }

  Future<List<ScoutingReport>> getReportsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getReportsByDateRange(startDate, endDate);
  }

  Future<List<ScoutingReport>> getReportsByTags(List<String> tags) async {
    return await _repository.getReportsByTags(tags);
  }

  // レポートの共有管理
  Future<void> shareReportWithScout(String reportId, String scoutId) async {
    await _repository.shareReportWithScout(reportId, scoutId);
    await _loadAllReports();
  }

  Future<void> unshareReportWithScout(String reportId, String scoutId) async {
    await _repository.unshareReportWithScout(reportId, scoutId);
    await _loadAllReports();
  }

  Future<List<String>> getReportSharedScouts(String reportId) async {
    return await _repository.getReportSharedScouts(reportId);
  }

  // レポートの公開設定
  Future<void> setReportPublic(String reportId, bool isPublic) async {
    await _repository.setReportPublic(reportId, isPublic);
    await _loadAllReports();
  }

  Future<List<ScoutingReport>> getPublicReports() async {
    return await _repository.getPublicReports();
  }

  // レポートの品質評価
  Future<Map<String, dynamic>> getReportQualityMetrics(String reportId) async {
    return await _repository.getReportQualityMetrics(reportId);
  }

  Future<List<Map<String, dynamic>>> getTopQualityReports(int limit) async {
    return await _repository.getTopQualityReports(limit);
  }

  // レポートの統計情報
  Future<Map<String, dynamic>> getReportStatistics(String scoutId) async {
    return await _repository.getReportStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getPlayerReportHistory(String playerId) async {
    return await _repository.getPlayerReportHistory(playerId);
  }

  Future<Map<String, dynamic>> getScoutReportSummary(String scoutId) async {
    return await _repository.getScoutReportSummary(scoutId);
  }

  // レポートの比較分析
  Future<List<Map<String, dynamic>>> compareReports(List<String> reportIds) async {
    return await _repository.compareReports(reportIds);
  }

  Future<Map<String, dynamic>> getReportTrends(String scoutId, String period) async {
    return await _repository.getReportTrends(scoutId, period);
  }

  // レポートのアーカイブ管理
  Future<void> archiveReport(String reportId) async {
    await _repository.archiveReport(reportId);
    await _loadAllReports();
  }

  Future<void> restoreReport(String reportId) async {
    await _repository.restoreReport(reportId);
    await _loadAllReports();
  }

  Future<List<ScoutingReport>> getArchivedReports() async {
    return await _repository.getArchivedReports();
  }

  // レポートの検証・レビュー
  Future<void> markReportAsReviewed(String reportId) async {
    await _repository.markReportAsReviewed(reportId);
    await _loadAllReports();
  }

  Future<void> updateReportConfidence(String reportId, ReportConfidence confidence) async {
    final report = await getScoutingReport(reportId);
    if (report != null) {
      final updatedReport = report.updateConfidence(confidence);
      await updateScoutingReport(updatedReport);
    }
  }

  // レポートの履歴管理
  Future<List<Map<String, dynamic>>> getReportVersionHistory(String reportId) async {
    return await _repository.getReportVersionHistory(reportId);
  }

  Future<void> createReportSnapshot(String reportId) async {
    await _repository.createReportSnapshot(reportId);
  }

  // レポートのテンプレート管理
  Future<List<Map<String, dynamic>>> getReportTemplates() async {
    return await _repository.getReportTemplates();
  }

  Future<void> saveReportTemplate(Map<String, dynamic> template) async {
    await _repository.saveReportTemplate(template);
  }

  Future<void> deleteReportTemplate(String templateId) async {
    await _repository.deleteReportTemplate(templateId);
  }

  // レポートのエクスポート・インポート
  Future<String> exportReportToJson(String reportId) async {
    return await _repository.exportReportToJson(reportId);
  }

  Future<ScoutingReport> importReportFromJson(String jsonData) async {
    return await _repository.importReportFromJson(jsonData);
  }

  Future<void> bulkImportReports(List<String> jsonDataList) async {
    await _repository.bulkImportReports(jsonDataList);
    await _loadAllReports();
  }

  // データ整合性・検証
  Future<bool> validateReportData() async {
    return await _repository.validateReportData();
  }

  Future<void> cleanupOldReports(int daysToKeep) async {
    await _repository.cleanupOldReports(daysToKeep);
    await _loadAllReports();
  }

  Future<void> recalculateReportScores() async {
    await _repository.recalculateReportScores();
    await _loadAllReports();
  }

  // パフォーマンス最適化
  Future<void> createReportIndexes() async {
    await _repository.createReportIndexes();
  }

  Future<void> optimizeReportQueries() async {
    await _repository.optimizeReportQueries();
  }

  Future<Map<String, dynamic>> getReportPerformanceMetrics() async {
    return await _repository.getReportPerformanceMetrics();
  }

  // レポート計算ヘルパー
  double calculateReportQuality(ScoutingReport report) {
    return report.qualityScore;
  }

  double calculateReportFreshness(ScoutingReport report) {
    return report.freshnessScore;
  }

  double calculateOverallScore(ScoutingReport report) {
    return report.overallScore;
  }

  bool isReportValid(ScoutingReport report) {
    return report.isReportValid;
  }

  bool isReportComplete(ScoutingReport report) {
    return report.isReportComplete;
  }

  String getReportCategory(ScoutingReport report) {
    return report.status.name;
  }

  // レポートの更新ヘルパー
  Future<void> updateReportStatus(String reportId, ReportStatus status) async {
    final report = await getScoutingReport(reportId);
    if (report != null) {
      final updatedReport = report.updateStatus(status);
      await updateScoutingReport(updatedReport);
    }
  }

  Future<void> updateExecutiveSummary(String reportId, String summary) async {
    final report = await getScoutingReport(reportId);
    if (report != null) {
      final updatedReport = report.updateExecutiveSummary(summary);
      await updateScoutingReport(updatedReport);
    }
  }

  Future<void> updateDetailedAnalysis(String reportId, String analysis) async {
    final report = await getScoutingReport(reportId);
    if (report != null) {
      final updatedReport = report.updateDetailedAnalysis(analysis);
      await updateScoutingReport(updatedReport);
    }
  }

  // リソース解放
  void dispose() {
    _reportsController.close();
    _currentReportController.close();
    _reportStatsController.close();
  }
}
