import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/scout_skills.dart';
import '../../../core/domain/repositories/scout_repository.dart';

/// スカウトスキル管理マネージャー
/// スキルのレベルアップ、スキルポイント分配、スキル効果の計算を管理
class SkillManager {
  final ScoutRepository _scoutRepository;
  
  // ストリームコントローラー
  final StreamController<ScoutSkills> _scoutSkillsController = StreamController<ScoutSkills>.broadcast();
  final StreamController<List<ScoutSkills>> _allScoutSkillsController = StreamController<List<ScoutSkills>>.broadcast();

  SkillManager(this._scoutRepository);

  // ストリーム
  Stream<ScoutSkills> get scoutSkillsStream => _scoutSkillsController.stream;
  Stream<List<ScoutSkills>> get allScoutSkillsStream => _allScoutSkillsController.stream;

  /// スカウトスキルの取得
  Future<ScoutSkills?> getScoutSkills(String scoutId) async {
    try {
      return await _scoutRepository.loadScoutSkills(scoutId);
    } catch (e) {
      print('スカウトスキルの取得に失敗: $e');
      return null;
    }
  }

  /// 全スカウトスキルの取得
  Future<List<ScoutSkills>> getAllScoutSkills() async {
    try {
      final skills = await _scoutRepository.loadAllScoutSkills();
      _allScoutSkillsController.add(skills);
      return skills;
    } catch (e) {
      print('全スカウトスキルの取得に失敗: $e');
      return [];
    }
  }

  /// スカウトスキルの保存
  Future<bool> saveScoutSkills(ScoutSkills scoutSkills) async {
    try {
      await _scoutRepository.saveScoutSkills(scoutSkills);
      _scoutSkillsController.add(scoutSkills);
      await _refreshAllScoutSkills();
      return true;
    } catch (e) {
      print('スカウトスキルの保存に失敗: $e');
      return false;
    }
  }

  /// スキルレベルアップ
  Future<bool> levelUpSkill(String scoutId, String skillName) async {
    try {
      final currentSkills = await getScoutSkills(scoutId);
      if (currentSkills == null) return false;
      
      if (currentSkills.availableSkillPoints <= 0) {
        print('スキルポイントが不足しています');
        return false;
      }
      
      final updatedSkills = currentSkills.levelUpSkill(skillName);
      if (updatedSkills.id == currentSkills.id) {
        print('スキルレベルアップに失敗しました');
        return false;
      }
      
      return await saveScoutSkills(updatedSkills);
    } catch (e) {
      print('スキルレベルアップに失敗: $e');
      return false;
    }
  }

  /// 経験値獲得によるスキルポイント付与
  Future<bool> gainExperience(String scoutId, int experience) async {
    try {
      final currentSkills = await getScoutSkills(scoutId);
      if (currentSkills == null) return false;
      
      final updatedSkills = currentSkills.gainExperience(experience);
      return await saveScoutSkills(updatedSkills);
    } catch (e) {
      print('経験値獲得に失敗: $e');
      return false;
    }
  }

  /// スカウト成功率の計算
  double calculateScoutingSuccessRate(ScoutSkills skills) {
    return skills.scoutingSuccessRate;
  }

  /// 選手品質向上率の計算
  double calculatePlayerQualityBonus(ScoutSkills skills) {
    return skills.playerQualityBonus;
  }

  /// スキル効果の総合評価
  Map<String, dynamic> evaluateSkillEffects(ScoutSkills skills) {
    return {
      'scoutingSuccessRate': skills.scoutingSuccessRate,
      'playerQualityBonus': skills.playerQualityBonus,
      'totalSkillLevel': skills.totalSkillLevel,
      'averageSkillLevel': skills.averageSkillLevel,
      'availableSkillPoints': skills.availableSkillPoints,
      'totalExperience': skills.totalExperience,
    };
  }

  /// スキル推奨設定の提案
  Map<String, String> getSkillRecommendations(ScoutSkills skills) {
    final recommendations = <String, String>{};
    
    // 探索力の推奨
    if (skills.exploration < 20) {
      recommendations['exploration'] = '探索力が低いため、選手発見率が低下しています';
    }
    
    // 観察力の推奨
    if (skills.observation < 20) {
      recommendations['observation'] = '観察力が低いため、選手評価の精度が低下しています';
    }
    
    // 分析力の推奨
    if (skills.analysis < 20) {
      recommendations['analysis'] = '分析力が低いため、選手の潜在能力を見抜けません';
    }
    
    // 洞察力の推奨
    if (skills.insight < 20) {
      recommendations['insight'] = '洞察力が低いため、隠れた才能を見逃しています';
    }
    
    // 交渉力の推奨
    if (skills.negotiation < 20) {
      recommendations['negotiation'] = '交渉力が低いため、選手獲得の成功率が低下しています';
    }
    
    // スタミナの推奨
    if (skills.stamina < 20) {
      recommendations['stamina'] = 'スタミナが低いため、長時間のスカウト活動が困難です';
    }
    
    return recommendations;
  }

  /// スキルバランスの分析
  Map<String, dynamic> analyzeSkillBalance(ScoutSkills skills) {
    final skillsList = [
      skills.exploration,
      skills.observation,
      skills.analysis,
      skills.insight,
      skills.negotiation,
      skills.stamina,
    ];
    
    final average = skillsList.reduce((a, b) => a + b) / skillsList.length;
    final variance = skillsList.map((skill) => (skill - average) * (skill - average)).reduce((a, b) => a + b) / skillsList.length;
    final standardDeviation = sqrt(variance);
    
    return {
      'average': average,
      'variance': variance,
      'standardDeviation': standardDeviation,
      'balance': standardDeviation < 5 ? 'バランス良好' : 'バランス悪化',
      'recommendation': standardDeviation < 5 ? '現在のスキルバランスは良好です' : 'スキルの偏りを是正することを推奨します',
    };
  }

  /// 初期スキルの作成
  Future<bool> createInitialSkills(String scoutId, String scoutName) async {
    try {
      final initialSkills = ScoutSkills.initial(scoutId: scoutId);
      return await saveScoutSkills(initialSkills);
    } catch (e) {
      print('初期スキルの作成に失敗: $e');
      return false;
    }
  }

  /// スカウトスキルの削除
  Future<bool> deleteScoutSkills(String scoutId) async {
    try {
      await _scoutRepository.deleteScoutSkills(scoutId);
      await _refreshAllScoutSkills();
      return true;
    } catch (e) {
      print('スカウトスキルの削除に失敗: $e');
      return false;
    }
  }

  /// 全スカウトスキルの更新
  Future<void> _refreshAllScoutSkills() async {
    try {
      final skills = await _scoutRepository.loadAllScoutSkills();
      _allScoutSkillsController.add(skills);
    } catch (e) {
      print('全スカウトスキルの更新に失敗: $e');
    }
  }

  /// リソースの解放
  void dispose() {
    _scoutSkillsController.close();
    _allScoutSkillsController.close();
  }
}
