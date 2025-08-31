import '../entities/scout_network.dart';

abstract class NetworkRepository {
  // スカウトネットワークの基本的なCRUD操作
  Future<void> saveScoutNetwork(ScoutNetwork network);
  Future<ScoutNetwork?> loadScoutNetwork(String networkId);
  Future<void> deleteScoutNetwork(String networkId);
  Future<bool> hasScoutNetworkData();

  // スカウトIDによるネットワークの取得
  Future<ScoutNetwork?> getNetworkByScoutId(String scoutId);
  Future<List<ScoutNetwork>> getAllScoutNetworks();

  // ネットワーク接続の管理
  Future<void> addNetworkConnection(String networkId, NetworkConnection connection);
  Future<void> updateNetworkConnection(String networkId, NetworkConnection connection);
  Future<void> removeNetworkConnection(String networkId, String connectionId);

  // ネットワーク統計の更新
  Future<void> updateNetworkStats(String networkId, Map<String, dynamic> stats);

  // ネットワーク検索・フィルタリング
  Future<List<ScoutNetwork>> searchNetworksByKeyword(String keyword);
  Future<List<ScoutNetwork>> getNetworksByConnectionType(String connectionType);
  Future<List<ScoutNetwork>> getNetworksByTrustLevel(String trustLevel);
  Future<List<ScoutNetwork>> getNetworksByDateRange(DateTime startDate, DateTime endDate);

  // 接続関係の検索
  Future<List<NetworkConnection>> getConnectionsByScoutId(String scoutId);
  Future<List<NetworkConnection>> getConnectionsByType(String connectionType);
  Future<List<NetworkConnection>> getConnectionsByTrustLevel(String trustLevel);

  // ネットワーク分析
  Future<Map<String, dynamic>> getNetworkStatistics(String networkId);
  Future<Map<String, dynamic>> getNetworkStrengthAnalysis(String networkId);
  Future<List<Map<String, dynamic>>> getTopNetworks(int limit);

  // ネットワーク推奨
  Future<List<String>> getRecommendedConnections(String scoutId);
  Future<List<String>> getPotentialMentors(String scoutId);
  Future<List<String>> getPotentialStudents(String scoutId);

  // データ整合性・検証
  Future<bool> validateNetworkData();
  Future<void> cleanupInactiveConnections(int daysInactive);
  Future<void> recalculateNetworkStats();

  // ネットワーク履歴
  Future<List<Map<String, dynamic>>> getNetworkHistory(String networkId);
  Future<List<Map<String, dynamic>>> getConnectionHistory(String connectionId);

  // 一括操作
  Future<void> saveNetworkList(List<ScoutNetwork> networks);
  Future<void> deleteExpiredNetworks(DateTime expirationDate);

  // パフォーマンス最適化
  Future<void> createNetworkIndexes();
  Future<void> optimizeNetworkQueries();
  Future<Map<String, dynamic>> getNetworkPerformanceMetrics();
}
