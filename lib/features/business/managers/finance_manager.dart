import 'dart:async';
import '../../../core/domain/entities/business_finance.dart';
import '../../../core/domain/repositories/finance_repository.dart';

class FinanceManager {
  final FinanceRepository _repository;
  final StreamController<List<BusinessFinance>> _financesController = StreamController<List<BusinessFinance>>.broadcast();
  final StreamController<BusinessFinance?> _currentFinanceController = StreamController<BusinessFinance?>.broadcast();
  final StreamController<Map<String, dynamic>> _financeStatsController = StreamController<Map<String, dynamic>>.broadcast();

  FinanceManager(this._repository);

  // ストリーム
  Stream<List<BusinessFinance>> get financesStream => _financesController.stream;
  Stream<BusinessFinance?> get currentFinanceStream => _currentFinanceController.stream;
  Stream<Map<String, dynamic>> get financeStatsStream => _financeStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllFinances();
  }

  Future<void> _loadAllFinances() async {
    if (await _repository.hasBusinessFinanceData()) {
      final finances = await _repository.getAllBusinessFinances();
      _financesController.add(finances);
    }
  }

  // ビジネス財務の管理
  Future<void> createBusinessFinance(String scoutId, String scoutName) async {
    final finance = BusinessFinance.initial(
      scoutId: scoutId,
      scoutName: scoutName,
    );
    
    await _repository.saveBusinessFinance(finance);
    await _loadAllFinances();
  }

  Future<void> updateBusinessFinance(BusinessFinance finance) async {
    await _repository.saveBusinessFinance(finance);
    await _loadAllFinances();
  }

  Future<void> deleteBusinessFinance(String financeId) async {
    await _repository.deleteBusinessFinance(financeId);
    await _loadAllFinances();
  }

  Future<BusinessFinance?> getBusinessFinance(String financeId) async {
    return await _repository.loadBusinessFinance(financeId);
  }

  Future<BusinessFinance?> getFinanceByScoutId(String scoutId) async {
    return await _repository.getFinanceByScoutId(scoutId);
  }

  Future<List<BusinessFinance>> getAllFinances() async {
    return await _repository.getAllBusinessFinances();
  }

  // 収入・支出の管理
  Future<void> addRevenue(String financeId, RevenueType type, double amount) async {
    final finance = await _repository.loadBusinessFinance(financeId);
    if (finance != null) {
      final updatedFinance = finance.addRevenue(type, amount);
      await _repository.saveBusinessFinance(updatedFinance);
      await _loadAllFinances();
      
      // 統計の更新
      await _updateFinanceStats(financeId);
    }
  }

  Future<void> addExpense(String financeId, ExpenseType type, double amount) async {
    final finance = await _repository.loadBusinessFinance(financeId);
    if (finance != null) {
      final updatedFinance = finance.addExpense(type, amount);
      await _repository.saveBusinessFinance(updatedFinance);
      await _loadAllFinances();
      
      // 統計の更新
      await _updateFinanceStats(financeId);
    }
  }

  Future<void> addTransaction(String financeId, {
    required String description,
    required double amount,
    required bool isIncome,
    required String category,
  }) async {
    final finance = await _repository.loadBusinessFinance(financeId);
    if (finance != null) {
      final updatedFinance = finance.addTransaction(
        description: description,
        amount: amount,
        isIncome: isIncome,
        category: category,
      );
      await _repository.saveBusinessFinance(updatedFinance);
      await _loadAllFinances();
      
      // 統計の更新
      await _updateFinanceStats(financeId);
    }
  }

  // 財務統計情報
  Future<Map<String, dynamic>> getFinanceStatistics(String scoutId) async {
    return await _repository.getFinanceStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getRevenueBreakdown(String financeId) async {
    return await _repository.getRevenueBreakdown(financeId);
  }

  Future<Map<String, dynamic>> getExpenseBreakdown(String financeId) async {
    return await _repository.getExpenseBreakdown(financeId);
  }

  Future<Map<String, dynamic>> getCashFlowAnalysis(String financeId) async {
    return await _repository.getCashFlowAnalysis(financeId);
  }

  // 財務分析・予測
  Future<Map<String, dynamic>> getFinancialHealthAnalysis(String financeId) async {
    return await _repository.getFinancialHealthAnalysis(financeId);
  }

  Future<Map<String, dynamic>> getProfitabilityAnalysis(String financeId) async {
    return await _repository.getProfitabilityAnalysis(financeId);
  }

  Future<Map<String, dynamic>> getGrowthTrendAnalysis(String financeId) async {
    return await _repository.getGrowthTrendAnalysis(financeId);
  }

  Future<Map<String, dynamic>> getRiskAssessment(String financeId) async {
    return await _repository.getRiskAssessment(financeId);
  }

  // 財務レポート
  Future<Map<String, dynamic>> generateMonthlyReport(String financeId, DateTime month) async {
    return await _repository.generateMonthlyReport(financeId, month);
  }

  Future<Map<String, dynamic>> generateAnnualReport(String financeId, int year) async {
    return await _repository.generateAnnualReport(financeId, year);
  }

  Future<Map<String, dynamic>> generateCashFlowReport(String financeId, DateTime startDate, DateTime endDate) async {
    return await _repository.generateCashFlowReport(financeId, startDate, endDate);
  }

  // 財務データの検証・整合性
  Future<bool> validateFinanceData() async {
    return await _repository.validateFinanceData();
  }

  Future<void> recalculateFinancialMetrics(String financeId) async {
    await _repository.recalculateFinancialMetrics(financeId);
    await _updateFinanceStats(financeId);
  }

  Future<void> cleanupOldTransactions(String financeId, int daysToKeep) async {
    await _repository.cleanupOldTransactions(financeId, daysToKeep);
    await _updateFinanceStats(financeId);
  }

  // 財務履歴
  Future<List<Map<String, dynamic>>> getTransactionHistory(String financeId) async {
    return await _repository.getTransactionHistory(financeId);
  }

  Future<List<Map<String, dynamic>>> getFinanceHistory(String financeId) async {
    return await _repository.getFinanceHistory(financeId);
  }

  Future<void> createFinanceSnapshot(String financeId) async {
    await _repository.createFinanceSnapshot(financeId);
  }

  // 財務目標・予算管理
  Future<void> setFinancialGoals(String financeId, Map<String, dynamic> goals) async {
    await _repository.setFinancialGoals(financeId, goals);
    await _updateFinanceStats(financeId);
  }

  Future<Map<String, dynamic>> getFinancialGoals(String financeId) async {
    return await _repository.getFinancialGoals(financeId);
  }

  Future<void> updateBudget(String financeId, Map<String, dynamic> budget) async {
    await _repository.updateBudget(financeId, budget);
    await _updateFinanceStats(financeId);
  }

  // 財務アラート・通知
  Future<List<Map<String, dynamic>>> getFinancialAlerts(String scoutId) async {
    return await _repository.getFinancialAlerts(scoutId);
  }

  Future<void> setFinancialAlert(String financeId, String alertType, bool enabled) async {
    await _repository.setFinancialAlert(financeId, alertType, enabled);
  }

  Future<void> setBalanceThreshold(String financeId, double threshold) async {
    await _repository.setBalanceThreshold(financeId, threshold);
  }

  // 財務データの検索・フィルタリング
  Future<List<BusinessFinance>> searchFinancesByKeyword(String keyword) async {
    return await _repository.searchFinancesByKeyword(keyword);
  }

  Future<List<BusinessFinance>> getFinancesByStatus(String status) async {
    return await _repository.getFinancesByStatus(status);
  }

  Future<List<BusinessFinance>> getFinancesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getFinancesByDateRange(startDate, endDate);
  }

  Future<List<BusinessFinance>> getFinancesByBalanceRange(double minBalance, double maxBalance) async {
    return await _repository.getFinancesByBalanceRange(minBalance, maxBalance);
  }

  // 一括操作
  Future<void> saveFinanceList(List<BusinessFinance> finances) async {
    await _repository.saveFinanceList(finances);
    await _loadAllFinances();
  }

  Future<void> bulkUpdateFinances(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateFinances(updates);
    await _loadAllFinances();
  }

  // パフォーマンス最適化
  Future<void> createFinanceIndexes() async {
    await _repository.createFinanceIndexes();
  }

  Future<void> optimizeFinanceQueries() async {
    await _repository.optimizeFinanceQueries();
  }

  Future<Map<String, dynamic>> getFinancePerformanceMetrics() async {
    return await _repository.getFinancePerformanceMetrics();
  }

  // 財務データのエクスポート・インポート
  Future<String> exportFinanceToJson(String financeId) async {
    return await _repository.exportFinanceToJson(financeId);
  }

  Future<BusinessFinance> importFinanceFromJson(String jsonData) async {
    final finance = await _repository.importFinanceFromJson(jsonData);
    await _loadAllFinances();
    return finance;
  }

  Future<void> bulkImportFinances(List<String> jsonDataList) async {
    await _repository.bulkImportFinances(jsonDataList);
    await _loadAllFinances();
  }

  // 財務データのバックアップ・復元
  Future<void> backupFinanceData(String financeId) async {
    await _repository.backupFinanceData(financeId);
  }

  Future<void> restoreFinanceData(String financeId, String backupId) async {
    await _repository.restoreFinanceData(financeId, backupId);
    await _loadAllFinances();
  }

  Future<List<Map<String, dynamic>>> getFinanceBackups(String financeId) async {
    return await _repository.getFinanceBackups(financeId);
  }

  // 財務計算ヘルパー
  double calculateProfitMargin(BusinessFinance finance) {
    return finance.calculatedProfitMargin;
  }

  FinancialStatus calculateFinancialStatus(BusinessFinance finance) {
    return finance.calculatedFinancialStatus;
  }

  double calculateCashFlow(BusinessFinance finance) {
    return finance.cashFlow;
  }

  double calculateProfitability(BusinessFinance finance) {
    return finance.profitability;
  }

  double calculateEfficiency(BusinessFinance finance) {
    return finance.efficiency;
  }

  double calculateStability(BusinessFinance finance) {
    return finance.stability;
  }

  double calculateGrowthRate(BusinessFinance finance) {
    return finance.growthRate;
  }

  double calculateFinancialHealthScore(BusinessFinance finance) {
    return finance.financialHealthScore;
  }

  double calculateRevenueDiversity(BusinessFinance finance) {
    return finance.revenueDiversity;
  }

  double calculateExpenseOptimization(BusinessFinance finance) {
    return finance.expenseOptimization;
  }

  // 統計の更新
  Future<void> _updateFinanceStats(String financeId) async {
    final stats = await _repository.getFinanceStatistics(financeId);
    _financeStatsController.add(stats);
  }

  // リソース解放
  void dispose() {
    _financesController.close();
    _currentFinanceController.close();
    _financeStatsController.close();
  }
}
