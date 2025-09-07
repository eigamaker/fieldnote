import '../../../core/domain/entities/school.dart';
import '../../../core/data/repositories/database_school_repository.dart';
import '../../../core/data/services/school_data_loader.dart';
import '../../../core/data/database/database_manager.dart';
import '../../../core/domain/repositories/school_repository.dart';

/// 学校データの初期化を管理するマネージャークラス
class SchoolInitializationManager implements SchoolRepository {
  final SchoolRepository _schoolRepository;

  SchoolInitializationManager({SchoolRepository? schoolRepository})
      : _schoolRepository = schoolRepository ?? DatabaseSchoolRepository();

  /// 学校データを初期化
  Future<bool> initializeSchools() async {
    try {
      print('学校データの初期化を開始...');
      
      // データベースを初期化
      await DatabaseManager.database;
      
      // 既に学校データが読み込まれているかチェック
      final isLoaded = await SchoolDataLoader.isSchoolsLoaded();
      if (isLoaded) {
        print('学校データは既に読み込まれています');
        await _printSchoolStatistics();
        return true;
      }
      
      // CSVファイルから学校データを読み込んでデータベースに挿入
      final success = await SchoolDataLoader.loadSchoolsFromCsv();
      
      if (success) {
        print('学校データの初期化が完了しました');
        return true;
      } else {
        print('学校データの初期化に失敗しました');
        return false;
      }
    } catch (e) {
      print('学校データの初期化中にエラーが発生しました: $e');
      return false;
    }
  }

  /// 学校データの統計情報を表示
  Future<void> _printSchoolStatistics() async {
    try {
      if (_schoolRepository is DatabaseSchoolRepository) {
        final stats = await (_schoolRepository as DatabaseSchoolRepository).getSchoolStatistics();
        
        print('\n=== 学校データ統計 ===');
        print('総学校数: ${stats['totalCount']}校');
        print('都道府県数: ${stats['prefectureCount']}都道府県');
        
        print('\n=== ランク別分布 ===');
        for (final row in stats['rankCounts']) {
          print('${row['rank']}: ${row['count']}校');
        }
        
        print('\n=== 都道府県別分布（上位10都道府県） ===');
        for (int i = 0; i < 10 && i < stats['prefectureCounts'].length; i++) {
          final row = stats['prefectureCounts'][i];
          print('${row['prefecture']}: ${row['count']}校');
        }
      } else {
        // フォールバック: メモリベースの統計
        final schools = await _schoolRepository.getAllSchools();
        
        // 都道府県別の学校数
        final prefectureCounts = <String, int>{};
        for (final school in schools) {
          prefectureCounts[school.prefecture] = (prefectureCounts[school.prefecture] ?? 0) + 1;
        }
        
        // ランク別の学校数
        final rankCounts = <String, int>{};
        for (final school in schools) {
          rankCounts[school.rank] = (rankCounts[school.rank] ?? 0) + 1;
        }
        
        print('\n=== 学校データ統計 ===');
        print('総学校数: ${schools.length}校');
        print('都道府県数: ${prefectureCounts.length}都道府県');
        
        print('\n=== ランク別分布 ===');
        for (final entry in rankCounts.entries) {
          print('${entry.key}: ${entry.value}校');
        }
        
        print('\n=== 都道府県別分布（上位10都道府県） ===');
        final sortedPrefectures = prefectureCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        for (int i = 0; i < 10 && i < sortedPrefectures.length; i++) {
          final entry = sortedPrefectures[i];
          print('${entry.key}: ${entry.value}校');
        }
      }
    } catch (e) {
      print('統計情報の表示中にエラーが発生しました: $e');
    }
  }

  /// 学校データが既に初期化されているかチェック
  Future<bool> isSchoolsInitialized() async {
    try {
      final schools = await _schoolRepository.getAllSchools();
      return schools.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 学校データをリセット（テスト用）
  Future<void> resetSchools() async {
    try {
      await SchoolDataLoader.resetSchools();
      print('学校データをリセットしました');
    } catch (e) {
      print('学校データのリセットに失敗しました: $e');
      rethrow;
    }
  }

  /// 特定の都道府県の学校一覧を取得
  Future<List<School>> getSchoolsByPrefecture(String prefecture) async {
    return await _schoolRepository.getSchoolsByPrefecture(prefecture);
  }

  /// 特定のランクの学校一覧を取得
  Future<List<School>> getSchoolsByRank(String rank) async {
    return await _schoolRepository.getSchoolsByRank(rank);
  }

  /// 特定の強度レベルの学校一覧を取得
  Future<List<School>> getSchoolsByStrengthLevel(int strengthLevel) async {
    return await _schoolRepository.getSchoolsByStrengthLevel(strengthLevel);
  }

  /// 学校IDから学校を取得
  Future<School?> getSchoolById(int id) async {
    return await _schoolRepository.getSchoolById(id);
  }

  /// 全学校一覧を取得
  Future<List<School>> getAllSchools() async {
    return await _schoolRepository.getAllSchools();
  }

  @override
  Future<bool> saveSchool(School school) async {
    return await _schoolRepository.saveSchool(school);
  }

  @override
  Future<School?> loadSchool(String schoolId) async {
    return await _schoolRepository.loadSchool(schoolId);
  }

  @override
  Future<List<School>> loadAllSchools() async {
    return await _schoolRepository.loadAllSchools();
  }

  @override
  Future<List<School>> loadSchoolsByPrefecture(String prefecture) async {
    return await _schoolRepository.loadSchoolsByPrefecture(prefecture);
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    return await _schoolRepository.deleteSchool(schoolId);
  }

  @override
  Future<bool> hasSchool(String schoolId) async {
    return await _schoolRepository.hasSchool(schoolId);
  }

  @override
  Future<int> getSchoolCount() async {
    return await _schoolRepository.getSchoolCount();
  }

  @override
  Future<int> getSchoolCountByPrefecture(String prefecture) async {
    return await _schoolRepository.getSchoolCountByPrefecture(prefecture);
  }

  @override
  Future<bool> addPlayerToSchool(String schoolId, String playerId) async {
    return await _schoolRepository.addPlayerToSchool(schoolId, playerId);
  }

  @override
  Future<bool> removePlayerFromSchool(String schoolId, String playerId) async {
    return await _schoolRepository.removePlayerFromSchool(schoolId, playerId);
  }
}
