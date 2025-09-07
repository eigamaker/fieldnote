/// 学校データベーステーブルの管理クラス
class SchoolTable {
  static const String tableName = 'schools';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnType = 'type';
  static const String columnLocation = 'location';
  static const String columnPrefecture = 'prefecture';
  static const String columnRank = 'rank';
  static const String columnSchoolStrength = 'school_strength';
  
  /// テーブル作成SQL
  static const String createTableSql = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      location TEXT NOT NULL,
      prefecture TEXT NOT NULL,
      rank TEXT NOT NULL,
      school_strength INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  /// インデックス作成SQL
  static const String createIndexesSql = '''
    CREATE INDEX IF NOT EXISTS idx_schools_prefecture ON $tableName(prefecture);
    CREATE INDEX IF NOT EXISTS idx_schools_rank ON $tableName(rank);
    CREATE INDEX IF NOT EXISTS idx_schools_strength ON $tableName(school_strength);
  ''';

  /// 学校データ挿入SQL
  static const String insertSql = '''
    INSERT INTO $tableName (
      id, name, type, location, prefecture, rank, school_strength, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// 学校データ更新SQL
  static const String updateSql = '''
    UPDATE $tableName SET
      name = ?, type = ?, location = ?, prefecture = ?, rank = ?, 
      school_strength = ?, updated_at = ?
    WHERE id = ?
  ''';

  /// 学校データ削除SQL
  static const String deleteSql = '''
    DELETE FROM $tableName WHERE id = ?
  ''';

  /// IDで学校を取得するSQL
  static const String selectByIdSql = '''
    SELECT * FROM $tableName WHERE id = ?
  ''';

  /// 都道府県で学校を取得するSQL
  static const String selectByPrefectureSql = '''
    SELECT * FROM $tableName WHERE prefecture = ? ORDER BY rank, name
  ''';

  /// ランクで学校を取得するSQL
  static const String selectByRankSql = '''
    SELECT * FROM $tableName WHERE rank = ? ORDER BY prefecture, name
  ''';

  /// 強度レベルで学校を取得するSQL
  static const String selectByStrengthLevelSql = '''
    SELECT * FROM $tableName WHERE school_strength = ? ORDER BY prefecture, name
  ''';

  /// 全学校を取得するSQL
  static const String selectAllSql = '''
    SELECT * FROM $tableName ORDER BY prefecture, rank, name
  ''';

  /// 学校数を取得するSQL
  static const String countSql = '''
    SELECT COUNT(*) FROM $tableName
  ''';

  /// 都道府県別の学校数を取得するSQL
  static const String countByPrefectureSql = '''
    SELECT prefecture, COUNT(*) as count 
    FROM $tableName 
    GROUP BY prefecture 
    ORDER BY count DESC
  ''';

  /// ランク別の学校数を取得するSQL
  static const String countByRankSql = '''
    SELECT rank, COUNT(*) as count 
    FROM $tableName 
    GROUP BY rank 
    ORDER BY 
      CASE rank 
        WHEN '名門' THEN 1 
        WHEN '強豪' THEN 2 
        WHEN '中堅' THEN 3 
        WHEN '弱小' THEN 4 
        ELSE 5 
      END
  ''';

  /// 学校データを一括挿入するSQL
  static const String batchInsertSql = '''
    INSERT INTO $tableName (
      id, name, type, location, prefecture, rank, school_strength, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// テーブルをクリアするSQL
  static const String clearTableSql = '''
    DELETE FROM $tableName
  ''';

  /// テーブルが存在するかチェックするSQL
  static const String tableExistsSql = '''
    SELECT name FROM sqlite_master 
    WHERE type='table' AND name='$tableName'
  ''';
}
