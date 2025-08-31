import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/professional_player.dart';
import '../../../core/domain/repositories/professional_repository.dart';

class PlayerCareerManager {
  final ProfessionalRepository _repository;
  final StreamController<List<ProfessionalPlayer>> _playersController;
  final StreamController<ProfessionalPlayer?> _selectedPlayerController;
  final StreamController<Map<String, dynamic>> _playerStatsController;

  PlayerCareerManager(this._repository)
      : _playersController = StreamController<List<ProfessionalPlayer>>.broadcast(),
        _selectedPlayerController = StreamController<ProfessionalPlayer?>.broadcast(),
        _playerStatsController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<List<ProfessionalPlayer>> get playersStream => _playersController.stream;
  Stream<ProfessionalPlayer?> get selectedPlayerStream => _selectedPlayerController.stream;
  Stream<Map<String, dynamic>> get playerStatsStream => _playerStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    try {
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
    } catch (e) {
      print('PlayerCareerManager initialization error: $e');
    }
  }

  // 選手取得
  Future<List<ProfessionalPlayer>> getAllPlayers() async {
    try {
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return players;
    } catch (e) {
      print('Error loading players: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getPlayersByTeam(String teamId) async {
    try {
      return await _repository.loadPlayersByTeam(teamId);
    } catch (e) {
      print('Error loading players by team: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getPlayersByPosition(PlayerPosition position) async {
    try {
      return await _repository.loadPlayersByPosition(position);
    } catch (e) {
      print('Error loading players by position: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getActivePlayers() async {
    try {
      return await _repository.loadActivePlayers();
    } catch (e) {
      print('Error loading active players: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getRetiredPlayers() async {
    try {
      return await _repository.loadRetiredPlayers();
    } catch (e) {
      print('Error loading retired players: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getFreeAgents() async {
    try {
      return await _repository.loadFreeAgents();
    } catch (e) {
      print('Error loading free agents: $e');
      return [];
    }
  }

  Future<ProfessionalPlayer?> getPlayer(String playerId) async {
    try {
      return await _repository.loadPlayer(playerId);
    } catch (e) {
      print('Error loading player: $e');
      return null;
    }
  }

  // 選手作成・更新
  Future<bool> createPlayer(ProfessionalPlayer player) async {
    try {
      if (await _repository.playerExists(player.id)) {
        return false;
      }
      
      await _repository.savePlayer(player);
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error creating player: $e');
      return false;
    }
  }

  Future<bool> updatePlayer(ProfessionalPlayer player) async {
    try {
      await _repository.savePlayer(player);
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error updating player: $e');
      return false;
    }
  }

  Future<bool> deletePlayer(String playerId) async {
    try {
      final success = await _repository.deletePlayer(playerId);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error deleting player: $e');
      return false;
    }
  }

  // 選手選択
  void selectPlayer(ProfessionalPlayer? player) {
    _selectedPlayerController.add(player);
  }

  // キャリア管理
  Future<bool> retirePlayer(String playerId, DateTime retirementDate) async {
    try {
      final success = await _repository.retirePlayer(playerId, retirementDate);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error retiring player: $e');
      return false;
    }
  }

  Future<bool> activatePlayer(String playerId) async {
    try {
      final success = await _repository.activatePlayer(playerId);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error activating player: $e');
      return false;
    }
  }

  Future<bool> suspendPlayer(String playerId) async {
    try {
      final success = await _repository.suspendPlayer(playerId);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error suspending player: $e');
      return false;
    }
  }

  Future<bool> updatePlayerStatus(String playerId, PlayerStatus status) async {
    try {
      final success = await _repository.updatePlayerStatus(playerId, status);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error updating player status: $e');
      return false;
    }
  }

  Future<bool> transferPlayer(String playerId, String newTeamId) async {
    try {
      final success = await _repository.transferPlayer(playerId, newTeamId);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error transferring player: $e');
      return false;
    }
  }

  Future<bool> updatePlayerSalary(String playerId, int newSalary, int newContractYears) async {
    try {
      final success = await _repository.updatePlayerSalary(playerId, newSalary, newContractYears);
      if (success) {
        final players = await _repository.loadAllPlayers();
        _playersController.add(players);
      }
      return success;
    } catch (e) {
      print('Error updating player salary: $e');
      return false;
    }
  }

  // 選手統計更新
  Future<bool> updatePlayerSeasonStats(String playerId, Map<String, dynamic> newStats) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.updateSeasonStats(newStats);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      
      _playerStatsController.add(newStats);
      return true;
    } catch (e) {
      print('Error updating player stats: $e');
      return false;
    }
  }

  Future<bool> updatePlayerCareerStats(String playerId, Map<String, dynamic> newStats) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.updateCareerStats(newStats);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error updating player career stats: $e');
      return false;
    }
  }

  Future<bool> resetPlayerSeasonStats(String playerId) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.resetSeasonStats();
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error resetting player stats: $e');
      return false;
    }
  }

  // 選手能力更新
  Future<bool> updatePlayerAbilities(String playerId, Map<String, int> newAbilities) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.updateAbilities(newAbilities);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error updating player abilities: $e');
      return false;
    }
  }

  // 選手年齢更新
  Future<bool> updatePlayerAge(String playerId, DateTime currentDate) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.updateAge(currentDate);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error updating player age: $e');
      return false;
    }
  }

  // 選手経験値更新
  Future<bool> addPlayerExperience(String playerId, int years) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.addExperience(years);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error adding player experience: $e');
      return false;
    }
  }

  // 選手実績追加
  Future<bool> addPlayerAchievement(String playerId, String achievementType, int count) async {
    try {
      final player = await _repository.loadPlayer(playerId);
      if (player == null) return false;

      final updatedPlayer = player.addAchievement(achievementType, count);
      await _repository.savePlayer(updatedPlayer);
      
      final players = await _repository.loadAllPlayers();
      _playersController.add(players);
      return true;
    } catch (e) {
      print('Error adding player achievement: $e');
      return false;
    }
  }

  // 統計取得
  Future<Map<String, dynamic>> getPlayerStatistics(String playerId) async {
    try {
      return await _repository.getPlayerStatistics(playerId);
    } catch (e) {
      print('Error getting player statistics: $e');
      return {};
    }
  }

  // 検索・フィルタリング
  Future<List<ProfessionalPlayer>> searchPlayers(String query) async {
    try {
      return await _repository.searchPlayersByName(query);
    } catch (e) {
      print('Error searching players: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getPlayersByAgeRange(int minAge, int maxAge) async {
    try {
      return await _repository.loadPlayersByAgeRange(minAge, maxAge);
    } catch (e) {
      print('Error loading players by age range: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getPlayersByExperienceRange(int minExp, int maxExp) async {
    try {
      return await _repository.loadPlayersByExperienceRange(minExp, maxExp);
    } catch (e) {
      print('Error loading players by experience range: $e');
      return [];
    }
  }

  Future<List<ProfessionalPlayer>> getPlayersBySalaryRange(int minSalary, int maxSalary) async {
    try {
      return await _repository.loadPlayersBySalaryRange(minSalary, maxSalary);
    } catch (e) {
      print('Error loading players by salary range: $e');
      return [];
    }
  }

  // データ整合性チェック
  Future<List<String>> getDataIntegrityIssues() async {
    try {
      return await _repository.getDataIntegrityIssues();
    } catch (e) {
      print('Error checking data integrity: $e');
      return [];
    }
  }

  Future<bool> repairDataIntegrity() async {
    try {
      return await _repository.repairDataIntegrity();
    } catch (e) {
      print('Error repairing data integrity: $e');
      return false;
    }
  }

  // リソース解放
  void dispose() {
    _playersController.close();
    _selectedPlayerController.close();
    _playerStatsController.close();
  }
}
