import '../../../core/domain/entities/school.dart';
import '../../../core/domain/repositories/school_repository.dart';

/// 学校管理機能を提供するマネージャークラス
class SchoolManager {
  final SchoolRepository _repository;
  
  SchoolManager(this._repository);

  /// すべての学校を取得
  Future<List<School>> getAllSchools() async {
    try {
      return await _repository.loadAllSchools();
    } catch (e) {
      print('全学校取得エラー: $e');
      return [];
    }
  }

  /// 都道府県別の学校を取得
  Future<List<School>> getSchoolsByPrefecture(String prefecture) async {
    try {
      return await _repository.loadSchoolsByPrefecture(prefecture);
    } catch (e) {
      print('都道府県別学校取得エラー: $e');
      return [];
    }
  }

  /// 学校を取得
  Future<School?> getSchool(String schoolId) async {
    try {
      return await _repository.loadSchool(schoolId);
    } catch (e) {
      print('学校取得エラー: $e');
      return null;
    }
  }

  /// 学校を保存
  Future<bool> saveSchool(School school) async {
    try {
      return await _repository.saveSchool(school);
    } catch (e) {
      print('学校保存エラー: $e');
      return false;
    }
  }

  /// 学校を削除
  Future<bool> deleteSchool(String schoolId) async {
    try {
      return await _repository.deleteSchool(schoolId);
    } catch (e) {
      print('学校削除エラー: $e');
      return false;
    }
  }

  /// 学校に選手を追加
  Future<bool> addPlayerToSchool(String schoolId, String playerId) async {
    try {
      return await _repository.addPlayerToSchool(schoolId, playerId);
    } catch (e) {
      print('選手追加エラー: $e');
      return false;
    }
  }

  /// 学校から選手を削除
  Future<bool> removePlayerFromSchool(String schoolId, String playerId) async {
    try {
      return await _repository.removePlayerFromSchool(schoolId, playerId);
    } catch (e) {
      print('選手削除エラー: $e');
      return false;
    }
  }

  /// 学校数を取得
  Future<int> getSchoolCount() async {
    try {
      return await _repository.getSchoolCount();
    } catch (e) {
      print('学校数取得エラー: $e');
      return 0;
    }
  }

  /// 都道府県別の学校数を取得
  Future<int> getSchoolCountByPrefecture(String prefecture) async {
    try {
      return await _repository.getSchoolCountByPrefecture(prefecture);
    } catch (e) {
      print('都道府県別学校数取得エラー: $e');
      return 0;
    }
  }

  /// 学校が存在するかチェック
  Future<bool> hasSchool(String schoolId) async {
    try {
      return await _repository.hasSchool(schoolId);
    } catch (e) {
      print('学校存在チェックエラー: $e');
      return false;
    }
  }
}
