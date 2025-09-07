import '../entities/school.dart';

/// 学校データの保存・読み込みを管理するリポジトリインターフェース
abstract class SchoolRepository {
  /// 学校を保存
  Future<bool> saveSchool(School school);
  
  /// 学校を読み込み
  Future<School?> loadSchool(String schoolId);
  
  /// すべての学校を読み込み
  Future<List<School>> loadAllSchools();
  
  /// 都道府県別の学校を読み込み
  Future<List<School>> loadSchoolsByPrefecture(String prefecture);
  
  /// 学校を削除
  Future<bool> deleteSchool(String schoolId);
  
  /// 学校が存在するかチェック
  Future<bool> hasSchool(String schoolId);
  
  /// 学校数を取得
  Future<int> getSchoolCount();
  
  /// 都道府県別の学校数を取得
  Future<int> getSchoolCountByPrefecture(String prefecture);
  
  /// 学校に選手を追加
  Future<bool> addPlayerToSchool(String schoolId, String playerId);
  
  /// 学校から選手を削除
  Future<bool> removePlayerFromSchool(String schoolId, String playerId);
  
  /// 学校をIDで取得
  Future<School?> getSchoolById(int id);
  
  /// すべての学校を取得
  Future<List<School>> getAllSchools();
  
  /// ランク別の学校を取得
  Future<List<School>> getSchoolsByRank(String rank);
  
  /// 強度レベル別の学校を取得
  Future<List<School>> getSchoolsByStrengthLevel(int strengthLevel);
  
  /// 都道府県別の学校を取得（既存メソッドとの互換性のため）
  Future<List<School>> getSchoolsByPrefecture(String prefecture);
}
