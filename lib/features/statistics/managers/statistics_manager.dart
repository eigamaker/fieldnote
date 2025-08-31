import 'dart:async';
import '../../../core/domain/entities/player_statistics.dart';
import '../../../core/domain/entities/team_statistics.dart';
import '../../../core/domain/entities/scouting_analytics.dart';
import '../../../core/domain/repositories/statistics_repository.dart';

class StatisticsManager {
  final StatisticsRepository _repository;
  final StreamController<List<PlayerStatistics>> _playerStatsController = StreamController<List<PlayerStatistics>>.broadcast();
  final StreamController<List<TeamStatistics>> _teamStatsController = StreamController<List<TeamStatistics>>.broadcast();
  final StreamController<List<ScoutingAnalytics>> _analyticsController = StreamController<List<ScoutingAnalytics>>.broadcast();

  StatisticsManager(this._repository);

  // ストリーム
  Stream<List<PlayerStatistics>> get playerStatsStream => _playerStatsController.stream;
  Stream<List<TeamStatistics>> get teamStatsStream => _teamStatsController.stream;
  Stream<List<ScoutingAnalytics>> get analyticsStream => _analyticsController.stream;

  // 初期化
  Future<void> initialize() async {
    await _loadAllStatistics();
  }

  Future<void> _loadAllStatistics() async {
    if (await _repository.hasPlayerStatisticsData()) {
      final playerStats = await _repository.loadAllPlayerStatistics();
      _playerStatsController.add(playerStats);
    }

    if (await _repository.hasTeamStatisticsData()) {
      final teamStats = await _repository.loadAllTeamStatistics();
      _teamStatsController.add(teamStats);
    }

    if (await _repository.hasScoutingAnalyticsData()) {
      final analytics = await _repository.loadAllScoutingAnalytics();
      _analyticsController.add(analytics);
    }
  }

  // 選手統計の管理
  Future<void> addPlayerStatistics(PlayerStatistics playerStats) async {
    await _repository.savePlayerStatistics(playerStats);
    final allStats = await _repository.loadAllPlayerStatistics();
    _playerStatsController.add(allStats);
  }

  Future<void> updatePlayerStatistics(PlayerStatistics playerStats) async {
    await _repository.savePlayerStatistics(playerStats);
    final allStats = await _repository.loadAllPlayerStatistics();
    _playerStatsController.add(allStats);
  }

  Future<void> deletePlayerStatistics(String statsId) async {
    await _repository.deletePlayerStatistics(statsId);
    final allStats = await _repository.loadAllPlayerStatistics();
    _playerStatsController.add(allStats);
  }

  Future<PlayerStatistics?> getPlayerStatistics(String statsId) async {
    return await _repository.loadPlayerStatistics(statsId);
  }

  Future<List<PlayerStatistics>> getPlayerStatsByPlayer(String playerId) async {
    return await _repository.getPlayerStatsByPlayer(playerId);
  }

  Future<List<PlayerStatistics>> getPlayerStatsByTeam(String teamId) async {
    return await _repository.getPlayerStatsByTeam(teamId);
  }

  Future<List<PlayerStatistics>> getPlayerStatsByCategory(String category) async {
    return await _repository.getPlayerStatsByCategory(category);
  }

  Future<List<PlayerStatistics>> getPlayerStatsByPeriod(String period) async {
    return await _repository.getPlayerStatsByPeriod(period);
  }

  Future<List<PlayerStatistics>> getPlayerStatsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getPlayerStatsByDateRange(startDate, endDate);
  }

  // チーム統計の管理
  Future<void> addTeamStatistics(TeamStatistics teamStats) async {
    await _repository.saveTeamStatistics(teamStats);
    final allStats = await _repository.loadAllTeamStatistics();
    _teamStatsController.add(allStats);
  }

  Future<void> updateTeamStatistics(TeamStatistics teamStats) async {
    await _repository.saveTeamStatistics(teamStats);
    final allStats = await _repository.loadAllTeamStatistics();
    _teamStatsController.add(allStats);
  }

  Future<void> deleteTeamStatistics(String statsId) async {
    await _repository.deleteTeamStatistics(statsId);
    final allStats = await _repository.loadAllTeamStatistics();
    _teamStatsController.add(allStats);
  }

  Future<TeamStatistics?> getTeamStatistics(String statsId) async {
    return await _repository.loadTeamStatistics(statsId);
  }

  Future<List<TeamStatistics>> getTeamStatsByTeam(String teamId) async {
    return await _repository.getTeamStatsByTeam(teamId);
  }

  Future<List<TeamStatistics>> getTeamStatsByLeague(String leagueType) async {
    return await _repository.getTeamStatsByLeague(leagueType);
  }

  Future<List<TeamStatistics>> getTeamStatsBySeason(int season) async {
    return await _repository.getTeamStatsBySeason(season);
  }

  Future<List<TeamStatistics>> getTeamStatsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getTeamStatsByDateRange(startDate, endDate);
  }

  // スカウト分析の管理
  Future<void> addScoutingAnalytics(ScoutingAnalytics analytics) async {
    await _repository.saveScoutingAnalytics(analytics);
    final allAnalytics = await _repository.loadAllScoutingAnalytics();
    _analyticsController.add(allAnalytics);
  }

  Future<void> updateScoutingAnalytics(ScoutingAnalytics analytics) async {
    await _repository.saveScoutingAnalytics(analytics);
    final allAnalytics = await _repository.loadAllScoutingAnalytics();
    _analyticsController.add(allAnalytics);
  }

  Future<void> deleteScoutingAnalytics(String analyticsId) async {
    await _repository.deleteScoutingAnalytics(analyticsId);
    final allAnalytics = await _repository.loadAllScoutingAnalytics();
    _analyticsController.add(allAnalytics);
  }

  Future<ScoutingAnalytics?> getScoutingAnalytics(String analyticsId) async {
    return await _repository.loadScoutingAnalytics(analyticsId);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsByPlayer(String playerId) async {
    return await _repository.getAnalyticsByPlayer(playerId);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsByScout(String scoutId) async {
    return await _repository.getAnalyticsByScout(scoutId);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsByType(String analysisType) async {
    return await _repository.getAnalyticsByType(analysisType);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsByPeriod(String analysisPeriod) async {
    return await _repository.getAnalyticsByPeriod(analysisPeriod);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getAnalyticsByDateRange(startDate, endDate);
  }

  // 統計計算・集計
  Future<Map<String, dynamic>> calculatePlayerAverages(String playerId, String period) async {
    return await _repository.calculatePlayerAverages(playerId, period);
  }

  Future<Map<String, dynamic>> calculateTeamAverages(String teamId, int season) async {
    return await _repository.calculateTeamAverages(teamId, season);
  }

  Future<Map<String, dynamic>> calculateLeagueAverages(String leagueType, int season) async {
    return await _repository.calculateLeagueAverages(leagueType, season);
  }

  Future<List<Map<String, dynamic>>> getPlayerRankings(String statCategory, String period, int limit) async {
    return await _repository.getPlayerRankings(statCategory, period, limit);
  }

  Future<List<Map<String, dynamic>>> getTeamRankings(String statCategory, int season, int limit) async {
    return await _repository.getTeamRankings(statCategory, season, limit);
  }

  // 履歴データの管理
  Future<List<PlayerStatistics>> getPlayerStatsHistory(String playerId, String period) async {
    return await _repository.getPlayerStatsHistory(playerId, period);
  }

  Future<List<TeamStatistics>> getTeamStatsHistory(String teamId, int season) async {
    return await _repository.getTeamStatsHistory(teamId, season);
  }

  Future<List<ScoutingAnalytics>> getAnalyticsHistory(String playerId, String analysisType) async {
    return await _repository.getAnalyticsHistory(playerId, analysisType);
  }

  // 統計の更新・同期
  Future<void> updatePlayerStatsFromGame(String playerId, Map<String, dynamic> gameStats) async {
    await _repository.updatePlayerStatsFromGame(playerId, gameStats);
    final allStats = await _repository.loadAllPlayerStatistics();
    _playerStatsController.add(allStats);
  }

  Future<void> updateTeamStatsFromGame(String teamId, Map<String, dynamic> gameStats) async {
    await _repository.updateTeamStatsFromGame(teamId, gameStats);
    final allStats = await _repository.loadAllTeamStatistics();
    _teamStatsController.add(allStats);
  }

  Future<void> updateAnalyticsFromScouting(String playerId, Map<String, dynamic> scoutingData) async {
    await _repository.updateAnalyticsFromScouting(playerId, scoutingData);
    final allAnalytics = await _repository.loadAllScoutingAnalytics();
    _analyticsController.add(allAnalytics);
  }

  // 統計レポート生成
  Future<Map<String, dynamic>> generatePlayerReport(String playerId, String period) async {
    return await _repository.generatePlayerReport(playerId, period);
  }

  Future<Map<String, dynamic>> generateTeamReport(String teamId, int season) async {
    return await _repository.generateTeamReport(teamId, season);
  }

  Future<Map<String, dynamic>> generateScoutingReport(String playerId, String analysisType) async {
    return await _repository.generateScoutingReport(playerId, analysisType);
  }

  Future<Map<String, dynamic>> generateLeagueReport(String leagueType, int season) async {
    return await _repository.generateLeagueReport(leagueType, season);
  }

  // データ整合性・検証
  Future<bool> validateAllStatistics() async {
    final playerValid = await _repository.validatePlayerStatistics();
    final teamValid = await _repository.validateTeamStatistics();
    final analyticsValid = await _repository.validateScoutingAnalytics();
    
    return playerValid && teamValid && analyticsValid;
  }

  Future<void> cleanupOldStatistics(int daysToKeep) async {
    await _repository.cleanupOldStatistics(daysToKeep);
    await _loadAllStatistics();
  }

  Future<void> recalculateAllStatistics() async {
    await _repository.recalculateAllStatistics();
    await _loadAllStatistics();
  }

  // リソース解放
  void dispose() {
    _playerStatsController.close();
    _teamStatsController.close();
    _analyticsController.close();
  }
}
