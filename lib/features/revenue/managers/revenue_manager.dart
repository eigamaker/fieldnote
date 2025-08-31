import 'dart:async';
import '../../../core/domain/entities/revenue_stream.dart';
import '../../../core/domain/repositories/revenue_repository.dart';

class RevenueManager {
  final RevenueRepository _repository;
  final StreamController<List<RevenueStream>> _revenuesController = StreamController<List<RevenueStream>>.broadcast();
  final StreamController<RevenueStream?> _currentRevenueController = StreamController<RevenueStream?>.broadcast();
  final StreamController<Map<String, dynamic>> _revenueStatsController = StreamController<Map<String, dynamic>>.broadcast();

  RevenueManager(this._repository);

  // ストリーム
  Stream<List<RevenueStream>> get revenuesStream => _revenuesController.stream;
  Stream<RevenueStream?> get currentRevenueStream => _currentRevenueController.stream;
  Stream<Map<String, dynamic>> get revenueStatsStream => _revenueStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllRevenues();
  }

  Future<void> _loadAllRevenues() async {
    if (await _repository.hasRevenueStreamData()) {
      final revenues = await _repository.getAllRevenueStreams();
      _revenuesController.add(revenues);
    }
  }

  // 収益ストリームの管理
  Future<void> createRevenueStream({
    required String scoutId,
    required String scoutName,
    required String name,
    required String description,
    required ContractType contractType,
    required CustomerType customerType,
    required String customerName,
    required double contractValue,
  }) async {
    final revenue = RevenueStream.initial(
      scoutId: scoutId,
      scoutName: scoutName,
      name: name,
      description: description,
      contractType: contractType,
      customerType: customerType,
      customerName: customerName,
      contractValue: contractValue,
    );
    
    await _repository.saveRevenueStream(revenue);
    await _loadAllRevenues();
  }

  Future<void> updateRevenueStream(RevenueStream revenue) async {
    await _repository.saveRevenueStream(revenue);
    await _loadAllRevenues();
  }

  Future<void> deleteRevenueStream(String revenueId) async {
    await _repository.deleteRevenueStream(revenueId);
    await _loadAllRevenues();
  }

  Future<RevenueStream?> getRevenueStream(String revenueId) async {
    return await _repository.loadRevenueStream(revenueId);
  }

  Future<List<RevenueStream>> getRevenuesByScoutId(String scoutId) async {
    return await _repository.getRevenuesByScoutId(scoutId);
  }

  Future<List<RevenueStream>> getAllRevenues() async {
    return await _repository.getAllRevenueStreams();
  }

  // 契約ステータスの管理
  Future<void> updateContractStatus(String revenueId, ContractStatus newStatus) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.updateStatus(newStatus);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約条件の更新
  Future<void> updateContractTerms(String revenueId, Map<String, dynamic> newTerms) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.updateTerms(newTerms);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // パフォーマンス指標の更新
  Future<void> updatePerformanceMetrics(String revenueId, Map<String, dynamic> newMetrics) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.updatePerformanceMetrics(newMetrics);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 収入履歴の追加
  Future<void> addRevenueRecord(String revenueId, {
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.addRevenueRecord(
        amount: amount,
        description: description,
        date: date,
      );
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約の延長
  Future<void> extendContract(String revenueId, DateTime newEndDate, DateTime newRenewalDate) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.extendContract(newEndDate, newRenewalDate);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約の完了
  Future<void> completeContract(String revenueId) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.completeContract();
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約のキャンセル
  Future<void> cancelContract(String revenueId, String reason) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.cancelContract(reason);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約の一時停止
  Future<void> suspendContract(String revenueId, String reason, DateTime? resumeDate) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.suspendContract(reason, resumeDate);
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 契約の再開
  Future<void> resumeContract(String revenueId) async {
    final revenue = await _repository.loadRevenueStream(revenueId);
    if (revenue != null) {
      final updatedRevenue = revenue.resumeContract();
      await _repository.saveRevenueStream(updatedRevenue);
      await _loadAllRevenues();
      
      // 統計の更新
      await _updateRevenueStats(revenueId);
    }
  }

  // 収益統計情報
  Future<Map<String, dynamic>> getRevenueStatistics(String scoutId) async {
    return await _repository.getRevenueStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getContractStatistics(String revenueId) async {
    return await _repository.getContractStatistics(revenueId);
  }

  Future<Map<String, dynamic>> getCustomerStatistics(String revenueId) async {
    return await _repository.getCustomerStatistics(revenueId);
  }

  Future<Map<String, dynamic>> getPerformanceStatistics(String revenueId) async {
    return await _repository.getPerformanceStatistics(revenueId);
  }

  // 収益分析・予測
  Future<Map<String, dynamic>> getRevenueAnalysis(String revenueId) async {
    return await _repository.getRevenueAnalysis(revenueId);
  }

  Future<Map<String, dynamic>> getProfitabilityAnalysis(String revenueId) async {
    return await _repository.getProfitabilityAnalysis(revenueId);
  }

  Future<Map<String, dynamic>> getGrowthTrendAnalysis(String revenueId) async {
    return await _repository.getGrowthTrendAnalysis(revenueId);
  }

  Future<Map<String, dynamic>> getRiskAssessment(String revenueId) async {
    return await _repository.getRiskAssessment(revenueId);
  }

  // 収益レポート
  Future<Map<String, dynamic>> generateRevenueReport(String revenueId) async {
    return await _repository.generateRevenueReport(revenueId);
  }

  Future<Map<String, dynamic>> generateContractReport(String revenueId) async {
    return await _repository.generateContractReport(revenueId);
  }

  Future<Map<String, dynamic>> generateCustomerReport(String revenueId) async {
    return await _repository.generateCustomerReport(revenueId);
  }

  // 収益データの検証・整合性
  Future<bool> validateRevenueData() async {
    return await _repository.validateRevenueData();
  }

  Future<void> recalculateRevenueMetrics(String revenueId) async {
    await _repository.recalculateRevenueMetrics(revenueId);
    await _updateRevenueStats(revenueId);
  }

  Future<void> cleanupOldRevenueData(String revenueId, int daysToKeep) async {
    await _repository.cleanupOldRevenueData(revenueId, daysToKeep);
    await _updateRevenueStats(revenueId);
  }

  // 収益履歴
  Future<List<Map<String, dynamic>>> getRevenueHistory(String revenueId) async {
    return await _repository.getRevenueHistory(revenueId);
  }

  Future<void> createRevenueSnapshot(String revenueId) async {
    await _repository.createRevenueSnapshot(revenueId);
  }

  // 収益比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareRevenues(List<String> revenueIds) async {
    return await _repository.compareRevenues(revenueIds);
  }

  Future<Map<String, dynamic>> getRevenueBenchmarks(String contractType) async {
    return await _repository.getRevenueBenchmarks(contractType);
  }

  // 収益アラート・通知
  Future<List<Map<String, dynamic>>> getRevenueAlerts(String scoutId) async {
    return await _repository.getRevenueAlerts(scoutId);
  }

  Future<void> setRevenueAlert(String revenueId, String alertType, bool enabled) async {
    await _repository.setRevenueAlert(revenueId, alertType, enabled);
  }

  // 収益データの検索・フィルタリング
  Future<List<RevenueStream>> searchRevenuesByKeyword(String keyword) async {
    return await _repository.searchRevenuesByKeyword(keyword);
  }

  Future<List<RevenueStream>> getRevenuesByContractType(String contractType) async {
    return await _repository.getRevenuesByContractType(contractType);
  }

  Future<List<RevenueStream>> getRevenuesByStatus(String status) async {
    return await _repository.getRevenuesByStatus(status);
  }

  Future<List<RevenueStream>> getRevenuesByCustomerType(String customerType) async {
    return await _repository.getRevenuesByCustomerType(customerType);
  }

  Future<List<RevenueStream>> getRevenuesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getRevenuesByDateRange(startDate, endDate);
  }

  // 一括操作
  Future<void> saveRevenueList(List<RevenueStream> revenues) async {
    await _repository.saveRevenueList(revenues);
    await _loadAllRevenues();
  }

  Future<void> bulkUpdateRevenues(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateRevenues(updates);
    await _loadAllRevenues();
  }

  // パフォーマンス最適化
  Future<void> createRevenueIndexes() async {
    await _repository.createRevenueIndexes();
  }

  Future<void> optimizeRevenueQueries() async {
    await _repository.optimizeRevenueQueries();
  }

  Future<Map<String, dynamic>> getRevenuePerformanceMetrics() async {
    return await _repository.getRevenuePerformanceMetrics();
  }

  // 収益データのエクスポート・インポート
  Future<String> exportRevenueToJson(String revenueId) async {
    return await _repository.exportRevenueToJson(revenueId);
  }

  Future<RevenueStream> importRevenueFromJson(String jsonData) async {
    final revenue = await _repository.importRevenueFromJson(jsonData);
    await _loadAllRevenues();
    return revenue;
  }

  Future<void> bulkImportRevenues(List<String> jsonDataList) async {
    await _repository.bulkImportRevenues(jsonDataList);
    await _loadAllRevenues();
  }

  // 収益データのバックアップ・復元
  Future<void> backupRevenueData(String revenueId) async {
    await _repository.backupRevenueData(revenueId);
  }

  Future<void> restoreRevenueData(String revenueId, String backupId) async {
    await _repository.restoreRevenueData(revenueId, backupId);
    await _loadAllRevenues();
  }

  Future<List<Map<String, dynamic>>> getRevenueBackups(String revenueId) async {
    return await _repository.getRevenueBackups(revenueId);
  }

  // 収益計算ヘルパー
  double calculateProjectedMonthlyRevenue(RevenueStream revenue) {
    return revenue.projectedMonthlyRevenue;
  }

  double calculateProjectedAnnualRevenue(RevenueStream revenue) {
    return revenue.projectedAnnualRevenue;
  }

  double calculateProfitability(RevenueStream revenue) {
    return revenue.profitability;
  }

  double calculateStability(RevenueStream revenue) {
    return revenue.stability;
  }

  double calculateGrowthRate(RevenueStream revenue) {
    return revenue.growthRate;
  }

  double calculateCustomerSatisfaction(RevenueStream revenue) {
    return revenue.customerSatisfaction;
  }

  double calculateOverallContractScore(RevenueStream revenue) {
    return revenue.overallContractScore;
  }

  String getRevenueRiskAssessment(RevenueStream revenue) {
    return revenue.riskAssessment;
  }

  String getPriority(RevenueStream revenue) {
    return revenue.priority;
  }

  bool isContractActive(RevenueStream revenue) {
    return revenue.isContractActive;
  }

  bool isRenewable(RevenueStream revenue) {
    return revenue.isRenewable;
  }

  bool isExpired(RevenueStream revenue) {
    return revenue.isExpired;
  }

  int? getRemainingDays(RevenueStream revenue) {
    return revenue.remainingDays;
  }

  // 統計の更新
  Future<void> _updateRevenueStats(String revenueId) async {
    final stats = await _repository.getRevenueStatistics(revenueId);
    _revenueStatsController.add(stats);
  }

  // リソース解放
  void dispose() {
    _revenuesController.close();
    _currentRevenueController.close();
    _revenueStatsController.close();
  }
}
