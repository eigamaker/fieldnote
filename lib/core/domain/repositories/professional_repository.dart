import '../entities/professional_team.dart';
import '../entities/professional_player.dart';

abstract class ProfessionalRepository {
  // チーム関連
  Future<void> saveTeam(ProfessionalTeam team);
  Future<ProfessionalTeam?> loadTeam(String teamId);
  Future<List<ProfessionalTeam>> loadAllTeams();
  Future<List<ProfessionalTeam>> loadTeamsByLeague(League league);
  Future<bool> deleteTeam(String teamId);
  Future<bool> teamExists(String teamId);
  
  // 選手関連
  Future<void> savePlayer(ProfessionalPlayer player);
  Future<ProfessionalPlayer?> loadPlayer(String playerId);
  Future<List<ProfessionalPlayer>> loadAllPlayers();
  Future<List<ProfessionalPlayer>> loadPlayersByTeam(String teamId);
  Future<List<ProfessionalPlayer>> loadPlayersByPosition(PlayerPosition position);
  Future<List<ProfessionalPlayer>> loadActivePlayers();
  Future<List<ProfessionalPlayer>> loadRetiredPlayers();
  Future<List<ProfessionalPlayer>> loadFreeAgents();
  Future<bool> deletePlayer(String playerId);
  Future<bool> playerExists(String playerId);
  
  // 一括操作
  Future<void> saveTeams(List<ProfessionalTeam> teams);
  Future<void> savePlayers(List<ProfessionalPlayer> players);
  Future<void> deleteAllTeams();
  Future<void> deleteAllPlayers();
  
  // 検索・フィルタリング
  Future<List<ProfessionalPlayer>> searchPlayersByName(String name);
  Future<List<ProfessionalPlayer>> loadPlayersByAgeRange(int minAge, int maxAge);
  Future<List<ProfessionalPlayer>> loadPlayersByExperienceRange(int minExp, int maxExp);
  Future<List<ProfessionalPlayer>> loadPlayersBySalaryRange(int minSalary, int maxSalary);
  
  // 統計・集計
  Future<Map<String, dynamic>> getTeamStatistics(String teamId);
  Future<Map<String, dynamic>> getPlayerStatistics(String playerId);
  Future<Map<String, dynamic>> getLeagueStatistics(League league);
  Future<int> getTotalTeams();
  Future<int> getTotalPlayers();
  Future<int> getActivePlayersCount();
  Future<int> getRetiredPlayersCount();
  
  // チーム管理
  Future<bool> addPlayerToTeam(String teamId, String playerId);
  Future<bool> removePlayerFromTeam(String teamId, String playerId);
  Future<bool> transferPlayer(String playerId, String newTeamId);
  Future<List<String>> getTeamPlayerIds(String teamId);
  Future<int> getTeamPlayerCount(String teamId);
  
  // 選手キャリア管理
  Future<bool> retirePlayer(String playerId, DateTime retirementDate);
  Future<bool> activatePlayer(String playerId);
  Future<bool> suspendPlayer(String playerId);
  Future<bool> updatePlayerStatus(String playerId, PlayerStatus status);
  Future<bool> updatePlayerSalary(String playerId, int newSalary, int newContractYears);
  
  // データ整合性
  Future<bool> validateTeamData(ProfessionalTeam team);
  Future<bool> validatePlayerData(ProfessionalPlayer player);
  Future<List<String>> getDataIntegrityIssues();
  Future<bool> repairDataIntegrity();
  
  // バックアップ・復元
  Future<bool> createBackup();
  Future<bool> restoreFromBackup(String backupId);
  Future<List<String>> getAvailableBackups();
  Future<bool> deleteBackup(String backupId);
}
