import 'dart:async';
import '../../../core/domain/entities/experience_system.dart';
import '../../../core/domain/repositories/scout_repository.dart';

/// 経験値管理マネージャー
/// スカウトの経験値獲得、レベルアップ、スキルポイント付与を管理
class ExperienceManager {
  final ScoutRepository _scoutRepository;
  
  // ストリームコントローラー
  final StreamController<ExperienceSystem> _experienceController = StreamController<ExperienceSystem>.broadcast();
  final StreamController<List<ExperienceSystem>> _allExperienceController = StreamController<List<ExperienceSystem>>.broadcast();

  ExperienceManager(this._scoutRepository);

  // ストリーム
  Stream<ExperienceSystem> get experienceStream => _experienceController.stream;
  Stream<List<ExperienceSystem>> get allExperienceStream => _allExperienceController.stream;

  /// 経験値システムの取得
  Future<ExperienceSystem?> getExperienceSystem(String scoutId) async {
    try {
      return await _scoutRepository.loadExperienceSystem(scoutId);
    } catch (e) {
      print('経験値システムの取得に失敗: $e');
      return null;
    }
  }

  /// 全経験値システムの取得
  Future<List<ExperienceSystem>> getAllExperienceSystems() async {
    try {
      final systems = await _scoutRepository.loadAllExperienceSystems();
      _allExperienceController.add(systems);
      return systems;
    } catch (e) {
      print('全経験値システムの取得に失敗: $e');
      return [];
    }
  }

  /// 経験値システムの保存
  Future<bool> saveExperienceSystem(ExperienceSystem experienceSystem) async {
    try {
      await _scoutRepository.saveExperienceSystem(experienceSystem);
      _experienceController.add(experienceSystem);
      await _refreshAllExperienceSystems();
      return true;
    } catch (e) {
      print('経験値システムの保存に失敗: $e');
      return false;
    }
  }

  /// スカウト成功時の経験値獲得
  Future<bool> gainScoutingExperience({
    required String scoutId,
    required int discoveredPlayerCount,
    required double playerQuality,
    required int schoolLevel,
  }) async {
    try {
      final currentSystem = await getExperienceSystem(scoutId);
      if (currentSystem == null) return false;
      
      final experience = ExperienceSystem.calculateScoutingExperience(
        discoveredPlayerCount: discoveredPlayerCount,
        playerQuality: playerQuality,
        schoolLevel: schoolLevel,
      );
      
      final updatedSystem = currentSystem.gainExperience(experience);
      return await saveExperienceSystem(updatedSystem);
    } catch (e) {
      print('スカウト経験値獲得に失敗: $e');
      return false;
    }
  }

  /// 直接経験値獲得
  Future<bool> gainExperience(String scoutId, int experience) async {
    try {
      final currentSystem = await getExperienceSystem(scoutId);
      if (currentSystem == null) return false;
      
      final updatedSystem = currentSystem.gainExperience(experience);
      return await saveExperienceSystem(updatedSystem);
    } catch (e) {
      print('経験値獲得に失敗: $e');
      return false;
    }
  }

  /// レベルアップチェック
  bool isLevelUp(ExperienceSystem system) {
    return system.currentExperience >= system.experienceToNextLevel;
  }

  /// 次のレベルまでの残り経験値
  int getRemainingExperience(ExperienceSystem system) {
    return system.remainingExperience;
  }

  /// レベル進行度の計算
  double getLevelProgress(ExperienceSystem system) {
    return system.levelProgress;
  }

  /// 経験値獲得履歴の分析
  Map<String, dynamic> analyzeExperienceHistory(ExperienceSystem system) {
    final totalExp = system.totalExperience;
    final currentLevel = system.currentLevel;
    final avgExpPerLevel = totalExp / currentLevel;
    
    return {
      'totalExperience': totalExp,
      'currentLevel': currentLevel,
      'averageExperiencePerLevel': avgExpPerLevel,
      'efficiency': avgExpPerLevel > 50 ? '高効率' : '標準',
      'nextLevelProgress': system.levelProgressText,
      'remainingExperience': system.remainingExperience,
    };
  }

  /// 経験値獲得推奨事項
  Map<String, String> getExperienceRecommendations(ExperienceSystem system) {
    final recommendations = <String, String>{};
    
    if (system.currentLevel < 5) {
      recommendations['level'] = 'レベル5まで上げることで、より多くのスキルポイントを獲得できます';
    }
    
    if (system.currentExperience < system.experienceToNextLevel * 0.5) {
      recommendations['progress'] = '次のレベルアップまでまだ時間がかかります。積極的にスカウト活動を行いましょう';
    }
    
    if (system.availableSkillPoints > 20) {
      recommendations['skillPoints'] = 'スキルポイントが蓄積されています。スキルの強化を検討してください';
    }
    
    return recommendations;
  }

  /// 経験値ランキングの取得
  Future<List<ExperienceSystem>> getExperienceRanking() async {
    try {
      final systems = await getAllExperienceSystems();
      systems.sort((a, b) => b.totalExperience.compareTo(a.totalExperience));
      return systems;
    } catch (e) {
      print('経験値ランキングの取得に失敗: $e');
      return [];
    }
  }

  /// レベル別統計情報
  Future<Map<String, int>> getLevelStatistics() async {
    try {
      final systems = await getAllExperienceSystems();
      final levelStats = <String, int>{};
      
      for (final system in systems) {
        final levelKey = 'Lv.${system.currentLevel}';
        levelStats[levelKey] = (levelStats[levelKey] ?? 0) + 1;
      }
      
      return levelStats;
    } catch (e) {
      print('レベル統計の取得に失敗: $e');
      return {};
    }
  }

  /// 初期経験値システムの作成
  Future<bool> createInitialExperienceSystem(String scoutId, String scoutName) async {
    try {
      final initialSystem = ExperienceSystem.initial(
        scoutId: scoutId,
        scoutName: scoutName,
      );
      return await saveExperienceSystem(initialSystem);
    } catch (e) {
      print('初期経験値システムの作成に失敗: $e');
      return false;
    }
  }

  /// 経験値システムの削除
  Future<bool> deleteExperienceSystem(String scoutId) async {
    try {
      await _scoutRepository.deleteExperienceSystem(scoutId);
      await _refreshAllExperienceSystems();
      return true;
    } catch (e) {
      print('経験値システムの削除に失敗: $e');
      return false;
    }
  }

  /// 全経験値システムの更新
  Future<void> _refreshAllExperienceSystems() async {
    try {
      final systems = await _scoutRepository.loadAllExperienceSystems();
      _allExperienceController.add(systems);
    } catch (e) {
      print('全経験値システムの更新に失敗: $e');
    }
  }

  /// リソースの解放
  void dispose() {
    _experienceController.close();
    _allExperienceController.close();
  }
}
