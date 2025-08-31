import 'dart:async';
import '../../../core/domain/entities/office_management.dart';
import '../../../core/domain/repositories/office_repository.dart';

class OfficeManager {
  final OfficeRepository _repository;
  final StreamController<List<OfficeManagement>> _officesController = StreamController<List<OfficeManagement>>.broadcast();
  final StreamController<OfficeManagement?> _currentOfficeController = StreamController<OfficeManagement?>.broadcast();
  final StreamController<Map<String, dynamic>> _officeStatsController = StreamController<Map<String, dynamic>>.broadcast();

  OfficeManager(this._repository);

  // ストリーム
  Stream<List<OfficeManagement>> get officesStream => _officesController.stream;
  Stream<OfficeManagement?> get currentOfficeStream => _currentOfficeController.stream;
  Stream<Map<String, dynamic>> get officeStatsStream => _officeStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllOffices();
  }

  Future<void> _loadAllOffices() async {
    if (await _repository.hasOfficeManagementData()) {
      final offices = await _repository.getAllOfficeManagements();
      _officesController.add(offices);
    }
  }

  // オフィス管理の管理
  Future<void> createOfficeManagement(String scoutId, String scoutName) async {
    final office = OfficeManagement.initial(
      scoutId: scoutId,
      scoutName: scoutName,
    );
    
    await _repository.saveOfficeManagement(office);
    await _loadAllOffices();
  }

  Future<void> updateOfficeManagement(OfficeManagement office) async {
    await _repository.saveOfficeManagement(office);
    await _loadAllOffices();
  }

  Future<void> deleteOfficeManagement(String officeId) async {
    await _repository.deleteOfficeManagement(officeId);
    await _loadAllOffices();
  }

  Future<OfficeManagement?> getOfficeManagement(String officeId) async {
    return await _repository.loadOfficeManagement(officeId);
  }

  Future<OfficeManagement?> getOfficeByScoutId(String scoutId) async {
    return await _repository.getOfficeByScoutId(scoutId);
  }

  Future<List<OfficeManagement>> getAllOffices() async {
    return await _repository.getAllOfficeManagements();
  }

  // オフィスレベルの管理
  Future<void> upgradeOfficeLevel(String officeId, OfficeLevel newLevel) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.upgradeOfficeLevel(newLevel);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // 場所の変更
  Future<void> changeOfficeLocation(String officeId, String newLocation, double newRent) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.changeLocation(newLocation, newRent);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // 設備の管理
  Future<void> addEquipment(String officeId, EquipmentType type, Map<String, dynamic> equipmentData) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.addEquipment(type, equipmentData);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  Future<void> updateEquipment(String officeId, EquipmentType type, String equipmentId, Map<String, dynamic> newData) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.updateEquipment(type, equipmentId, newData);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  Future<void> removeEquipment(String officeId, EquipmentType type, String equipmentId) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.removeEquipment(type, equipmentId);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // スタッフの管理
  Future<void> addStaff(String officeId, Map<String, dynamic> staffData) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.addStaff(staffData);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  Future<void> updateStaff(String officeId, String staffId, Map<String, dynamic> newData) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.updateStaff(staffId, newData);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  Future<void> removeStaff(String officeId, String staffId) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.removeStaff(staffId);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // 施設の更新
  Future<void> updateFacilities(String officeId, Map<String, dynamic> newFacilities) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.updateFacilities(newFacilities);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // パフォーマンス指標の更新
  Future<void> updatePerformanceMetrics(String officeId, Map<String, dynamic> newMetrics) async {
    final office = await _repository.loadOfficeManagement(officeId);
    if (office != null) {
      final updatedOffice = office.updatePerformanceMetrics(newMetrics);
      await _repository.saveOfficeManagement(updatedOffice);
      await _loadAllOffices();
      
      // 統計の更新
      await _updateOfficeStats(officeId);
    }
  }

  // オフィス統計情報
  Future<Map<String, dynamic>> getOfficeStatistics(String officeId) async {
    return await _repository.getOfficeStatistics(officeId);
  }

  Future<Map<String, dynamic>> getEquipmentStatistics(String officeId) async {
    return await _repository.getEquipmentStatistics(officeId);
  }

  Future<Map<String, dynamic>> getStaffStatistics(String officeId) async {
    return await _repository.getStaffStatistics(officeId);
  }

  Future<Map<String, dynamic>> getFacilityStatistics(String officeId) async {
    return await _repository.getFacilityStatistics(officeId);
  }

  // オフィス分析・洞察
  Future<Map<String, dynamic>> getOfficeEfficiencyAnalysis(String officeId) async {
    return await _repository.getOfficeEfficiencyAnalysis(officeId);
  }

  Future<Map<String, dynamic>> getProductivityAnalysis(String officeId) async {
    return await _repository.getProductivityAnalysis(officeId);
  }

  Future<Map<String, dynamic>> getCostEfficiencyAnalysis(String officeId) async {
    return await _repository.getCostEfficiencyAnalysis(officeId);
  }

  Future<Map<String, dynamic>> getGrowthPotentialAnalysis(String officeId) async {
    return await _repository.getGrowthPotentialAnalysis(officeId);
  }

  // オフィスレポート
  Future<Map<String, dynamic>> generateOfficeReport(String officeId) async {
    return await _repository.generateOfficeReport(officeId);
  }

  Future<Map<String, dynamic>> generateEquipmentReport(String officeId) async {
    return await _repository.generateEquipmentReport(officeId);
  }

  Future<Map<String, dynamic>> generateStaffReport(String officeId) async {
    return await _repository.generateStaffReport(officeId);
  }

  // オフィスデータの検証・整合性
  Future<bool> validateOfficeData() async {
    return await _repository.validateOfficeData();
  }

  Future<void> recalculateOfficeMetrics(String officeId) async {
    await _repository.recalculateOfficeMetrics(officeId);
    await _updateOfficeStats(officeId);
  }

  Future<void> cleanupOldOfficeData(String officeId, int daysToKeep) async {
    await _repository.cleanupOldOfficeData(officeId, daysToKeep);
    await _updateOfficeStats(officeId);
  }

  // オフィス履歴
  Future<List<Map<String, dynamic>>> getOfficeHistory(String officeId) async {
    return await _repository.getOfficeHistory(officeId);
  }

  Future<void> createOfficeSnapshot(String officeId) async {
    await _repository.createOfficeSnapshot(officeId);
  }

  // オフィス比較・ベンチマーク
  Future<List<Map<String, dynamic>>> compareOffices(List<String> officeIds) async {
    return await _repository.compareOffices(officeIds);
  }

  Future<Map<String, dynamic>> getOfficeBenchmarks(String level) async {
    return await _repository.getOfficeBenchmarks(level);
  }

  // オフィスアラート・通知
  Future<List<Map<String, dynamic>>> getOfficeAlerts(String officeId) async {
    return await _repository.getOfficeAlerts(officeId);
  }

  Future<void> setOfficeAlert(String officeId, String alertType, bool enabled) async {
    await _repository.setOfficeAlert(officeId, alertType, enabled);
  }

  // オフィスデータの検索・フィルタリング
  Future<List<OfficeManagement>> searchOfficesByKeyword(String keyword) async {
    return await _repository.searchOfficesByKeyword(keyword);
  }

  Future<List<OfficeManagement>> getOfficesByLevel(String level) async {
    return await _repository.getOfficesByLevel(level);
  }

  Future<List<OfficeManagement>> getOfficesByLocation(String location) async {
    return await _repository.getOfficesByLocation(location);
  }

  Future<List<OfficeManagement>> getOfficesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getOfficesByDateRange(startDate, endDate);
  }

  // 一括操作
  Future<void> saveOfficeList(List<OfficeManagement> offices) async {
    await _repository.saveOfficeList(offices);
    await _loadAllOffices();
  }

  Future<void> bulkUpdateOffices(List<Map<String, dynamic>> updates) async {
    await _repository.bulkUpdateOffices(updates);
    await _loadAllOffices();
  }

  // パフォーマンス最適化
  Future<void> createOfficeIndexes() async {
    await _repository.createOfficeIndexes();
  }

  Future<void> optimizeOfficeQueries() async {
    await _repository.optimizeOfficeQueries();
  }

  Future<Map<String, dynamic>> getOfficePerformanceMetrics() async {
    return await _repository.getOfficePerformanceMetrics();
  }

  // オフィスデータのエクスポート・インポート
  Future<String> exportOfficeToJson(String officeId) async {
    return await _repository.exportOfficeToJson(officeId);
  }

  Future<OfficeManagement> importOfficeFromJson(String jsonData) async {
    final office = await _repository.importOfficeFromJson(jsonData);
    await _loadAllOffices();
    return office;
  }

  Future<void> bulkImportOffices(List<String> jsonDataList) async {
    await _repository.bulkImportOffices(jsonDataList);
    await _loadAllOffices();
  }

  // オフィスデータのバックアップ・復元
  Future<void> backupOfficeData(String officeId) async {
    await _repository.backupOfficeData(officeId);
  }

  Future<void> restoreOfficeData(String officeId, String backupId) async {
    await _repository.restoreOfficeData(officeId, backupId);
    await _loadAllOffices();
  }

  Future<List<Map<String, dynamic>>> getOfficeBackups(String officeId) async {
    return await _repository.getOfficeBackups(officeId);
  }

  // オフィス計算ヘルパー
  double calculateMonthlyFixedCosts(OfficeManagement office) {
    return office.monthlyFixedCosts;
  }

  double calculateTotalEquipmentInvestment(OfficeManagement office) {
    return office.totalEquipmentInvestment;
  }

  double calculateMonthlyPersonnelCosts(OfficeManagement office) {
    return office.monthlyPersonnelCosts;
  }

  double calculateTotalMonthlyCosts(OfficeManagement office) {
    return office.totalMonthlyCosts;
  }

  double calculateOfficeEfficiency(OfficeManagement office) {
    return office.officeEfficiency;
  }

  double calculateProductivityScore(OfficeManagement office) {
    return office.productivityScore;
  }

  double calculateCostEfficiency(OfficeManagement office) {
    return office.costEfficiency;
  }

  double calculateGrowthPotential(OfficeManagement office) {
    return office.growthPotential;
  }

  double calculateOverallOfficeScore(OfficeManagement office) {
    return office.overallOfficeScore;
  }

  List<Map<String, dynamic>> getEquipmentMaintenanceNeeded(OfficeManagement office) {
    return office.equipmentMaintenanceNeeded;
  }

  Map<String, dynamic> getStaffSkillAnalysis(OfficeManagement office) {
    return office.staffSkillAnalysis;
  }

  // 統計の更新
  Future<void> _updateOfficeStats(String officeId) async {
    final stats = await _repository.getOfficeStatistics(officeId);
    _officeStatsController.add(stats);
  }

  // リソース解放
  void dispose() {
    _officesController.close();
    _currentOfficeController.close();
    _officeStatsController.close();
  }
}
