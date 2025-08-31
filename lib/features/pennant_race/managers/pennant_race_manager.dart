import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/pennant_race.dart';
import '../../../core/domain/repositories/pennant_race_repository.dart';

class PennantRaceManager {
  final PennantRaceRepository _repository;
  final StreamController<List<PennantRace>> _pennantRacesController;
  final StreamController<PennantRace?> _activePennantRaceController;
  final StreamController<Map<String, dynamic>> _seasonStatsController;

  PennantRaceManager(this._repository)
      : _pennantRacesController = StreamController<List<PennantRace>>.broadcast(),
        _activePennantRaceController = StreamController<PennantRace?>.broadcast(),
        _seasonStatsController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<List<PennantRace>> get pennantRacesStream => _pennantRacesController.stream;
  Stream<PennantRace?> get activePennantRaceStream => _activePennantRaceController.stream;
  Stream<Map<String, dynamic>> get seasonStatsStream => _seasonStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    try {
      final pennantRaces = await _repository.loadAllPennantRaces();
      _pennantRacesController.add(pennantRaces);
      
      final activeRace = await _repository.loadActivePennantRace();
      _activePennantRaceController.add(activeRace);
    } catch (e) {
      print('PennantRaceManager initialization error: $e');
    }
  }

  // ペナントレース取得
  Future<List<PennantRace>> getAllPennantRaces() async {
    try {
      final pennantRaces = await _repository.loadAllPennantRaces();
      _pennantRacesController.add(pennantRaces);
      return pennantRaces;
    } catch (e) {
      print('Error loading pennant races: $e');
      return [];
    }
  }

  Future<PennantRace?> getActivePennantRace() async {
    try {
      final activeRace = await _repository.loadActivePennantRace();
      _activePennantRaceController.add(activeRace);
      return activeRace;
    } catch (e) {
      print('Error loading active pennant race: $e');
      return null;
    }
  }

  Future<PennantRace?> getPennantRaceByYear(int year) async {
    try {
      return await _repository.loadPennantRaceByYear(year);
    } catch (e) {
      print('Error loading pennant race by year: $e');
      return null;
    }
  }

  Future<PennantRace?> getPennantRace(String pennantRaceId) async {
    try {
      return await _repository.loadPennantRace(pennantRaceId);
    } catch (e) {
      print('Error loading pennant race: $e');
      return null;
    }
  }

  // ペナントレース作成・管理
  Future<bool> startNewSeason(int year, List<String> teamIds) async {
    try {
      final success = await _repository.startNewSeason(year, teamIds);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
        
        final activeRace = await _repository.loadActivePennantRace();
        _activePennantRaceController.add(activeRace);
      }
      return success;
    } catch (e) {
      print('Error starting new season: $e');
      return false;
    }
  }

  Future<bool> createPennantRace(PennantRace pennantRace) async {
    try {
      if (await _repository.pennantRaceExists(pennantRace.id)) {
        return false;
      }
      
      await _repository.savePennantRace(pennantRace);
      final pennantRaces = await _repository.loadAllPennantRaces();
      _pennantRacesController.add(pennantRaces);
      return true;
    } catch (e) {
      print('Error creating pennant race: $e');
      return false;
    }
  }

  Future<bool> updatePennantRace(PennantRace pennantRace) async {
    try {
      await _repository.savePennantRace(pennantRace);
      final pennantRaces = await _repository.loadAllPennantRaces();
      _pennantRacesController.add(pennantRaces);
      
      if (pennantRace.isActive) {
        _activePennantRaceController.add(pennantRace);
      }
      return true;
    } catch (e) {
      print('Error updating pennant race: $e');
      return false;
    }
  }

  Future<bool> deletePennantRace(String pennantRaceId) async {
    try {
      final success = await _repository.deletePennantRace(pennantRaceId);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error deleting pennant race: $e');
      return false;
    }
  }

  // シーズン進行
  Future<bool> advanceWeek(String pennantRaceId) async {
    try {
      final success = await _repository.advanceWeek(pennantRaceId);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
        
        final activeRace = await _repository.loadActivePennantRace();
        _activePennantRaceController.add(activeRace);
      }
      return success;
    } catch (e) {
      print('Error advancing week: $e');
      return false;
    }
  }

  Future<bool> updatePhase(String pennantRaceId, SeasonPhase newPhase) async {
    try {
      final success = await _repository.updatePhase(pennantRaceId, newPhase);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
        
        final activeRace = await _repository.loadActivePennantRace();
        _activePennantRaceController.add(activeRace);
      }
      return success;
    } catch (e) {
      print('Error updating phase: $e');
      return false;
    }
  }

  // 試合管理
  Future<bool> addGame(String pennantRaceId, String gameId) async {
    try {
      final success = await _repository.addGame(pennantRaceId, gameId);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error adding game: $e');
      return false;
    }
  }

  Future<bool> removeGame(String pennantRaceId, String gameId) async {
    try {
      final success = await _repository.removeGame(pennantRaceId, gameId);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error removing game: $e');
      return false;
    }
  }

  Future<bool> scheduleGames(String pennantRaceId, List<String> gameIds) async {
    try {
      final success = await _repository.scheduleGames(pennantRaceId, gameIds);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error scheduling games: $e');
      return false;
    }
  }

  // 順位表管理
  Future<bool> updateTeamStandings(String pennantRaceId, String teamId, Map<String, dynamic> newStats) async {
    try {
      final success = await _repository.updateTeamStandings(pennantRaceId, teamId, newStats);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error updating team standings: $e');
      return false;
    }
  }

  Future<bool> updateSeasonStats(String pennantRaceId, Map<String, dynamic> newStats) async {
    try {
      final success = await _repository.updateSeasonStats(pennantRaceId, newStats);
      if (success) {
        _seasonStatsController.add(newStats);
      }
      return success;
    } catch (e) {
      print('Error updating season stats: $e');
      return false;
    }
  }

  Future<bool> calculateStandings(String pennantRaceId) async {
    try {
      final success = await _repository.calculateStandings(pennantRaceId);
      if (success) {
        final pennantRaces = await _repository.loadAllPennantRaces();
        _pennantRacesController.add(pennantRaces);
      }
      return success;
    } catch (e) {
      print('Error calculating standings: $e');
      return false;
    }
  }

  // 統計取得
  Future<Map<String, dynamic>> getPennantRaceStatistics(String pennantRaceId) async {
    try {
      return await _repository.getPennantRaceStatistics(pennantRaceId);
    } catch (e) {
      print('Error getting pennant race statistics: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSeasonStatistics(int year) async {
    try {
      return await _repository.getSeasonStatistics(year);
    } catch (e) {
      print('Error getting season statistics: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getTeamStandings(String pennantRaceId, String teamId) async {
    try {
      return await _repository.getTeamStandings(pennantRaceId, teamId);
    } catch (e) {
      print('Error getting team standings: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getTeamRecord(String pennantRaceId, String teamId) async {
    try {
      return await _repository.getTeamRecord(pennantRaceId, teamId);
    } catch (e) {
      print('Error getting team record: $e');
      return {};
    }
  }

  // スケジュール取得
  Future<List<String>> getWeeklyGames(String pennantRaceId, int week) async {
    try {
      return await _repository.getWeeklyGames(pennantRaceId, week);
    } catch (e) {
      print('Error getting weekly games: $e');
      return [];
    }
  }

  Future<List<String>> getMonthlyGames(String pennantRaceId, int month) async {
    try {
      return await _repository.getMonthlyGames(pennantRaceId, month);
    } catch (e) {
      print('Error getting monthly games: $e');
      return [];
    }
  }

  // 検索・フィルタリング
  Future<List<PennantRace>> searchPennantRacesByYearRange(int startYear, int endYear) async {
    try {
      return await _repository.searchPennantRacesByYearRange(startYear, endYear);
    } catch (e) {
      print('Error searching pennant races by year range: $e');
      return [];
    }
  }

  Future<List<PennantRace>> searchPennantRacesByPhase(SeasonPhase phase) async {
    try {
      return await _repository.searchPennantRacesByPhase(phase);
    } catch (e) {
      print('Error searching pennant races by phase: $e');
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

  // 同期・連携
  Future<bool> syncWithGameProgress(String pennantRaceId) async {
    try {
      return await _repository.syncWithGameProgress(pennantRaceId);
    } catch (e) {
      print('Error syncing with game progress: $e');
      return false;
    }
  }

  Future<bool> syncWithProfessionalTeams() async {
    try {
      return await _repository.syncWithProfessionalTeams();
    } catch (e) {
      print('Error syncing with professional teams: $e');
      return false;
    }
  }

  Future<bool> syncWithHighSchoolTournaments() async {
    try {
      return await _repository.syncWithHighSchoolTournaments();
    } catch (e) {
      print('Error syncing with high school tournaments: $e');
      return false;
    }
  }

  // リソース解放
  void dispose() {
    _pennantRacesController.close();
    _activePennantRaceController.close();
    _seasonStatsController.close();
  }
}
