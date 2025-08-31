import '../entities/player_statistics.dart';
import '../entities/team_statistics.dart';
import '../entities/scouting_analytics.dart';

abstract class StatisticsRepository {
  // 選手統計の基本的なCRUD操作
  Future<void> savePlayerStatistics(PlayerStatistics playerStats);
  Future<PlayerStatistics?> loadPlayerStatistics(String statsId);
  Future<void> deletePlayerStatistics(String statsId);
  Future<bool> hasPlayerStatisticsData();

  // チーム統計の基本的なCRUD操作
  Future<void> saveTeamStatistics(TeamStatistics teamStats);
  Future<TeamStatistics?> loadTeamStatistics(String statsId);
  Future<void> deleteTeamStatistics(String statsId);
  Future<bool> hasTeamStatisticsData();

  // スカウト分析の基本的なCRUD操作
  Future<void> saveScoutingAnalytics(ScoutingAnalytics analytics);
  Future<ScoutingAnalytics?> loadScoutingAnalytics(String analyticsId);
  Future<void> deleteScoutingAnalytics(String analyticsId);
  Future<bool> hasScoutingAnalyticsData();

  // 一括操作
  Future<void> savePlayerStatisticsList(List<PlayerStatistics> playerStatsList);
  Future<List<PlayerStatistics>> loadAllPlayerStatistics();
  Future<void> saveTeamStatisticsList(List<TeamStatistics> teamStatsList);
  Future<List<TeamStatistics>> loadAllTeamStatistics();
  Future<void> saveScoutingAnalyticsList(List<ScoutingAnalytics> analyticsList);
  Future<List<ScoutingAnalytics>> loadAllScoutingAnalytics();

  // 選手統計の検索・フィルタリング
  Future<List<PlayerStatistics>> getPlayerStatsByPlayer(String playerId);
  Future<List<PlayerStatistics>> getPlayerStatsByTeam(String teamId);
  Future<List<PlayerStatistics>> getPlayerStatsByCategory(String category);
  Future<List<PlayerStatistics>> getPlayerStatsByPeriod(String period);
  Future<List<PlayerStatistics>> getPlayerStatsByDateRange(DateTime startDate, DateTime endDate);

  // チーム統計の検索・フィルタリング
  Future<List<TeamStatistics>> getTeamStatsByTeam(String teamId);
  Future<List<TeamStatistics>> getTeamStatsByLeague(String leagueType);
  Future<List<TeamStatistics>> getTeamStatsBySeason(int season);
  Future<List<TeamStatistics>> getTeamStatsByDateRange(DateTime startDate, DateTime endDate);

  // スカウト分析の検索・フィルタリング
  Future<List<ScoutingAnalytics>> getAnalyticsByPlayer(String playerId);
  Future<List<ScoutingAnalytics>> getAnalyticsByScout(String scoutId);
  Future<List<ScoutingAnalytics>> getAnalyticsByType(String analysisType);
  Future<List<ScoutingAnalytics>> getAnalyticsByPeriod(String analysisPeriod);
  Future<List<ScoutingAnalytics>> getAnalyticsByDateRange(DateTime startDate, DateTime endDate);

  // 統計計算・集計
  Future<Map<String, dynamic>> calculatePlayerAverages(String playerId, String period);
  Future<Map<String, dynamic>> calculateTeamAverages(String teamId, int season);
  Future<Map<String, dynamic>> calculateLeagueAverages(String leagueType, int season);
  Future<List<Map<String, dynamic>>> getPlayerRankings(String statCategory, String period, int limit);
  Future<List<Map<String, dynamic>>> getTeamRankings(String statCategory, int season, int limit);

  // 履歴データの管理
  Future<List<PlayerStatistics>> getPlayerStatsHistory(String playerId, String period);
  Future<List<TeamStatistics>> getTeamStatsHistory(String teamId, int season);
  Future<List<ScoutingAnalytics>> getAnalyticsHistory(String playerId, String analysisType);

  // 統計の更新・同期
  Future<void> updatePlayerStatsFromGame(String playerId, Map<String, dynamic> gameStats);
  Future<void> updateTeamStatsFromGame(String teamId, Map<String, dynamic> gameStats);
  Future<void> updateAnalyticsFromScouting(String playerId, Map<String, dynamic> scoutingData);

  // データ整合性・検証
  Future<bool> validatePlayerStatistics();
  Future<bool> validateTeamStatistics();
  Future<bool> validateScoutingAnalytics();
  Future<void> cleanupOldStatistics(int daysToKeep);
  Future<void> recalculateAllStatistics();

  // 統計レポート生成
  Future<Map<String, dynamic>> generatePlayerReport(String playerId, String period);
  Future<Map<String, dynamic>> generateTeamReport(String teamId, int season);
  Future<Map<String, dynamic>> generateScoutingReport(String playerId, String analysisType);
  Future<Map<String, dynamic>> generateLeagueReport(String leagueType, int season);

  // パフォーマンス最適化
  Future<void> createStatisticsIndexes();
  Future<void> optimizeStatisticsQueries();
  Future<Map<String, dynamic>> getStatisticsPerformanceMetrics();
}
