import 'dart:math';
import 'package:sqflite/sqflite.dart';
import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/player_ability_values.dart';
import '../../../core/domain/entities/player_physical_abilities.dart';
import '../../../core/domain/entities/player_mental_abilities.dart';
import '../../../core/domain/entities/player_pitcher_technical_abilities.dart';
import '../../../core/domain/entities/player_batter_technical_abilities.dart';
import '../../../core/domain/entities/player_abilities.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/data/database/database_manager.dart';
import '../../../core/data/database/player_table.dart';

/// 選手生成を管理するマネージャークラス
class PlayerGenerationManager {
  static final Random _random = Random();

  /// 選手生成の設定
  static const Map<String, dynamic> generationConfig = {
    'gameStart': {
      'minPlayers': 100,
      'maxPlayers': 200,
      'talentRankDistribution': {
        1: 0.70,  // 70%
        2: 0.23,  // 23%
        3: 0.05,  // 5%
        4: 0.02,  // 2%
        5: 0.01,  // 1%
        6: 0.0004, // 0.04%
      },
    },
    'scouting': {
      'minPlayers': 1,
      'maxPlayers': 3,
      'talentRankDistribution': {
        1: 0.50,  // 50%
        2: 0.30,  // 30%
        3: 0.15,  // 15%
        4: 0.04,  // 4%
        5: 0.01,  // 1%
        6: 0.0004, // 0.04%
      },
    },
  };

  /// ゲーム開始時の選手生成
  static Future<List<Player>> generateGameStartPlayers({
    required List<School> schools,
    required double scoutSkill,
  }) async {
    try {
      print('ゲーム開始時の選手生成を開始...');
      
      final config = generationConfig['gameStart'];
      final minPlayers = config['minPlayers'] as int;
      final maxPlayers = config['maxPlayers'] as int;
      final talentDistribution = config['talentRankDistribution'] as Map<int, double>;
      
      // 生成する選手数を決定
      final playerCount = minPlayers + _random.nextInt(maxPlayers - minPlayers + 1);
      print('生成する選手数: $playerCount 名');
      
      final players = <Player>[];
      final db = await DatabaseManager.database;
      final batch = db.batch();
      
      for (int i = 0; i < playerCount; i++) {
        try {
          // 学校リストが空の場合はスキップ
          if (schools.isEmpty) {
            print('学校リストが空のため、選手生成をスキップします');
            break;
          }
          
          // ランダムに学校を選択
          final school = schools[_random.nextInt(schools.length)];
          
          // 才能ランクを決定
          final talentRank = _selectTalentRank(talentDistribution);
          
          // ポジションを決定
          final position = _selectPosition(talentRank);
          
          // 学年を決定（1-3年生）
          final grade = 1 + _random.nextInt(3);
          final age = 15 + grade - 1;
          
          // 選手を生成
          final player = await _generatePlayer(
            school: school,
            scoutSkill: scoutSkill,
            talentRank: talentRank,
            position: position,
            grade: grade,
            age: age,
          );
          
          players.add(player);
          
          // データベースに挿入
          await _insertPlayerToDatabase(batch, player);
          
          // 100件ごとにバッチを実行
          if ((i + 1) % 100 == 0) {
            await batch.commit();
            print('${i + 1} 名の選手を生成しました');
          }
        } catch (e) {
          print('選手生成エラー (${i + 1}番目): $e');
          continue;
        }
      }
      
      // 残りのバッチを実行
      if (playerCount % 100 != 0) {
        await batch.commit();
      }
      
      print('ゲーム開始時の選手生成が完了しました: ${players.length} 名');
      await _printGenerationStatistics(players);
      
      return players;
    } catch (e) {
      print('ゲーム開始時の選手生成に失敗しました: $e');
      return [];
    }
  }

  /// スカウトアクション時の選手生成
  static Future<List<Player>> generateScoutingPlayers({
    required School school,
    required double scoutSkill,
    required int maxPlayers,
  }) async {
    try {
      print('スカウトアクション時の選手生成を開始... (学校: ${school.name})');
      
      final config = generationConfig['scouting'];
      final talentDistribution = config['talentRankDistribution'] as Map<int, double>;
      
      // 学校の強度に基づいて発見確率を調整
      final discoveryRate = school.scoutDiscoveryRate;
      final actualMaxPlayers = (maxPlayers * discoveryRate).round();
      final playerCount = max(1, actualMaxPlayers);
      
      print('発見確率: ${(discoveryRate * 100).toInt()}%, 生成する選手数: $playerCount 名');
      
      final players = <Player>[];
      final db = await DatabaseManager.database;
      final batch = db.batch();
      
      for (int i = 0; i < playerCount; i++) {
        try {
          // 才能ランクを決定
          final talentRank = _selectTalentRank(talentDistribution);
          
          // ポジションを決定
          final position = _selectPosition(talentRank);
          
          // 学年を決定（1-3年生）
          final grade = 1 + _random.nextInt(3);
          final age = 15 + grade - 1;
          
          // 選手を生成
          final player = await _generatePlayer(
            school: school,
            scoutSkill: scoutSkill,
            talentRank: talentRank,
            position: position,
            grade: grade,
            age: age,
          );
          
          players.add(player);
          
          // データベースに挿入
          await _insertPlayerToDatabase(batch, player);
        } catch (e) {
          print('選手生成エラー (${i + 1}番目): $e');
          continue;
        }
      }
      
      // バッチを実行
      await batch.commit();
      
      print('スカウトアクション時の選手生成が完了しました: ${players.length} 名');
      
      return players;
    } catch (e) {
      print('スカウトアクション時の選手生成に失敗しました: $e');
      return [];
    }
  }

  /// 才能ランクを選択
  static int _selectTalentRank(Map<int, double> distribution) {
    final randomValue = _random.nextDouble();
    double cumulative = 0.0;
    
    for (final entry in distribution.entries) {
      cumulative += entry.value;
      if (randomValue <= cumulative) {
        return entry.key;
      }
    }
    
    // フォールバック
    return 1;
  }

  /// ポジションを選択
  static String _selectPosition(int talentRank) {
    // 才能ランクが高いほど投手の確率が上がる
    final pitcherProbability = 0.3 + (talentRank - 1) * 0.1;
    
    if (_random.nextDouble() < pitcherProbability) {
      return 'P';
    } else {
      // 野手ポジションをランダム選択
      final positions = ['C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF'];
      return positions[_random.nextInt(positions.length)];
    }
  }

  /// 選手を生成
  static Future<Player> _generatePlayer({
    required School school,
    required double scoutSkill,
    required int talentRank,
    required String position,
    required int grade,
    required int age,
  }) async {
    // 名前を生成
    final name = _generatePlayerName();
    
    // 選手IDを生成
    final playerId = 'player_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
    
    // 新しい能力値システムで選手を生成
    final newAbilities = position == 'P' 
        ? PlayerAbilityValues.generatePitcher(scoutSkill: scoutSkill, talentRank: talentRank)
        : PlayerAbilityValues.generateBatter(scoutSkill: scoutSkill, talentRank: talentRank);
    
    // 既存システムとの互換性のため、基本的な能力値も生成
    final abilities = PlayerAbilities.generateHighQuality(scoutSkill);
    
    return Player(
      id: playerId,
      name: name,
      age: age,
      grade: grade,
      position: position,
      abilities: abilities,
      newAbilities: newAbilities,
      schoolId: school.id.toString(),
      discoveredDate: DateTime.now(),
      scoutSkillUsed: scoutSkill,
    );
  }

  /// 選手名を生成
  static String _generatePlayerName() {
    final lastNames = [
      '田中', '佐藤', '鈴木', '高橋', '渡辺', '伊藤', '山本', '中村', '小林', '加藤',
      '吉田', '山田', '佐々木', '山口', '松本', '井上', '木村', '林', '斎藤', '清水',
      '山崎', '森', '池田', '橋本', '阿部', '石川', '山下', '中島', '石井', '小川',
      '前田', '岡田', '長谷川', '藤田', '近藤', '坂本', '福田', '松井', '渡部', '青木',
      '西村', '岡本', '中川', '中野', '原田', '小野', '田村', '竹内', '金子', '和田'
    ];
    
    final firstNames = [
      '翔太', '健太', '大輔', '誠', '直樹', '浩二', '健一', '正人', '博', '明',
      '達也', '智也', '裕也', '剛', '勇', '進', '学', '悟', '聡', '優',
      '和也', '健二', '正義', '正雄', '正一', '正二', '正三', '正四', '正五', '正六'
    ];
    
    final lastName = lastNames[_random.nextInt(lastNames.length)];
    final firstName = firstNames[_random.nextInt(firstNames.length)];
    return '$lastName $firstName';
  }

  /// 選手をデータベースに挿入
  static Future<void> _insertPlayerToDatabase(Batch batch, Player player) async {
    final now = DateTime.now().toIso8601String();
    
    // 選手基本情報を挿入
    batch.rawInsert(PlayerTable.insertPlayerSql, [
      player.id,
      player.name,
      player.age,
      player.grade,
      player.position,
      int.parse(player.schoolId),
      player.discoveredDate.toIso8601String(),
      player.scoutSkillUsed,
      player.newAbilities != null ? _getTalentRankFromAbilities(player.newAbilities!) : 1,
      now,
      now,
    ]);
    
    if (player.newAbilities != null) {
      final abilities = player.newAbilities!;
      
      // 現在能力値を挿入
      batch.rawInsert(PlayerTable.insertCurrentAbilitiesSql, [
        player.id,
        abilities.currentPhysical.strength,
        abilities.currentPhysical.agility,
        abilities.currentPhysical.stamina,
        abilities.currentPhysical.flexibility,
        abilities.currentPhysical.balance,
        abilities.currentPhysical.explosiveness,
        abilities.currentMental.concentration,
        abilities.currentMental.composure,
        abilities.currentMental.decisionMaking,
        abilities.currentMental.ambition,
        abilities.currentMental.discipline,
        abilities.currentMental.leadership,
        abilities.currentPitcherTechnical?.velocity,
        abilities.currentPitcherTechnical?.control,
        abilities.currentPitcherTechnical?.breakingBall,
        abilities.currentPitcherTechnical?.pitchVariety,
        abilities.currentBatterTechnical?.contact,
        abilities.currentBatterTechnical?.power,
        abilities.currentBatterTechnical?.plateDiscipline,
        abilities.currentBatterTechnical?.fielding,
        abilities.currentBatterTechnical?.throwing,
        abilities.currentBatterTechnical?.baseRunning,
        now,
        now,
      ]);
      
      // ポテンシャル能力値を挿入
      batch.rawInsert(PlayerTable.insertPotentialAbilitiesSql, [
        player.id,
        abilities.potentialPhysical.strength,
        abilities.potentialPhysical.agility,
        abilities.potentialPhysical.stamina,
        abilities.potentialPhysical.flexibility,
        abilities.potentialPhysical.balance,
        abilities.potentialPhysical.explosiveness,
        abilities.potentialMental.concentration,
        abilities.potentialMental.composure,
        abilities.potentialMental.decisionMaking,
        abilities.potentialMental.ambition,
        abilities.potentialMental.discipline,
        abilities.potentialMental.leadership,
        abilities.potentialPitcherTechnical?.velocity,
        abilities.potentialPitcherTechnical?.control,
        abilities.potentialPitcherTechnical?.breakingBall,
        abilities.potentialPitcherTechnical?.pitchVariety,
        abilities.potentialBatterTechnical?.contact,
        abilities.potentialBatterTechnical?.power,
        abilities.potentialBatterTechnical?.plateDiscipline,
        abilities.potentialBatterTechnical?.fielding,
        abilities.potentialBatterTechnical?.throwing,
        abilities.potentialBatterTechnical?.baseRunning,
        now,
        now,
      ]);
      
      // スカウト分析能力値を挿入
      batch.rawInsert(PlayerTable.insertScoutedAbilitiesSql, [
        player.id,
        abilities.scoutedPhysical.strength,
        abilities.scoutedPhysical.agility,
        abilities.scoutedPhysical.stamina,
        abilities.scoutedPhysical.flexibility,
        abilities.scoutedPhysical.balance,
        abilities.scoutedPhysical.explosiveness,
        abilities.scoutedMental.concentration,
        abilities.scoutedMental.composure,
        abilities.scoutedMental.decisionMaking,
        abilities.scoutedMental.ambition,
        abilities.scoutedMental.discipline,
        abilities.scoutedMental.leadership,
        abilities.scoutedPitcherTechnical?.velocity,
        abilities.scoutedPitcherTechnical?.control,
        abilities.scoutedPitcherTechnical?.breakingBall,
        abilities.scoutedPitcherTechnical?.pitchVariety,
        abilities.scoutedBatterTechnical?.contact,
        abilities.scoutedBatterTechnical?.power,
        abilities.scoutedBatterTechnical?.plateDiscipline,
        abilities.scoutedBatterTechnical?.fielding,
        abilities.scoutedBatterTechnical?.throwing,
        abilities.scoutedBatterTechnical?.baseRunning,
        player.scoutSkillUsed,
        now,
        now,
      ]);
    }
  }

  /// 能力値から才能ランクを推定
  static int _getTalentRankFromAbilities(PlayerAbilityValues abilities) {
    final overall = abilities.potentialOverall;
    if (overall >= 120) return 6;
    if (overall >= 110) return 5;
    if (overall >= 100) return 4;
    if (overall >= 90) return 3;
    if (overall >= 80) return 2;
    return 1;
  }

  /// 生成統計を表示
  static Future<void> _printGenerationStatistics(List<Player> players) async {
    try {
      print('\n=== 選手生成統計 ===');
      print('総選手数: ${players.length} 名');
      
      // 学年別統計
      final gradeCounts = <int, int>{};
      for (final player in players) {
        gradeCounts[player.grade] = (gradeCounts[player.grade] ?? 0) + 1;
      }
      
      print('\n=== 学年別分布 ===');
      for (final entry in gradeCounts.entries.toList()..sort()) {
        print('${entry.key}年生: ${entry.value} 名');
      }
      
      // ポジション別統計
      final positionCounts = <String, int>{};
      for (final player in players) {
        positionCounts[player.position] = (positionCounts[player.position] ?? 0) + 1;
      }
      
      print('\n=== ポジション別分布 ===');
      for (final entry in positionCounts.entries) {
        print('${entry.key}: ${entry.value} 名');
      }
      
      // 才能ランク別統計
      final talentCounts = <int, int>{};
      for (final player in players) {
        if (player.newAbilities != null) {
          final talentRank = _getTalentRankFromAbilities(player.newAbilities!);
          talentCounts[talentRank] = (talentCounts[talentRank] ?? 0) + 1;
        }
      }
      
      print('\n=== 才能ランク別分布 ===');
      for (final entry in talentCounts.entries.toList()..sort()) {
        print('ランク${entry.key}: ${entry.value} 名');
      }
      
    } catch (e) {
      print('統計情報の表示中にエラーが発生しました: $e');
    }
  }
}
