import 'dart:async';
import '../../../core/domain/entities/player_growth.dart';
import '../../../core/domain/repositories/scout_repository.dart';

/// 選手成長管理マネージャー
/// 選手の成長処理、練習効果、週進行時の自動成長を管理
class GrowthManager {
  final ScoutRepository _scoutRepository;
  
  // ストリームコントローラー
  final StreamController<PlayerGrowth> _playerGrowthController = StreamController<PlayerGrowth>.broadcast();
  final StreamController<List<PlayerGrowth>> _allPlayerGrowthController = StreamController<List<PlayerGrowth>>.broadcast();

  GrowthManager(this._scoutRepository);

  // ストリーム
  Stream<PlayerGrowth> get playerGrowthStream => _playerGrowthController.stream;
  Stream<List<PlayerGrowth>> get allPlayerGrowthStream => _allPlayerGrowthController.stream;

  /// 選手成長データの取得
  Future<PlayerGrowth?> getPlayerGrowth(String playerId) async {
    try {
      return await _scoutRepository.loadPlayerGrowth(playerId);
    } catch (e) {
      print('選手成長データの取得に失敗: $e');
      return null;
    }
  }

  /// 全選手成長データの取得
  Future<List<PlayerGrowth>> getAllPlayerGrowth() async {
    try {
      final growthData = await _scoutRepository.loadAllPlayerGrowth();
      _allPlayerGrowthController.add(growthData);
      return growthData;
    } catch (e) {
      print('全選手成長データの取得に失敗: $e');
      return [];
    }
  }

  /// 学校別選手成長データの取得
  Future<List<PlayerGrowth>> getPlayerGrowthBySchool(String schoolId) async {
    try {
      return await _scoutRepository.loadPlayerGrowthBySchool(schoolId);
    } catch (e) {
      print('学校別選手成長データの取得に失敗: $e');
      return [];
    }
  }

  /// 選手成長データの保存
  Future<bool> savePlayerGrowth(PlayerGrowth playerGrowth) async {
    try {
      await _scoutRepository.savePlayerGrowth(playerGrowth);
      _playerGrowthController.add(playerGrowth);
      await _refreshAllPlayerGrowth();
      return true;
    } catch (e) {
      print('選手成長データの保存に失敗: $e');
      return false;
    }
  }

  /// 練習による成長処理
  Future<bool> processPractice({
    required String playerId,
    required int practiceIntensity,
    required DateTime practiceDate,
  }) async {
    try {
      final currentGrowth = await getPlayerGrowth(playerId);
      if (currentGrowth == null) return false;
      
      final updatedGrowth = currentGrowth.processPractice(
        practiceIntensity: practiceIntensity,
        practiceDate: practiceDate,
      );
      
      return await savePlayerGrowth(updatedGrowth);
    } catch (e) {
      print('練習による成長処理に失敗: $e');
      return false;
    }
  }

  /// 週進行時の自動成長処理
  Future<bool> processWeeklyGrowth({
    required String playerId,
    required DateTime weekDate,
    required int baseGrowthPoints,
  }) async {
    try {
      final currentGrowth = await getPlayerGrowth(playerId);
      if (currentGrowth == null) return false;
      
      final updatedGrowth = currentGrowth.processWeeklyGrowth(
        weekDate: weekDate,
        baseGrowthPoints: baseGrowthPoints,
      );
      
      return await savePlayerGrowth(updatedGrowth);
    } catch (e) {
      print('週進行時の成長処理に失敗: $e');
      return false;
    }
  }

  /// 一括週進行成長処理
  Future<bool> processWeeklyGrowthForAll({
    required DateTime weekDate,
    required int baseGrowthPoints,
  }) async {
    try {
      final allGrowth = await getAllPlayerGrowth();
      bool allSuccess = true;
      
      for (final growth in allGrowth) {
        final success = await processWeeklyGrowth(
          playerId: growth.playerId,
          weekDate: weekDate,
          baseGrowthPoints: baseGrowthPoints,
        );
        if (!success) allSuccess = false;
      }
      
      return allSuccess;
    } catch (e) {
      print('一括週進行成長処理に失敗: $e');
      return false;
    }
  }

  /// 選手成長データの作成
  Future<bool> createPlayerGrowth({
    required String playerId,
    required String playerName,
  }) async {
    try {
      final growth = PlayerGrowth.initial(
        playerId: playerId,
        playerName: playerName,
      );
      return await savePlayerGrowth(growth);
    } catch (e) {
      print('選手成長データの作成に失敗: $e');
      return false;
    }
  }

  /// 選手成長データの削除
  Future<bool> deletePlayerGrowth(String playerId) async {
    try {
      await _scoutRepository.deletePlayerGrowth(playerId);
      await _refreshAllPlayerGrowth();
      return true;
    } catch (e) {
      print('選手成長データの削除に失敗: $e');
      return false;
    }
  }

  /// 成長傾向の分析
  Map<String, dynamic> analyzeGrowthTrend(PlayerGrowth growth) {
    return {
      'talentLevel': growth.talentLevel,
      'talentLevelText': growth.talentLevelText,
      'growthRate': growth.growthRate,
      'growthRateText': growth.growthRateText,
      'practiceCount': growth.practiceCount,
      'totalGrowthPoints': growth.totalGrowthPoints,
      'recentGrowthTrend': growth.recentGrowthTrend,
      'lastGrowthDate': growth.lastGrowthDate,
    };
  }

  /// 学校別成長統計
  Future<Map<String, dynamic>> getSchoolGrowthStatistics(String schoolId) async {
    try {
      final schoolGrowth = await getPlayerGrowthBySchool(schoolId);
      
      if (schoolGrowth.isEmpty) {
        return {
          'totalPlayers': 0,
          'averageTalentLevel': 0.0,
          'averageGrowthRate': 0.0,
          'totalPracticeCount': 0,
          'totalGrowthPoints': 0,
        };
      }
      
      final totalPlayers = schoolGrowth.length;
      final averageTalentLevel = schoolGrowth.map((g) => g.talentLevel).reduce((a, b) => a + b) / totalPlayers;
      final averageGrowthRate = schoolGrowth.map((g) => g.growthRate).reduce((a, b) => a + b) / totalPlayers;
      final totalPracticeCount = schoolGrowth.map((g) => g.practiceCount).reduce((a, b) => a + b);
      final totalGrowthPoints = schoolGrowth.map((g) => g.totalGrowthPoints).reduce((a, b) => a + b);
      
      return {
        'totalPlayers': totalPlayers,
        'averageTalentLevel': averageTalentLevel,
        'averageGrowthRate': averageGrowthRate,
        'totalPracticeCount': totalPracticeCount,
        'totalGrowthPoints': totalGrowthPoints,
      };
    } catch (e) {
      print('学校別成長統計の取得に失敗: $e');
      return {};
    }
  }

  /// 成長ランキングの取得
  Future<List<PlayerGrowth>> getGrowthRanking() async {
    try {
      final allGrowth = await getAllPlayerGrowth();
      allGrowth.sort((a, b) => b.totalGrowthPoints.compareTo(a.totalGrowthPoints));
      return allGrowth;
    } catch (e) {
      print('成長ランキングの取得に失敗: $e');
      return [];
    }
  }

  /// 才能レベル別統計
  Future<Map<String, int>> getTalentLevelStatistics() async {
    try {
      final allGrowth = await getAllPlayerGrowth();
      final talentStats = <String, int>{};
      
      for (final growth in allGrowth) {
        final talentKey = growth.talentLevelText;
        talentStats[talentKey] = (talentStats[talentKey] ?? 0) + 1;
      }
      
      return talentStats;
    } catch (e) {
      print('才能レベル統計の取得に失敗: $e');
      return {};
    }
  }

  /// 練習強度の推奨
  Map<String, String> getPracticeRecommendations(PlayerGrowth growth) {
    final recommendations = <String, String>{};
    
    if (growth.practiceCount < 5) {
      recommendations['frequency'] = '練習回数が少ないです。定期的な練習を行いましょう';
    }
    
    if (growth.talentLevel > 1.5) {
      recommendations['intensity'] = '高い才能を持っています。練習強度を上げることを検討してください';
    }
    
    if (growth.growthRate < 0.8) {
      recommendations['growth'] = '成長率が低いです。練習方法の見直しを検討してください';
    }
    
    return recommendations;
  }

  /// 全選手成長データの更新
  Future<void> _refreshAllPlayerGrowth() async {
    try {
      final growthData = await _scoutRepository.loadAllPlayerGrowth();
      _allPlayerGrowthController.add(growthData);
    } catch (e) {
      print('全選手成長データの更新に失敗: $e');
    }
  }

  /// リソースの解放
  void dispose() {
    _playerGrowthController.close();
    _allPlayerGrowthController.close();
  }
}
