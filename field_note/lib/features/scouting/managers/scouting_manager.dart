import 'dart:async';
import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/scout_action.dart';
import '../../../core/domain/repositories/player_repository.dart';
import '../../../core/domain/repositories/school_repository.dart';
import 'player_generator.dart';

/// スカウト機能を管理するマネージャークラス
class ScoutingManager {
  final PlayerRepository _playerRepository;
  final SchoolRepository _schoolRepository;
  
  // 状態変更の通知用ストリーム
  final StreamController<List<Player>> _discoveredPlayersController = 
      StreamController<List<Player>>.broadcast();
  final StreamController<ScoutAction> _scoutActionController = 
      StreamController<ScoutAction>.broadcast();
  
  ScoutingManager(this._playerRepository, this._schoolRepository);

  /// 発見した選手のストリーム
  Stream<List<Player>> get discoveredPlayersStream => _discoveredPlayersController.stream;
  
  /// スカウトアクションのストリーム
  Stream<ScoutAction> get scoutActionStream => _scoutActionController.stream;

  /// スカウトアクションを実行
  Future<ScoutAction> executeScouting({
    required String schoolId,
    required double scoutSkill,
  }) async {
    try {
      // 学校情報を取得
      final school = await _schoolRepository.loadSchool(schoolId);
      if (school == null) {
        throw Exception('学校が見つかりません: $schoolId');
      }
      
      // スカウトアクションを作成
      final scoutAction = ScoutAction.create(
        schoolId: schoolId,
        schoolName: school.name,
        scoutSkill: scoutSkill,
      );
      
      // 選手を生成
      final discoveredPlayers = PlayerGenerator.generatePlayersFromScouting(
        scoutAction: scoutAction,
        school: school,
      );
      
      // 発見した選手を保存
      for (final player in discoveredPlayers) {
        await _playerRepository.savePlayer(player);
        
        // 学校に選手を追加
        await _schoolRepository.addPlayerToSchool(schoolId, player.id);
      }
      
      // スカウトアクションを更新
      final completedScoutAction = scoutAction.copyWith(
        discoveredPlayerIds: discoveredPlayers.map((p) => p.id).toList(),
        isCompleted: true,
      );
      
      // 状態を通知
      _discoveredPlayersController.add(discoveredPlayers);
      _scoutActionController.add(completedScoutAction);
      
      return completedScoutAction;
    } catch (e) {
      print('スカウト実行エラー: $e');
      rethrow;
    }
  }

  /// 学校の選手一覧を取得
  Future<List<Player>> getSchoolPlayers(String schoolId) async {
    try {
      return await _playerRepository.loadPlayersBySchool(schoolId);
    } catch (e) {
      print('学校選手取得エラー: $e');
      return [];
    }
  }

  /// すべての選手を取得
  Future<List<Player>> getAllPlayers() async {
    try {
      return await _playerRepository.loadAllPlayers();
    } catch (e) {
      print('全選手取得エラー: $e');
      return [];
    }
  }

  /// 選手の詳細情報を取得
  Future<Player?> getPlayerDetails(String playerId) async {
    try {
      return await _playerRepository.loadPlayer(playerId);
    } catch (e) {
      print('選手詳細取得エラー: $e');
      return null;
    }
  }

  /// スカウト結果の評価を取得
  String evaluateScoutingResult(List<Player> players) {
    return PlayerGenerator.evaluateScoutingResult(players);
  }

  /// スカウト結果のサマリーを生成
  String generateScoutingSummary({
    required ScoutAction scoutAction,
    required List<Player> discoveredPlayers,
  }) {
    final evaluation = evaluateScoutingResult(discoveredPlayers);
    return PlayerGenerator.generateScoutingSummary(
      scoutAction: scoutAction,
      discoveredPlayers: discoveredPlayers,
      evaluation: evaluation,
    );
  }

  /// 選手を削除
  Future<bool> deletePlayer(String playerId) async {
    try {
      // 選手の学校IDを取得
      final player = await _playerRepository.loadPlayer(playerId);
      if (player != null) {
        // 学校から選手を削除
        await _schoolRepository.removePlayerFromSchool(player.schoolId, playerId);
      }
      
      // 選手を削除
      return await _playerRepository.deletePlayer(playerId);
    } catch (e) {
      print('選手削除エラー: $e');
      return false;
    }
  }

  /// 学校の選手数を取得
  Future<int> getSchoolPlayerCount(String schoolId) async {
    try {
      return await _playerRepository.getPlayerCountBySchool(schoolId);
    } catch (e) {
      print('学校選手数取得エラー: $e');
      return 0;
    }
  }

  /// 総選手数を取得
  Future<int> getTotalPlayerCount() async {
    try {
      return await _playerRepository.getTotalPlayerCount();
    } catch (e) {
      print('総選手数取得エラー: $e');
      return 0;
    }
  }

  /// リソースを解放
  void dispose() {
    _discoveredPlayersController.close();
    _scoutActionController.close();
  }
}
