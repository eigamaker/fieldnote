import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/professional_team.dart';
import '../../../core/domain/repositories/professional_repository.dart';

class ProfessionalTeamManager {
  final ProfessionalRepository _repository;
  final StreamController<List<ProfessionalTeam>> _teamsController;
  final StreamController<ProfessionalTeam?> _selectedTeamController;
  final StreamController<Map<String, dynamic>> _teamStatsController;

  ProfessionalTeamManager(this._repository)
      : _teamsController = StreamController<List<ProfessionalTeam>>.broadcast(),
        _selectedTeamController = StreamController<ProfessionalTeam?>.broadcast(),
        _teamStatsController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<List<ProfessionalTeam>> get teamsStream => _teamsController.stream;
  Stream<ProfessionalTeam?> get selectedTeamStream => _selectedTeamController.stream;
  Stream<Map<String, dynamic>> get teamStatsStream => _teamStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    try {
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      
      if (teams.isEmpty) {
        await _createDefaultTeams();
      }
    } catch (e) {
      print('ProfessionalTeamManager initialization error: $e');
    }
  }

  // デフォルトチーム作成
  Future<void> _createDefaultTeams() async {
    final defaultTeams = [
      // セ・リーグ
      ProfessionalTeam.initial(
        id: 'central_giants',
        name: '読売ジャイアンツ',
        shortName: '巨人',
        league: League.central,
        city: '東京',
        stadium: '東京ドーム',
      ),
      ProfessionalTeam.initial(
        id: 'central_tigers',
        name: '阪神タイガース',
        shortName: '阪神',
        league: League.central,
        city: '大阪',
        stadium: '阪神甲子園球場',
      ),
      ProfessionalTeam.initial(
        id: 'central_carp',
        name: '広島東洋カープ',
        shortName: '広島',
        league: League.central,
        city: '広島',
        stadium: 'MAZDA Zoom-Zoom スタジアム広島',
      ),
      ProfessionalTeam.initial(
        id: 'central_baystars',
        name: '横浜DeNAベイスターズ',
        shortName: 'DeNA',
        league: League.central,
        city: '横浜',
        stadium: '横浜スタジアム',
      ),
      ProfessionalTeam.initial(
        id: 'central_swallows',
        name: '東京ヤクルトスワローズ',
        shortName: 'ヤクルト',
        league: League.central,
        city: '東京',
        stadium: '明治神宮野球場',
      ),
      ProfessionalTeam.initial(
        id: 'central_dragons',
        name: '中日ドラゴンズ',
        shortName: '中日',
        league: League.central,
        city: '名古屋',
        stadium: 'バンテリンドーム ナゴヤ',
      ),
      
      // パ・リーグ
      ProfessionalTeam.initial(
        id: 'pacific_hawks',
        name: '福岡ソフトバンクホークス',
        shortName: 'ソフトバンク',
        league: League.pacific,
        city: '福岡',
        stadium: '福岡PayPayドーム',
      ),
      ProfessionalTeam.initial(
        id: 'pacific_lions',
        name: '埼玉西武ライオンズ',
        shortName: '西武',
        league: League.pacific,
        city: '埼玉',
        stadium: 'ベルーナドーム',
      ),
      ProfessionalTeam.initial(
        id: 'pacific_fighters',
        name: '北海道日本ハムファイターズ',
        shortName: '日本ハム',
        league: League.pacific,
        city: '北海道',
        stadium: 'エスコンFスタジアム',
      ),
      ProfessionalTeam.initial(
        id: 'pacific_marines',
        name: '千葉ロッテマリーンズ',
        shortName: 'ロッテ',
        league: League.pacific,
        city: '千葉',
        stadium: 'ZOZOマリンスタジアム',
      ),
      ProfessionalTeam.initial(
        id: 'pacific_eagles',
        name: '東北楽天ゴールデンイーグルス',
        shortName: '楽天',
        league: League.pacific,
        city: '宮城',
        stadium: '楽天生命パーク宮城',
      ),
      ProfessionalTeam.initial(
        id: 'pacific_buffaloes',
        name: 'オリックス・バファローズ',
        shortName: 'オリックス',
        league: League.pacific,
        city: '大阪',
        stadium: '京セラドーム大阪',
      ),
    ];

    await _repository.saveTeams(defaultTeams);
    _teamsController.add(defaultTeams);
  }

  // チーム取得
  Future<List<ProfessionalTeam>> getAllTeams() async {
    try {
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      return teams;
    } catch (e) {
      print('Error loading teams: $e');
      return [];
    }
  }

  Future<List<ProfessionalTeam>> getTeamsByLeague(League league) async {
    try {
      return await _repository.loadTeamsByLeague(league);
    } catch (e) {
      print('Error loading teams by league: $e');
      return [];
    }
  }

  Future<ProfessionalTeam?> getTeam(String teamId) async {
    try {
      return await _repository.loadTeam(teamId);
    } catch (e) {
      print('Error loading team: $e');
      return null;
    }
  }

  // チーム作成・更新
  Future<bool> createTeam(ProfessionalTeam team) async {
    try {
      if (await _repository.teamExists(team.id)) {
        return false;
      }
      
      await _repository.saveTeam(team);
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      return true;
    } catch (e) {
      print('Error creating team: $e');
      return false;
    }
  }

  Future<bool> updateTeam(ProfessionalTeam team) async {
    try {
      await _repository.saveTeam(team);
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      return true;
    } catch (e) {
      print('Error updating team: $e');
      return false;
    }
  }

  Future<bool> deleteTeam(String teamId) async {
    try {
      final success = await _repository.deleteTeam(teamId);
      if (success) {
        final teams = await _repository.loadAllTeams();
        _teamsController.add(teams);
      }
      return success;
    } catch (e) {
      print('Error deleting team: $e');
      return false;
    }
  }

  // チーム選択
  void selectTeam(ProfessionalTeam? team) {
    _selectedTeamController.add(team);
  }

  // 選手管理
  Future<bool> addPlayerToTeam(String teamId, String playerId) async {
    try {
      final success = await _repository.addPlayerToTeam(teamId, playerId);
      if (success) {
        final teams = await _repository.loadAllTeams();
        _teamsController.add(teams);
      }
      return success;
    } catch (e) {
      print('Error adding player to team: $e');
      return false;
    }
  }

  Future<bool> removePlayerFromTeam(String teamId, String playerId) async {
    try {
      final success = await _repository.removePlayerFromTeam(teamId, playerId);
      if (success) {
        final teams = await _repository.loadAllTeams();
        _teamsController.add(teams);
      }
      return success;
    } catch (e) {
      print('Error removing player from team: $e');
      return false;
    }
  }

  // チーム統計更新
  Future<bool> updateTeamStats(String teamId, Map<String, dynamic> newStats) async {
    try {
      final team = await _repository.loadTeam(teamId);
      if (team == null) return false;

      final updatedTeam = team.updateSeasonStats(newStats);
      await _repository.saveTeam(updatedTeam);
      
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      
      _teamStatsController.add(newStats);
      return true;
    } catch (e) {
      print('Error updating team stats: $e');
      return false;
    }
  }

  Future<bool> resetTeamSeasonStats(String teamId) async {
    try {
      final team = await _repository.loadTeam(teamId);
      if (team == null) return false;

      final updatedTeam = team.resetSeasonStats();
      await _repository.saveTeam(updatedTeam);
      
      final teams = await _repository.loadAllTeams();
      _teamsController.add(teams);
      return true;
    } catch (e) {
      print('Error resetting team stats: $e');
      return false;
    }
  }

  // 統計取得
  Future<Map<String, dynamic>> getTeamStatistics(String teamId) async {
    try {
      return await _repository.getTeamStatistics(teamId);
    } catch (e) {
      print('Error getting team statistics: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getLeagueStatistics(League league) async {
    try {
      return await _repository.getLeagueStatistics(league);
    } catch (e) {
      print('Error getting league statistics: $e');
      return {};
    }
  }

  // 検索・フィルタリング
  Future<List<ProfessionalTeam>> searchTeams(String query) async {
    try {
      final allTeams = await _repository.loadAllTeams();
      if (query.isEmpty) return allTeams;
      
      return allTeams.where((team) =>
        team.name.toLowerCase().contains(query.toLowerCase()) ||
        team.shortName.toLowerCase().contains(query.toLowerCase()) ||
        team.city.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error searching teams: $e');
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
    _teamsController.close();
    _selectedTeamController.close();
    _teamStatsController.close();
  }
}
