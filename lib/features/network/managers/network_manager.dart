import 'dart:async';
import '../../../core/domain/entities/scout_network.dart';
import '../../../core/domain/repositories/network_repository.dart';

class NetworkManager {
  final NetworkRepository _repository;
  final StreamController<List<ScoutNetwork>> _networksController = StreamController<List<ScoutNetwork>>.broadcast();
  final StreamController<ScoutNetwork?> _currentNetworkController = StreamController<ScoutNetwork?>.broadcast();
  final StreamController<List<NetworkConnection>> _connectionsController = StreamController<List<NetworkConnection>>.broadcast();

  NetworkManager(this._repository);

  // ストリーム
  Stream<List<ScoutNetwork>> get networksStream => _networksController.stream;
  Stream<ScoutNetwork?> get currentNetworkStream => _currentNetworkController.stream;
  Stream<List<NetworkConnection>> get connectionsStream => _connectionsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllNetworks();
  }

  Future<void> _loadAllNetworks() async {
    if (await _repository.hasScoutNetworkData()) {
      final networks = await _repository.getAllScoutNetworks();
      _networksController.add(networks);
    }
  }

  // スカウトネットワークの管理
  Future<void> createScoutNetwork(String scoutId, String scoutName) async {
    final network = ScoutNetwork.initial(
      scoutId: scoutId,
      scoutName: scoutName,
    );
    
    await _repository.saveScoutNetwork(network);
    await _loadAllNetworks();
  }

  Future<void> updateScoutNetwork(ScoutNetwork network) async {
    await _repository.saveScoutNetwork(network);
    await _loadAllNetworks();
  }

  Future<void> deleteScoutNetwork(String networkId) async {
    await _repository.deleteScoutNetwork(networkId);
    await _loadAllNetworks();
  }

  Future<ScoutNetwork?> getScoutNetwork(String networkId) async {
    return await _repository.loadScoutNetwork(networkId);
  }

  Future<ScoutNetwork?> getNetworkByScoutId(String scoutId) async {
    return await _repository.getNetworkByScoutId(scoutId);
  }

  Future<List<ScoutNetwork>> getAllNetworks() async {
    return await _repository.getAllScoutNetworks();
  }

  // ネットワーク接続の管理
  Future<void> addNetworkConnection(String networkId, NetworkConnection connection) async {
    final network = await _repository.loadScoutNetwork(networkId);
    if (network != null) {
      final updatedNetwork = network.addConnection(connection);
      await _repository.saveScoutNetwork(updatedNetwork);
      await _loadAllNetworks();
      
      // 接続の更新を通知
      final allConnections = await _repository.getConnectionsByScoutId(connection.connectedScoutId);
      _connectionsController.add(allConnections);
    }
  }

  Future<void> updateNetworkConnection(String networkId, NetworkConnection connection) async {
    final network = await _repository.loadScoutNetwork(networkId);
    if (network != null) {
      final updatedNetwork = network.updateConnection(connection.id, connection);
      await _repository.saveScoutNetwork(updatedNetwork);
      await _loadAllNetworks();
      
      // 接続の更新を通知
      final allConnections = await _repository.getConnectionsByScoutId(connection.connectedScoutId);
      _connectionsController.add(allConnections);
    }
  }

  Future<void> removeNetworkConnection(String networkId, String connectionId) async {
    final network = await _repository.loadScoutNetwork(networkId);
    if (network != null) {
      final updatedNetwork = network.removeConnection(connectionId);
      await _repository.saveScoutNetwork(updatedNetwork);
      await _loadAllNetworks();
    }
  }

  Future<List<NetworkConnection>> getConnectionsByScoutId(String scoutId) async {
    return await _repository.getConnectionsByScoutId(scoutId);
  }

  Future<List<NetworkConnection>> getConnectionsByType(String connectionType) async {
    return await _repository.getConnectionsByType(connectionType);
  }

  Future<List<NetworkConnection>> getConnectionsByTrustLevel(String trustLevel) async {
    return await _repository.getConnectionsByTrustLevel(trustLevel);
  }

  // ネットワーク統計の更新
  Future<void> updateNetworkStats(String networkId, Map<String, dynamic> stats) async {
    final network = await _repository.loadScoutNetwork(networkId);
    if (network != null) {
      final updatedNetwork = network.updateNetworkStats(stats);
      await _repository.saveScoutNetwork(updatedNetwork);
      await _loadAllNetworks();
    }
  }

  // ネットワーク検索・フィルタリング
  Future<List<ScoutNetwork>> searchNetworksByKeyword(String keyword) async {
    return await _repository.searchNetworksByKeyword(keyword);
  }

  Future<List<ScoutNetwork>> getNetworksByConnectionType(String connectionType) async {
    return await _repository.getNetworksByConnectionType(connectionType);
  }

  Future<List<ScoutNetwork>> getNetworksByTrustLevel(String trustLevel) async {
    return await _repository.getNetworksByTrustLevel(trustLevel);
  }

  Future<List<ScoutNetwork>> getNetworksByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getNetworksByDateRange(startDate, endDate);
  }

  // ネットワーク分析
  Future<Map<String, dynamic>> getNetworkStatistics(String networkId) async {
    return await _repository.getNetworkStatistics(networkId);
  }

  Future<Map<String, dynamic>> getNetworkStrengthAnalysis(String networkId) async {
    return await _repository.getNetworkStrengthAnalysis(networkId);
  }

  Future<List<Map<String, dynamic>>> getTopNetworks(int limit) async {
    return await _repository.getTopNetworks(limit);
  }

  // ネットワーク推奨
  Future<List<String>> getRecommendedConnections(String scoutId) async {
    return await _repository.getRecommendedConnections(scoutId);
  }

  Future<List<String>> getPotentialMentors(String scoutId) async {
    return await _repository.getPotentialMentors(scoutId);
  }

  Future<List<String>> getPotentialStudents(String scoutId) async {
    return await _repository.getPotentialStudents(scoutId);
  }

  // ネットワークの強度計算
  double calculateNetworkStrength(ScoutNetwork network) {
    return network.networkStrength;
  }

  double calculateNetworkDiversity(ScoutNetwork network) {
    return network.networkDiversity;
  }

  int getActiveConnectionCount(ScoutNetwork network) {
    return network.activeConnectionCount;
  }

  // 接続の強度計算
  double calculateConnectionStrength(NetworkConnection connection) {
    return connection.connectionStrength;
  }

  bool isConnectionValid(NetworkConnection connection) {
    return connection.isConnectionValid;
  }

  // 信頼できる接続の取得
  List<NetworkConnection> getTrustedConnections(ScoutNetwork network) {
    return network.trustedConnections;
  }

  List<NetworkConnection> getNetworkConnectionsByType(ScoutNetwork network, NetworkConnectionType type) {
    return network.getConnectionsByType(type);
  }

  // データ整合性・検証
  Future<bool> validateNetworkData() async {
    return await _repository.validateNetworkData();
  }

  Future<void> cleanupInactiveConnections(int daysInactive) async {
    await _repository.cleanupInactiveConnections(daysInactive);
    await _loadAllNetworks();
  }

  Future<void> recalculateNetworkStats() async {
    await _repository.recalculateNetworkStats();
    await _loadAllNetworks();
  }

  // ネットワーク履歴
  Future<List<Map<String, dynamic>>> getNetworkHistory(String networkId) async {
    return await _repository.getNetworkHistory(networkId);
  }

  Future<List<Map<String, dynamic>>> getConnectionHistory(String connectionId) async {
    return await _repository.getConnectionHistory(connectionId);
  }

  // 一括操作
  Future<void> saveNetworkList(List<ScoutNetwork> networks) async {
    await _repository.saveNetworkList(networks);
    await _loadAllNetworks();
  }

  Future<void> deleteExpiredNetworks(DateTime expirationDate) async {
    await _repository.deleteExpiredNetworks(expirationDate);
    await _loadAllNetworks();
  }

  // パフォーマンス最適化
  Future<void> createNetworkIndexes() async {
    await _repository.createNetworkIndexes();
  }

  Future<void> optimizeNetworkQueries() async {
    await _repository.optimizeNetworkQueries();
  }

  Future<Map<String, dynamic>> getNetworkPerformanceMetrics() async {
    return await _repository.getNetworkPerformanceMetrics();
  }

  // リソース解放
  void dispose() {
    _networksController.close();
    _currentNetworkController.close();
    _connectionsController.close();
  }
}
