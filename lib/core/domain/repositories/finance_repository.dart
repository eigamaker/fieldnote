import '../entities/business_finance.dart';

abstract class FinanceRepository {
  // ビジネス財務の基本的なCRUD操作
  Future<void> saveBusinessFinance(BusinessFinance finance);
  Future<BusinessFinance?> loadBusinessFinance(String financeId);
  Future<void> deleteBusinessFinance(String financeId);
  Future<bool> hasBusinessFinanceData();

  // スカウトIDによる財務データの取得
  Future<BusinessFinance?> getFinanceByScoutId(String scoutId);
  Future<List<BusinessFinance>> getAllBusinessFinances();

  // 財務データの一括操作
  Future<void> saveFinanceList(List<BusinessFinance> finances);
  Future<void> bulkUpdateFinances(List<Map<String, dynamic>> updates);

  // 財務データの検索・フィルタリング
  Future<List<BusinessFinance>> searchFinancesByKeyword(String keyword);
  Future<List<BusinessFinance>> getFinancesByStatus(String status);
  Future<List<BusinessFinance>> getFinancesByDateRange(DateTime startDate, DateTime endDate);
  Future<List<BusinessFinance>> getFinancesByBalanceRange(double minBalance, double maxBalance);

  // 収入・支出の管理
  Future<void> addRevenue(String financeId, String revenueType, double amount);
  Future<void> addExpense(String financeId, String expenseType, double amount);
  Future<void> addTransaction(String financeId, Map<String, dynamic> transaction);

  // 財務統計情報
  Future<Map<String, dynamic>> getFinanceStatistics(String scoutId);
  Future<Map<String, dynamic>> getRevenueBreakdown(String financeId);
  Future<Map<String, dynamic>> getExpenseBreakdown(String financeId);
  Future<Map<String, dynamic>> getCashFlowAnalysis(String financeId);

  // 財務分析・予測
  Future<Map<String, dynamic>> getFinancialHealthAnalysis(String financeId);
  Future<Map<String, dynamic>> getProfitabilityAnalysis(String financeId);
  Future<Map<String, dynamic>> getGrowthTrendAnalysis(String financeId);
  Future<Map<String, dynamic>> getRiskAssessment(String financeId);

  // 財務レポート
  Future<Map<String, dynamic>> generateMonthlyReport(String financeId, DateTime month);
  Future<Map<String, dynamic>> generateAnnualReport(String financeId, int year);
  Future<Map<String, dynamic>> generateCashFlowReport(String financeId, DateTime startDate, DateTime endDate);

  // 財務データの検証・整合性
  Future<bool> validateFinanceData();
  Future<void> recalculateFinancialMetrics(String financeId);
  Future<void> cleanupOldTransactions(String financeId, int daysToKeep);

  // 財務履歴
  Future<List<Map<String, dynamic>>> getTransactionHistory(String financeId);
  Future<List<Map<String, dynamic>>> getFinanceHistory(String financeId);
  Future<void> createFinanceSnapshot(String financeId);

  // 財務目標・予算管理
  Future<void> setFinancialGoals(String financeId, Map<String, dynamic> goals);
  Future<Map<String, dynamic>> getFinancialGoals(String financeId);
  Future<void> updateBudget(String financeId, Map<String, dynamic> budget);

  // 財務アラート・通知
  Future<List<Map<String, dynamic>>> getFinancialAlerts(String scoutId);
  Future<void> setFinancialAlert(String financeId, String alertType, bool enabled);
  Future<void> setBalanceThreshold(String financeId, double threshold);

  // パフォーマンス最適化
  Future<void> createFinanceIndexes();
  Future<void> optimizeFinanceQueries();
  Future<Map<String, dynamic>> getFinancePerformanceMetrics();

  // 財務データのエクスポート・インポート
  Future<String> exportFinanceToJson(String financeId);
  Future<BusinessFinance> importFinanceFromJson(String jsonData);
  Future<void> bulkImportFinances(List<String> jsonDataList);

  // 財務データのバックアップ・復元
  Future<void> backupFinanceData(String financeId);
  Future<void> restoreFinanceData(String financeId, String backupId);
  Future<List<Map<String, dynamic>>> getFinanceBackups(String financeId);
}
