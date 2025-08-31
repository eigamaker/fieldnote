import '../entities/pennant_race.dart';
import '../entities/league_standings.dart';

abstract class PennantRaceRepository {
  // ペナントレース関連
  Future<void> savePennantRace(PennantRace pennantRace);
  Future<PennantRace?> loadPennantRace(String pennantRaceId);
  Future<List<PennantRace>> loadAllPennantRaces();
  Future<PennantRace?> loadActivePennantRace();
  Future<PennantRace?> loadPennantRaceByYear(int year);
  Future<bool> deletePennantRace(String pennantRaceId);
  Future<bool> pennantRaceExists(String pennantRaceId);
  
  // リーグ順位表関連
  Future<void> saveLeagueStandings(LeagueStandings standings);
  Future<LeagueStandings?> loadLeagueStandings(String standingsId);
  Future<List<LeagueStandings>> loadAllLeagueStandings();
  Future<LeagueStandings?> loadLeagueStandingsByYearAndLeague(int year, LeagueType league);
  Future<LeagueStandings?> loadCurrentLeagueStandings(LeagueType league);
  Future<bool> deleteLeagueStandings(String standingsId);
  Future<bool> leagueStandingsExists(String standingsId);
  
  // 一括操作
  Future<void> savePennantRaces(List<PennantRace> pennantRaces);
  Future<void> saveLeagueStandingsList(List<LeagueStandings> standingsList);
  Future<void> deleteAllPennantRaces();
  Future<void> deleteAllLeagueStandings();
  
  // ペナントレース管理
  Future<bool> startNewSeason(int year, List<String> teamIds);
  Future<bool> advanceWeek(String pennantRaceId);
  Future<bool> updatePhase(String pennantRaceId, SeasonPhase newPhase);
  Future<bool> addGame(String pennantRaceId, String gameId);
  Future<bool> removeGame(String pennantRaceId, String gameId);
  Future<bool> updateTeamStandings(String pennantRaceId, String teamId, Map<String, dynamic> newStats);
  Future<bool> updateSeasonStats(String pennantRaceId, Map<String, dynamic> newStats);
  Future<bool> calculateStandings(String pennantRaceId);
  
  // リーグ順位表管理
  Future<bool> updateTeamStandingsInLeague(String standingsId, String teamId, Map<String, dynamic> newStats);
  Future<bool> updateLeagueStats(String standingsId, Map<String, dynamic> newStats);
  Future<bool> calculateRankings(String standingsId);
  Future<bool> resetSeasonStandings(String standingsId);
  
  // 検索・フィルタリング
  Future<List<PennantRace>> searchPennantRacesByYearRange(int startYear, int endYear);
  Future<List<PennantRace>> searchPennantRacesByPhase(SeasonPhase phase);
  Future<List<LeagueStandings>> searchLeagueStandingsByYearRange(int startYear, int endYear);
  Future<List<LeagueStandings>> searchLeagueStandingsByLeague(LeagueType league);
  
  // 統計・集計
  Future<Map<String, dynamic>> getPennantRaceStatistics(String pennantRaceId);
  Future<Map<String, dynamic>> getLeagueStandingsStatistics(String standingsId);
  Future<Map<String, dynamic>> getSeasonStatistics(int year);
  Future<Map<String, dynamic>> getLeagueStatistics(int year, LeagueType league);
  Future<int> getTotalPennantRaces();
  Future<int> getTotalLeagueStandings();
  Future<int> getActivePennantRacesCount();
  Future<int> getCompletedPennantRacesCount();
  
  // 順位・成績管理
  Future<Map<String, dynamic>> getTeamStandings(String pennantRaceId, String teamId);
  Future<List<Map<String, dynamic>>> getLeagueRankings(String standingsId);
  Future<Map<String, dynamic>> getTeamRecord(String pennantRaceId, String teamId);
  Future<Map<String, dynamic>> getLeagueLeaders(String standingsId, String category);
  
  // スケジュール管理
  Future<List<String>> getWeeklyGames(String pennantRaceId, int week);
  Future<List<String>> getMonthlyGames(String pennantRaceId, int month);
  Future<bool> scheduleGames(String pennantRaceId, List<String> gameIds);
  Future<bool> rescheduleGame(String pennantRaceId, String oldGameId, String newGameId);
  
  // データ整合性
  Future<bool> validatePennantRaceData(PennantRace pennantRace);
  Future<bool> validateLeagueStandingsData(LeagueStandings standings);
  Future<List<String>> getDataIntegrityIssues();
  Future<bool> repairDataIntegrity();
  
  // 履歴・アーカイブ
  Future<List<PennantRace>> getPennantRaceHistory(int year);
  Future<List<LeagueStandings>> getLeagueStandingsHistory(int year, LeagueType league);
  Future<bool> archiveSeason(int year);
  Future<bool> restoreArchivedSeason(int year);
  
  // バックアップ・復元
  Future<bool> createBackup();
  Future<bool> restoreFromBackup(String backupId);
  Future<List<String>> getAvailableBackups();
  Future<bool> deleteBackup(String backupId);
  
  // 同期・連携
  Future<bool> syncWithGameProgress(String pennantRaceId);
  Future<bool> syncWithProfessionalTeams();
  Future<bool> syncWithHighSchoolTournaments();
}
