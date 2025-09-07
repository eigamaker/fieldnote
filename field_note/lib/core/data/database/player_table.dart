/// 選手データベーステーブルの管理クラス
class PlayerTable {
  static const String tableName = 'players';
  static const String currentAbilitiesTableName = 'player_current_abilities';
  static const String potentialAbilitiesTableName = 'player_potential_abilities';
  static const String scoutedAbilitiesTableName = 'player_scouted_abilities';
  
  /// 選手基本情報テーブル作成SQL
  static const String createPlayerTableSql = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      age INTEGER NOT NULL,
      grade INTEGER NOT NULL,
      position TEXT NOT NULL,
      school_id INTEGER NOT NULL,
      discovered_date TEXT NOT NULL,
      scout_skill_used REAL NOT NULL,
      talent_rank INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (school_id) REFERENCES schools(id)
    )
  ''';

  /// 現在能力値テーブル作成SQL
  static const String createCurrentAbilitiesTableSql = '''
    CREATE TABLE IF NOT EXISTS $currentAbilitiesTableName (
      player_id TEXT PRIMARY KEY,
      physical_strength INTEGER NOT NULL,
      physical_agility INTEGER NOT NULL,
      physical_stamina INTEGER NOT NULL,
      physical_flexibility INTEGER NOT NULL,
      physical_balance INTEGER NOT NULL,
      physical_explosiveness INTEGER NOT NULL,
      mental_concentration INTEGER NOT NULL,
      mental_composure INTEGER NOT NULL,
      mental_decision_making INTEGER NOT NULL,
      mental_ambition INTEGER NOT NULL,
      mental_discipline INTEGER NOT NULL,
      mental_leadership INTEGER NOT NULL,
      pitcher_velocity INTEGER,
      pitcher_control INTEGER,
      pitcher_breaking_ball INTEGER,
      pitcher_pitch_variety INTEGER,
      batter_contact INTEGER,
      batter_power INTEGER,
      batter_plate_discipline INTEGER,
      batter_fielding INTEGER,
      batter_throwing INTEGER,
      batter_base_running INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (player_id) REFERENCES players(id)
    )
  ''';

  /// ポテンシャル能力値テーブル作成SQL
  static const String createPotentialAbilitiesTableSql = '''
    CREATE TABLE IF NOT EXISTS $potentialAbilitiesTableName (
      player_id TEXT PRIMARY KEY,
      physical_strength INTEGER NOT NULL,
      physical_agility INTEGER NOT NULL,
      physical_stamina INTEGER NOT NULL,
      physical_flexibility INTEGER NOT NULL,
      physical_balance INTEGER NOT NULL,
      physical_explosiveness INTEGER NOT NULL,
      mental_concentration INTEGER NOT NULL,
      mental_composure INTEGER NOT NULL,
      mental_decision_making INTEGER NOT NULL,
      mental_ambition INTEGER NOT NULL,
      mental_discipline INTEGER NOT NULL,
      mental_leadership INTEGER NOT NULL,
      pitcher_velocity INTEGER,
      pitcher_control INTEGER,
      pitcher_breaking_ball INTEGER,
      pitcher_pitch_variety INTEGER,
      batter_contact INTEGER,
      batter_power INTEGER,
      batter_plate_discipline INTEGER,
      batter_fielding INTEGER,
      batter_throwing INTEGER,
      batter_base_running INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (player_id) REFERENCES players(id)
    )
  ''';

  /// スカウト分析能力値テーブル作成SQL
  static const String createScoutedAbilitiesTableSql = '''
    CREATE TABLE IF NOT EXISTS $scoutedAbilitiesTableName (
      player_id TEXT PRIMARY KEY,
      physical_strength INTEGER NOT NULL,
      physical_agility INTEGER NOT NULL,
      physical_stamina INTEGER NOT NULL,
      physical_flexibility INTEGER NOT NULL,
      physical_balance INTEGER NOT NULL,
      physical_explosiveness INTEGER NOT NULL,
      mental_concentration INTEGER NOT NULL,
      mental_composure INTEGER NOT NULL,
      mental_decision_making INTEGER NOT NULL,
      mental_ambition INTEGER NOT NULL,
      mental_discipline INTEGER NOT NULL,
      mental_leadership INTEGER NOT NULL,
      pitcher_velocity INTEGER,
      pitcher_control INTEGER,
      pitcher_breaking_ball INTEGER,
      pitcher_pitch_variety INTEGER,
      batter_contact INTEGER,
      batter_power INTEGER,
      batter_plate_discipline INTEGER,
      batter_fielding INTEGER,
      batter_throwing INTEGER,
      batter_base_running INTEGER,
      scout_accuracy REAL NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (player_id) REFERENCES players(id)
    )
  ''';

  /// インデックス作成SQL
  static const String createIndexesSql = '''
    CREATE INDEX IF NOT EXISTS idx_players_school_id ON $tableName(school_id);
    CREATE INDEX IF NOT EXISTS idx_players_position ON $tableName(position);
    CREATE INDEX IF NOT EXISTS idx_players_grade ON $tableName(grade);
    CREATE INDEX IF NOT EXISTS idx_players_talent_rank ON $tableName(talent_rank);
    CREATE INDEX IF NOT EXISTS idx_players_discovered_date ON $tableName(discovered_date);
  ''';

  /// 選手挿入SQL
  static const String insertPlayerSql = '''
    INSERT INTO $tableName (
      id, name, age, grade, position, school_id, discovered_date, 
      scout_skill_used, talent_rank, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// 現在能力値挿入SQL
  static const String insertCurrentAbilitiesSql = '''
    INSERT INTO $currentAbilitiesTableName (
      player_id, physical_strength, physical_agility, physical_stamina, 
      physical_flexibility, physical_balance, physical_explosiveness,
      mental_concentration, mental_composure, mental_decision_making,
      mental_ambition, mental_discipline, mental_leadership,
      pitcher_velocity, pitcher_control, pitcher_breaking_ball, pitcher_pitch_variety,
      batter_contact, batter_power, batter_plate_discipline,
      batter_fielding, batter_throwing, batter_base_running,
      created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// ポテンシャル能力値挿入SQL
  static const String insertPotentialAbilitiesSql = '''
    INSERT INTO $potentialAbilitiesTableName (
      player_id, physical_strength, physical_agility, physical_stamina, 
      physical_flexibility, physical_balance, physical_explosiveness,
      mental_concentration, mental_composure, mental_decision_making,
      mental_ambition, mental_discipline, mental_leadership,
      pitcher_velocity, pitcher_control, pitcher_breaking_ball, pitcher_pitch_variety,
      batter_contact, batter_power, batter_plate_discipline,
      batter_fielding, batter_throwing, batter_base_running,
      created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// スカウト分析能力値挿入SQL
  static const String insertScoutedAbilitiesSql = '''
    INSERT INTO $scoutedAbilitiesTableName (
      player_id, physical_strength, physical_agility, physical_stamina, 
      physical_flexibility, physical_balance, physical_explosiveness,
      mental_concentration, mental_composure, mental_decision_making,
      mental_ambition, mental_discipline, mental_leadership,
      pitcher_velocity, pitcher_control, pitcher_breaking_ball, pitcher_pitch_variety,
      batter_contact, batter_power, batter_plate_discipline,
      batter_fielding, batter_throwing, batter_base_running,
      scout_accuracy, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  /// 選手をIDで取得するSQL
  static const String selectPlayerByIdSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    WHERE p.id = ?
  ''';

  /// 学校IDで選手を取得するSQL
  static const String selectPlayersBySchoolIdSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    WHERE p.school_id = ?
    ORDER BY p.grade, p.name
  ''';

  /// 学年で選手を取得するSQL
  static const String selectPlayersByGradeSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    WHERE p.grade = ?
    ORDER BY p.school_id, p.name
  ''';

  /// ポジションで選手を取得するSQL
  static const String selectPlayersByPositionSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    WHERE p.position = ?
    ORDER BY p.school_id, p.grade, p.name
  ''';

  /// 才能ランクで選手を取得するSQL
  static const String selectPlayersByTalentRankSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    WHERE p.talent_rank = ?
    ORDER BY p.school_id, p.grade, p.name
  ''';

  /// 全選手を取得するSQL
  static const String selectAllPlayersSql = '''
    SELECT p.*, 
           ca.*, pa.*, sa.*
    FROM $tableName p
    LEFT JOIN $currentAbilitiesTableName ca ON p.id = ca.player_id
    LEFT JOIN $potentialAbilitiesTableName pa ON p.id = pa.player_id
    LEFT JOIN $scoutedAbilitiesTableName sa ON p.id = sa.player_id
    ORDER BY p.school_id, p.grade, p.name
  ''';

  /// 選手数を取得するSQL
  static const String countPlayersSql = '''
    SELECT COUNT(*) FROM $tableName
  ''';

  /// 学校別の選手数を取得するSQL
  static const String countPlayersBySchoolSql = '''
    SELECT school_id, COUNT(*) as count 
    FROM $tableName 
    GROUP BY school_id 
    ORDER BY count DESC
  ''';

  /// 学年別の選手数を取得するSQL
  static const String countPlayersByGradeSql = '''
    SELECT grade, COUNT(*) as count 
    FROM $tableName 
    GROUP BY grade 
    ORDER BY grade
  ''';

  /// ポジション別の選手数を取得するSQL
  static const String countPlayersByPositionSql = '''
    SELECT position, COUNT(*) as count 
    FROM $tableName 
    GROUP BY position 
    ORDER BY count DESC
  ''';

  /// 才能ランク別の選手数を取得するSQL
  static const String countPlayersByTalentRankSql = '''
    SELECT talent_rank, COUNT(*) as count 
    FROM $tableName 
    GROUP BY talent_rank 
    ORDER BY talent_rank
  ''';

  /// 選手を削除するSQL
  static const String deletePlayerSql = '''
    DELETE FROM $tableName WHERE id = ?
  ''';

  /// 現在能力値を更新するSQL
  static const String updateCurrentAbilitiesSql = '''
    UPDATE $currentAbilitiesTableName SET
      physical_strength = ?, physical_agility = ?, physical_stamina = ?,
      physical_flexibility = ?, physical_balance = ?, physical_explosiveness = ?,
      mental_concentration = ?, mental_composure = ?, mental_decision_making = ?,
      mental_ambition = ?, mental_discipline = ?, mental_leadership = ?,
      pitcher_velocity = ?, pitcher_control = ?, pitcher_breaking_ball = ?, pitcher_pitch_variety = ?,
      batter_contact = ?, batter_power = ?, batter_plate_discipline = ?,
      batter_fielding = ?, batter_throwing = ?, batter_base_running = ?,
      updated_at = ?
    WHERE player_id = ?
  ''';

  /// スカウト分析能力値を更新するSQL
  static const String updateScoutedAbilitiesSql = '''
    UPDATE $scoutedAbilitiesTableName SET
      physical_strength = ?, physical_agility = ?, physical_stamina = ?,
      physical_flexibility = ?, physical_balance = ?, physical_explosiveness = ?,
      mental_concentration = ?, mental_composure = ?, mental_decision_making = ?,
      mental_ambition = ?, mental_discipline = ?, mental_leadership = ?,
      pitcher_velocity = ?, pitcher_control = ?, pitcher_breaking_ball = ?, pitcher_pitch_variety = ?,
      batter_contact = ?, batter_power = ?, batter_plate_discipline = ?,
      batter_fielding = ?, batter_throwing = ?, batter_base_running = ?,
      scout_accuracy = ?, updated_at = ?
    WHERE player_id = ?
  ''';

  /// テーブルをクリアするSQL
  static const String clearTablesSql = '''
    DELETE FROM $scoutedAbilitiesTableName;
    DELETE FROM $potentialAbilitiesTableName;
    DELETE FROM $currentAbilitiesTableName;
    DELETE FROM $tableName;
  ''';
}
