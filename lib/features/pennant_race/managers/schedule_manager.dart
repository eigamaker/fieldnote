import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/pennant_race.dart';
import '../../../core/domain/repositories/pennant_race_repository.dart';

class ScheduleManager {
  final PennantRaceRepository _repository;
  final StreamController<List<String>> _weeklyGamesController;
  final StreamController<List<String>> _monthlyGamesController;
  final StreamController<Map<String, dynamic>> _scheduleStatsController;

  ScheduleManager(this._repository)
      : _weeklyGamesController = StreamController<List<String>>.broadcast(),
        _monthlyGamesController = StreamController<List<String>>.broadcast(),
        _scheduleStatsController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<List<String>> get weeklyGamesStream => _weeklyGamesController.stream;
  Stream<List<String>> get monthlyGamesStream => _monthlyGamesController.stream;
  Stream<Map<String, dynamic>> get scheduleStatsStream => _scheduleStatsController.stream;

  // 初期化
  Future<void> initialize() async {
    try {
      // 初期化時の処理
    } catch (e) {
      print('ScheduleManager initialization error: $e');
    }
  }

  // 週間スケジュール取得
  Future<List<String>> getWeeklyGames(String pennantRaceId, int week) async {
    try {
      final games = await _repository.getWeeklyGames(pennantRaceId, week);
      _weeklyGamesController.add(games);
      return games;
    } catch (e) {
      print('Error getting weekly games: $e');
      return [];
    }
  }

  // 月間スケジュール取得
  Future<List<String>> getMonthlyGames(String pennantRaceId, int month) async {
    try {
      final games = await _repository.getMonthlyGames(pennantRaceId, month);
      _monthlyGamesController.add(games);
      return games;
    } catch (e) {
      print('Error getting monthly games: $e');
      return [];
    }
  }

  // 年間スケジュール生成
  Future<List<String>> generateAnnualSchedule(String pennantRaceId, List<String> teamIds, int year) async {
    try {
      final schedule = <String>[];
      final random = Random();
      
      // 各チーム143試合（年間）
      final totalGamesPerTeam = 143;
      final totalGames = (teamIds.length * totalGamesPerTeam) ~/ 2; // 2チームで1試合
      
      // 週3-4試合のペースで進行
      final weeksInSeason = 26;
      final gamesPerWeek = (totalGames / weeksInSeason).ceil();
      
      // リーグ内対戦（同リーグ内で6回戦）
      for (int i = 0; i < teamIds.length; i++) {
        for (int j = i + 1; j < teamIds.length; j++) {
          final team1 = teamIds[i];
          final team2 = teamIds[j];
          
          // ホーム・アウェイ各3試合
          for (int k = 0; k < 3; k++) {
            final gameId = 'game_${year}_${team1}_${team2}_home_$k';
            schedule.add(gameId);
          }
          
          for (int k = 0; k < 3; k++) {
            final gameId = 'game_${year}_${team2}_${team1}_home_$k';
            schedule.add(gameId);
          }
        }
      }
      
      // インターリーグ戦（他リーグとの対戦）
      // 簡易版として、各チームが他リーグと数試合
      final interleagueGamesPerTeam = 20;
      final interleagueTotal = (teamIds.length * interleagueGamesPerTeam) ~/ 2;
      
      for (int i = 0; i < interleagueTotal; i++) {
        final team1Index = random.nextInt(teamIds.length);
        final team2Index = random.nextInt(teamIds.length);
        
        if (team1Index != team2Index) {
          final team1 = teamIds[team1Index];
          final team2 = teamIds[team2Index];
          final gameId = 'game_${year}_${team1}_${team2}_interleague_$i';
          schedule.add(gameId);
        }
      }
      
      // スケジュールをシャッフルしてランダム性を出す
      schedule.shuffle(random);
      
      // 週ごとに分割してスケジュールに登録
      for (int week = 1; week <= weeksInSeason; week++) {
        final startIndex = (week - 1) * gamesPerWeek;
        final endIndex = (week * gamesPerWeek).clamp(0, schedule.length);
        
        if (startIndex < schedule.length) {
          final weeklyGames = schedule.sublist(startIndex, endIndex);
          await _repository.scheduleGames(pennantRaceId, weeklyGames);
        }
      }
      
      return schedule;
    } catch (e) {
      print('Error generating annual schedule: $e');
      return [];
    }
  }

  // 週間スケジュール更新
  Future<bool> updateWeeklySchedule(String pennantRaceId, int week, List<String> gameIds) async {
    try {
      // 既存の週間スケジュールを削除
      final existingGames = await _repository.getWeeklyGames(pennantRaceId, week);
      for (final gameId in existingGames) {
        await _repository.removeGame(pennantRaceId, gameId);
      }
      
      // 新しいスケジュールを追加
      final success = await _repository.scheduleGames(pennantRaceId, gameIds);
      if (success) {
        _weeklyGamesController.add(gameIds);
      }
      return success;
    } catch (e) {
      print('Error updating weekly schedule: $e');
      return false;
    }
  }

  // 月間スケジュール更新
  Future<bool> updateMonthlySchedule(String pennantRaceId, int month, List<String> gameIds) async {
    try {
      // 既存の月間スケジュールを削除
      final existingGames = await _repository.getMonthlyGames(pennantRaceId, month);
      for (final gameId in existingGames) {
        await _repository.removeGame(pennantRaceId, gameId);
      }
      
      // 新しいスケジュールを追加
      final success = await _repository.scheduleGames(pennantRaceId, gameIds);
      if (success) {
        _monthlyGamesController.add(gameIds);
      }
      return success;
    } catch (e) {
      print('Error updating monthly schedule: $e');
      return false;
    }
  }

  // 試合スケジュール追加
  Future<bool> addGameToSchedule(String pennantRaceId, String gameId) async {
    try {
      final success = await _repository.addGame(pennantRaceId, gameId);
      if (success) {
        // 週間・月間スケジュールを更新
        final currentDate = DateTime.now();
        final currentWeek = ((currentDate.difference(DateTime(currentDate.year, 4, 1)).inDays) / 7).ceil();
        final currentMonth = currentDate.month;
        
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, currentWeek);
        _weeklyGamesController.add(weeklyGames);
        
        final monthlyGames = await _repository.getMonthlyGames(pennantRaceId, currentMonth);
        _monthlyGamesController.add(monthlyGames);
      }
      return success;
    } catch (e) {
      print('Error adding game to schedule: $e');
      return false;
    }
  }

  // 試合スケジュール削除
  Future<bool> removeGameFromSchedule(String pennantRaceId, String gameId) async {
    try {
      final success = await _repository.removeGame(pennantRaceId, gameId);
      if (success) {
        // 週間・月間スケジュールを更新
        final currentDate = DateTime.now();
        final currentWeek = ((currentDate.difference(DateTime(currentDate.year, 4, 1)).inDays) / 7).ceil();
        final currentMonth = currentDate.month;
        
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, currentWeek);
        _weeklyGamesController.add(weeklyGames);
        
        final monthlyGames = await _repository.getMonthlyGames(pennantRaceId, currentMonth);
        _monthlyGamesController.add(monthlyGames);
      }
      return success;
    } catch (e) {
      print('Error removing game from schedule: $e');
      return false;
    }
  }

  // 試合再スケジュール
  Future<bool> rescheduleGame(String pennantRaceId, String oldGameId, String newGameId) async {
    try {
      final success = await _repository.rescheduleGame(pennantRaceId, oldGameId, newGameId);
      if (success) {
        // 週間・月間スケジュールを更新
        final currentDate = DateTime.now();
        final currentWeek = ((currentDate.difference(DateTime(currentDate.year, 4, 1)).inDays) / 7).ceil();
        final currentMonth = currentDate.month;
        
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, currentWeek);
        _weeklyGamesController.add(weeklyGames);
        
        final monthlyGames = await _repository.getMonthlyGames(pennantRaceId, currentMonth);
        _monthlyGamesController.add(monthlyGames);
      }
      return success;
    } catch (e) {
      print('Error rescheduling game: $e');
      return false;
    }
  }

  // スケジュール統計取得
  Future<Map<String, dynamic>> getScheduleStatistics(String pennantRaceId) async {
    try {
      final stats = <String, dynamic>{
        'totalGames': 0,
        'scheduledGames': 0,
        'completedGames': 0,
        'cancelledGames': 0,
        'postponedGames': 0,
        'weeklyBreakdown': <String, int>{},
        'monthlyBreakdown': <String, int>{},
        'teamBreakdown': <String, int>{},
      };
      
      // 週間・月間の内訳を計算
      for (int week = 1; week <= 26; week++) {
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, week);
        stats['weeklyBreakdown']['Week $week'] = weeklyGames.length;
        stats['totalGames'] += weeklyGames.length;
      }
      
      for (int month = 4; month <= 10; month++) {
        final monthlyGames = await _repository.getMonthlyGames(pennantRaceId, month);
        stats['monthlyBreakdown']['Month $month'] = monthlyGames.length;
      }
      
      _scheduleStatsController.add(stats);
      return stats;
    } catch (e) {
      print('Error getting schedule statistics: $e');
      return {};
    }
  }

  // スケジュール最適化
  Future<bool> optimizeSchedule(String pennantRaceId, List<String> teamIds) async {
    try {
      // 簡易的なスケジュール最適化
      // 連続試合を避ける、移動距離を考慮するなど
      
      final currentDate = DateTime.now();
      final currentWeek = ((currentDate.difference(DateTime(currentDate.year, 4, 1)).inDays) / 7).ceil();
      
      // 現在の週以降のスケジュールを最適化
      for (int week = currentWeek; week <= 26; week++) {
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, week);
        
        if (weeklyGames.length > 4) {
          // 週4試合を超える場合は調整
          final optimizedGames = weeklyGames.take(4).toList();
          await updateWeeklySchedule(pennantRaceId, week, optimizedGames);
        }
      }
      
      return true;
    } catch (e) {
      print('Error optimizing schedule: $e');
      return false;
    }
  }

  // スケジュール検証
  Future<List<String>> validateSchedule(String pennantRaceId) async {
    try {
      final issues = <String>[];
      
      // 各チームの試合数をチェック
      final teamGameCounts = <String, int>{};
      
      for (int week = 1; week <= 26; week++) {
        final weeklyGames = await _repository.getWeeklyGames(pennantRaceId, week);
        
        for (final gameId in weeklyGames) {
          // ゲームIDからチーム名を抽出（簡易版）
          final parts = gameId.split('_');
          if (parts.length >= 3) {
            final team1 = parts[2];
            final team2 = parts[3];
            
            teamGameCounts[team1] = (teamGameCounts[team1] ?? 0) + 1;
            teamGameCounts[team2] = (teamGameCounts[team2] ?? 0) + 1;
          }
        }
      }
      
      // 各チームが143試合あるかチェック
      for (final entry in teamGameCounts.entries) {
        if (entry.value != 143) {
          issues.add('${entry.key}: ${entry.value} games (expected 143)');
        }
      }
      
      return issues;
    } catch (e) {
      print('Error validating schedule: $e');
      return ['Schedule validation error: $e'];
    }
  }

  // リソース解放
  void dispose() {
    _weeklyGamesController.close();
    _monthlyGamesController.close();
    _scheduleStatsController.close();
  }
}
