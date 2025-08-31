import '../entities/scout_skills.dart';
import '../entities/experience_system.dart';
import '../entities/player_growth.dart';

/// スカウトリポジトリの抽象インターフェース
/// スカウトスキル、経験値、成長データの永続化操作を定義
abstract class ScoutRepository {
  // スカウトスキル関連
  Future<void> saveScoutSkills(ScoutSkills scoutSkills);
  Future<ScoutSkills?> loadScoutSkills(String scoutId);
  Future<List<ScoutSkills>> loadAllScoutSkills();
  Future<void> deleteScoutSkills(String scoutId);
  Future<bool> hasScoutSkills(String scoutId);
  
  // 経験値システム関連
  Future<void> saveExperienceSystem(ExperienceSystem experienceSystem);
  Future<ExperienceSystem?> loadExperienceSystem(String scoutId);
  Future<List<ExperienceSystem>> loadAllExperienceSystems();
  Future<void> deleteExperienceSystem(String scoutId);
  Future<bool> hasExperienceSystem(String scoutId);
  
  // 選手成長関連
  Future<void> savePlayerGrowth(PlayerGrowth playerGrowth);
  Future<PlayerGrowth?> loadPlayerGrowth(String playerId);
  Future<List<PlayerGrowth>> loadAllPlayerGrowth();
  Future<List<PlayerGrowth>> loadPlayerGrowthBySchool(String schoolId);
  Future<void> deletePlayerGrowth(String playerId);
  Future<bool> hasPlayerGrowth(String playerId);
  
  // 統計情報
  Future<int> getTotalScoutCount();
  Future<int> getTotalPlayerGrowthCount();
  Future<int> getPlayerGrowthCountBySchool(String schoolId);
  
  // 一括操作
  Future<void> saveAllScoutData({
    required List<ScoutSkills> scoutSkillsList,
    required List<ExperienceSystem> experienceSystemsList,
    required List<PlayerGrowth> playerGrowthList,
  });
  
  Future<Map<String, dynamic>> loadAllScoutData();
}
