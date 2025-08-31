import 'dart:async';
import '../../../core/domain/entities/revenue_stream.dart';
import '../../../core/domain/repositories/contract_repository.dart';

class ContractManager {
  final ContractRepository _repository;
  final StreamController<List<RevenueStream>> _contractsController = StreamController<List<RevenueStream>>.broadcast();
  final StreamController<RevenueStream?> _currentContractController = StreamController<RevenueStream?>.broadcast();
  final StreamController<Map<String, dynamic>> _contractStatsController = StreamController<Map<String, dynamic>>.broadcast();

  ContractManager(this._repository);

  // ストリーム
  Stream<List<RevenueStream>> get contractsStream => _contractsController.stream;
  Stream<RevenueStream?> get currentContractStream => _currentContractController.stream;
  Stream<Map<String, dynamic>> get contractStatsStream => _contractStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllContracts();
  }

  Future<void> _loadAllContracts() async {
    if (await _repository.hasContractData()) {
      final contracts = await _repository.getAllContracts();
      _contractsController.add(contracts);
    }
  }

  // 契約の管理
  Future<void> createContract({
    required String scoutId,
    required String scoutName,
    required String name,
    required String description,
    required ContractType contractType,
    required CustomerType customerType,
    required String customerName,
    required double contractValue,
    required Map<String, dynamic> terms,
  }) async {
    final contract = RevenueStream.initial(
      scoutId: scoutId,
      scoutName: scoutName,
      name: name,
      description: description,
      contractType: contractType,
      customerType: customerType,
      customerName: customerName,
      contractValue: contractValue,
    ).updateTerms(terms);
    
    await _repository.saveContract(contract);
    await _loadAllContracts();
  }

  Future<void> updateContract(RevenueStream contract) async {
    await _repository.saveContract(contract);
    await _loadAllContracts();
  }

  Future<void> deleteContract(String contractId) async {
    await _repository.deleteContract(contractId);
    await _loadAllContracts();
  }

  Future<RevenueStream?> getContract(String contractId) async {
    return await _repository.loadContract(contractId);
  }

  Future<List<RevenueStream>> getContractsByScoutId(String scoutId) async {
    return await _repository.getContractsByScoutId(scoutId);
  }

  Future<List<RevenueStream>> getAllContracts() async {
    return await _repository.getAllContracts();
  }

  // 契約交渉の管理
  Future<void> startNegotiation(String contractId) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedContract = contract.updateStatus(ContractStatus.negotiation);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  Future<void> updateNegotiationTerms(String contractId, Map<String, dynamic> newTerms) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedContract = contract.updateTerms(newTerms);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  Future<void> acceptContract(String contractId) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedContract = contract.updateStatus(ContractStatus.active);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  Future<void> rejectContract(String contractId, String reason) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedTerms = Map<String, dynamic>.from(contract.terms);
      updatedTerms['rejectionReason'] = reason;
      updatedTerms['rejectionDate'] = DateTime.now().toIso8601String();
      
      final updatedContract = contract.updateTerms(updatedTerms);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  // 契約の更新・延長
  Future<void> renewContract(String contractId, {
    required DateTime newEndDate,
    required DateTime newRenewalDate,
    Map<String, dynamic>? updatedTerms,
  }) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      RevenueStream updatedContract = contract.extendContract(newEndDate, newRenewalDate);
      
      if (updatedTerms != null) {
        updatedContract = updatedContract.updateTerms(updatedTerms);
      }
      
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  // 契約の修正
  Future<void> amendContract(String contractId, Map<String, dynamic> amendments) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedTerms = Map<String, dynamic>.from(contract.terms);
      updatedTerms['amendments'] = amendments;
      updatedTerms['amendmentDate'] = DateTime.now().toIso8601String();
      
      final updatedContract = contract.updateTerms(updatedTerms);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  // 契約の一時停止・再開
  Future<void> suspendContract(String contractId, String reason, DateTime? resumeDate) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedContract = contract.suspendContract(reason, resumeDate);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  Future<void> resumeContract(String contractId) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedContract = contract.resumeContract();
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  // 契約の終了
  Future<void> terminateContract(String contractId, String reason) async {
    final contract = await _repository.loadContract(contractId);
    if (contract != null) {
      final updatedTerms = Map<String, dynamic>.from(contract.terms);
      updatedTerms['terminationReason'] = reason;
      updatedTerms['terminationDate'] = DateTime.now().toIso8601String();
      
      final updatedContract = contract.updateTerms(updatedTerms);
      await _repository.saveContract(updatedContract);
      await _loadAllContracts();
      
      // 統計の更新
      await _updateContractStats(contractId);
    }
  }

  // 契約統計情報
  Future<Map<String, dynamic>> getContractStatistics(String scoutId) async {
    return await _repository.getContractStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getNegotiationStatistics(String scoutId) async {
    return await _repository.getNegotiationStatistics(scoutId);
  }

  Future<Map<String, dynamic>> getContractPerformanceStatistics(String contractId) async {
    return await _repository.getContractPerformanceStatistics(contractId);
  }

  // 契約分析・洞察
  Future<Map<String, dynamic>> getContractAnalysis(String contractId) async {
    return await _repository.getContractAnalysis(contractId);
  }

  Future<Map<String, dynamic>> getNegotiationAnalysis(String contractId) async {
    return await _repository.getNegotiationAnalysis(contractId);
  }

  Future<Map<String, dynamic>> getContractRiskAssessment(String contractId) async {
    return await _repository.getContractRiskAssessment(contractId);
  }

  // 契約レポート
  Future<Map<String, dynamic>> generateContractReport(String contractId) async {
    return await _repository.generateContractReport(contractId);
  }

  Future<Map<String, dynamic>> generateNegotiationReport(String contractId) async {
    return await _repository.generateNegotiationReport(contractId);
  }

  Future<Map<String, dynamic>> generateContractSummary(String scoutId) async {
    return await _repository.generateContractSummary(scoutId);
  }

  // 契約データの検証・整合性
  Future<bool> validateContractData() async {
    return await _repository.validateContractData();
  }

  Future<void> recalculateContractMetrics(String contractId) async {
    await _repository.recalculateContractMetrics(contractId);
    await _updateContractStats(contractId);
  }

  Future<void> cleanupOldContractData(String contractId, int daysToKeep) async {
    await _repository.cleanupOldContractData(contractId, daysToKeep);
    await _updateContractStats(contractId);
  }

  // 契約履歴
  Future<List<Map<String, dynamic>>> getContractHistory(String contractId) async {
    return await _repository.getContractHistory(contractId);
  }

  Future<void> createContractSnapshot(String contractId) async {
    await _repository.createContractSnapshot(contractId);
  }

  // 契約比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareContracts(List<String> contractIds) async {
    return await _repository.compareContracts(contractIds);
  }

  Future<Map<String, dynamic>> getContractBenchmarks(String contractType) async {
    return await _repository.getContractBenchmarks(contractType);
  }

  // 契約アラート・通知
  Future<List<Map<String, dynamic>>> getContractAlerts(String scoutId) async {
    return await _repository.getContractAlerts(scoutId);
  }

  Future<void> setContractAlert(String contractId, String alertType, bool enabled) async {
    await _repository.setContractAlert(contractId, alertType, enabled);
  }

  // 契約データの検索・フィルタリング
  Future<List<RevenueStream>> searchContractsByKeyword(String keyword) async {
    return await _repository.searchContractsByKeyword(keyword);
  }

  Future<List<RevenueStream>> getContractsByType(String contractType) async {
    return await _repository.getContractsByType(contractType);
  }

  Future<List<RevenueStream>> getContractsByStatus(String status) async {
    return await _repository.getContractsByStatus(status);
  }

  Future<List<RevenueStream>> getContractsByCustomerType(String customerType) async {
    return await _repository.getContractsByCustomerType(customerType);
  }

  Future<List<RevenueStream>> getContractsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getContractsByDateRange(startDate, endDate);
  }

  // 一括操作
  Future<void> saveContractList(List<RevenueStream> contracts) async {
    await _repository.saveContractList(contracts);
    await _loadAllContracts();
  }

  Future<void> bulkUpdateContracts(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateContracts(updates);
    await _loadAllContracts();
  }

  // パフォーマンス最適化
  Future<void> createContractIndexes() async {
    await _repository.createContractIndexes();
  }

  Future<void> optimizeContractQueries() async {
    await _repository.optimizeContractQueries();
  }

  Future<Map<String, dynamic>> getContractPerformanceMetrics() async {
    return await _repository.getContractPerformanceMetrics();
  }

  // 契約データのエクスポート・インポート
  Future<String> exportContractToJson(String contractId) async {
    return await _repository.exportContractToJson(contractId);
  }

  Future<RevenueStream> importContractFromJson(String jsonData) async {
    final contract = await _repository.importContractFromJson(jsonData);
    await _loadAllContracts();
    return contract;
  }

  Future<void> bulkImportContracts(List<String> jsonDataList) async {
    await _repository.bulkImportContracts(jsonDataList);
    await _loadAllContracts();
  }

  // 契約データのバックアップ・復元
  Future<void> backupContractData(String contractId) async {
    await _repository.backupContractData(contractId);
  }

  Future<void> restoreContractData(String contractId, String backupId) async {
    await _repository.restoreContractData(contractId, backupId);
    await _loadAllContracts();
  }

  Future<List<Map<String, dynamic>>> getContractBackups(String contractId) async {
    return await _repository.getContractBackups(contractId);
  }

  // 契約計算ヘルパー
  double calculateContractValue(RevenueStream contract) {
    return contract.contractValue;
  }

  double calculateMonthlyRevenue(RevenueStream contract) {
    return contract.monthlyRevenue;
  }

  double calculateTotalRevenue(RevenueStream contract) {
    return contract.totalRevenue;
  }

  bool isContractActive(RevenueStream contract) {
    return contract.isContractActive;
  }

  bool isRenewable(RevenueStream contract) {
    return contract.isRenewable;
  }

  bool isExpired(RevenueStream contract) {
    return contract.isExpired;
  }

  int? getRemainingDays(RevenueStream contract) {
    return contract.remainingDays;
  }

  double calculateProjectedMonthlyRevenue(RevenueStream contract) {
    return contract.projectedMonthlyRevenue;
  }

  double calculateProjectedAnnualRevenue(RevenueStream contract) {
    return contract.projectedAnnualRevenue;
  }

  // 統計の更新
  Future<void> _updateContractStats(String contractId) async {
    final stats = await _repository.getContractStatistics(contractId);
    _contractStatsController.add(stats);
  }

  // リソース解放
  void dispose() {
    _contractsController.close();
    _currentContractController.close();
    _contractStatsController.close();
  }
}
