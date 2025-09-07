import 'package:sqflite/sqflite.dart';
import '../database/database_manager.dart';
import '../database/school_table.dart';
import '../../domain/entities/school.dart';
import '../../domain/repositories/school_repository.dart';

/// データベースベースの学校リポジトリ実装
class DatabaseSchoolRepository implements SchoolRepository {
  @override
  Future<List<School>> getAllSchools() async {
    try {
      final db = await DatabaseManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(SchoolTable.selectAllSql);
      
      return maps.map((map) => _mapToSchool(map)).toList();
    } catch (e) {
      print('全学校の取得に失敗しました: $e');
      return [];
    }
  }

  @override
  Future<School?> getSchoolById(int id) async {
    try {
      final db = await DatabaseManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        SchoolTable.selectByIdSql,
        [id]
      );
      
      if (maps.isNotEmpty) {
        return _mapToSchool(maps.first);
      }
      return null;
    } catch (e) {
      print('学校ID $id の取得に失敗しました: $e');
      return null;
    }
  }

  @override
  Future<List<School>> getSchoolsByPrefecture(String prefecture) async {
    try {
      final db = await DatabaseManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        SchoolTable.selectByPrefectureSql,
        [prefecture]
      );
      
      return maps.map((map) => _mapToSchool(map)).toList();
    } catch (e) {
      print('都道府県 $prefecture の学校取得に失敗しました: $e');
      return [];
    }
  }

  @override
  Future<List<School>> getSchoolsByRank(String rank) async {
    try {
      final db = await DatabaseManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        SchoolTable.selectByRankSql,
        [rank]
      );
      
      return maps.map((map) => _mapToSchool(map)).toList();
    } catch (e) {
      print('ランク $rank の学校取得に失敗しました: $e');
      return [];
    }
  }

  @override
  Future<List<School>> getSchoolsByStrengthLevel(int strengthLevel) async {
    try {
      final db = await DatabaseManager.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        SchoolTable.selectByStrengthLevelSql,
        [strengthLevel]
      );
      
      return maps.map((map) => _mapToSchool(map)).toList();
    } catch (e) {
      print('強度レベル $strengthLevel の学校取得に失敗しました: $e');
      return [];
    }
  }

  @override
  Future<bool> saveSchool(School school) async {
    try {
      final db = await DatabaseManager.database;
      final now = DateTime.now().toIso8601String();
      
      // 既存の学校をチェック
      final existing = await getSchoolById(school.id);
      
      if (existing != null) {
        // 更新
        await db.rawUpdate(
          SchoolTable.updateSql,
          [
            school.name,
            school.type,
            school.location,
            school.prefecture,
            school.rank,
            school.schoolStrength,
            now,
            school.id,
          ]
        );
        print('学校を更新しました: ${school.name}');
      } else {
        // 新規作成
        await db.rawInsert(
          SchoolTable.insertSql,
          [
            school.id,
            school.name,
            school.type,
            school.location,
            school.prefecture,
            school.rank,
            school.schoolStrength,
            now,
            now,
          ]
        );
        print('学校を新規作成しました: ${school.name}');
      }
      
      return true;
    } catch (e) {
      print('学校の保存に失敗しました: $e');
      return false;
    }
  }


  @override
  Future<bool> initializeSchools() async {
    // データベースベースのリポジトリでは、このメソッドは使用しない
    // 代わりにSchoolDataLoaderを使用する
    print('DatabaseSchoolRepositoryではinitializeSchools()は使用しません');
    print('代わりにSchoolDataLoader.loadSchoolsFromCsv()を使用してください');
    return false;
  }

  /// データベースのマップをSchoolオブジェクトに変換
  School _mapToSchool(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      location: map['location'],
      prefecture: map['prefecture'],
      rank: map['rank'],
      schoolStrength: map['school_strength'],
    );
  }

  /// 学校データの統計情報を取得
  Future<Map<String, dynamic>> getSchoolStatistics() async {
    try {
      final db = await DatabaseManager.database;
      
      // 総学校数
      final totalCount = Sqflite.firstIntValue(
        await db.rawQuery(SchoolTable.countSql)
      ) ?? 0;
      
      // 都道府県別の学校数
      final prefectureCounts = await db.rawQuery(SchoolTable.countByPrefectureSql);
      
      // ランク別の学校数
      final rankCounts = await db.rawQuery(SchoolTable.countByRankSql);
      
      return {
        'totalCount': totalCount,
        'prefectureCount': prefectureCounts.length,
        'prefectureCounts': prefectureCounts,
        'rankCounts': rankCounts,
      };
    } catch (e) {
      print('学校統計情報の取得に失敗しました: $e');
      return {
        'error': e.toString(),
      };
    }
  }



  @override
  Future<bool> addPlayerToSchool(String schoolId, String playerId) async {
    // この実装は将来的に選手-学校の関連テーブルが必要
    // 現在は単純にtrueを返す
    return true;
  }

  @override
  Future<bool> removePlayerFromSchool(String schoolId, String playerId) async {
    // この実装は将来的に選手-学校の関連テーブルが必要
    // 現在は単純にtrueを返す
    return true;
  }

  @override
  Future<int> getSchoolCount() async {
    try {
      final db = await DatabaseManager.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM ${SchoolTable.tableName}');
      return result.first['count'] as int;
    } catch (e) {
      print('学校数の取得に失敗しました: $e');
      return 0;
    }
  }

  @override
  Future<int> getSchoolCountByPrefecture(String prefecture) async {
    try {
      final db = await DatabaseManager.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${SchoolTable.tableName} WHERE ${SchoolTable.columnPrefecture} = ?',
        [prefecture],
      );
      return result.first['count'] as int;
    } catch (e) {
      print('都道府県 $prefecture の学校数取得に失敗しました: $e');
      return 0;
    }
  }

  @override
  Future<bool> hasSchool(String schoolId) async {
    try {
      final db = await DatabaseManager.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${SchoolTable.tableName} WHERE ${SchoolTable.columnId} = ?',
        [schoolId],
      );
      return (result.first['count'] as int) > 0;
    } catch (e) {
      print('学校存在チェックに失敗しました: $e');
      return false;
    }
  }

  @override
  Future<List<School>> loadAllSchools() async {
    return getAllSchools();
  }

  @override
  Future<School?> loadSchool(String schoolId) async {
    try {
      final id = int.parse(schoolId);
      return await getSchoolById(id);
    } catch (e) {
      print('学校ID $schoolId の読み込みに失敗しました: $e');
      return null;
    }
  }

  @override
  Future<List<School>> loadSchoolsByPrefecture(String prefecture) async {
    return getSchoolsByPrefecture(prefecture);
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    try {
      final db = await DatabaseManager.database;
      final id = int.parse(schoolId);
      final result = await db.delete(
        SchoolTable.tableName,
        where: '${SchoolTable.columnId} = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('学校ID $schoolId の削除に失敗しました: $e');
      return false;
    }
  }
}
