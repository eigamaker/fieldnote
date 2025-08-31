import 'dart:async';
import 'dart:math';
import '../../../core/domain/entities/game_match.dart';
import '../../../core/domain/entities/tournament.dart';
import '../../../core/domain/repositories/tournament_repository.dart';
import '../services/match_calculator.dart';

/// ゲームシミュレーションのマネージャークラス
class GameSimulationManager {
  final TournamentRepository _repository;
  final StreamController<GameMatch?> _simulationController;
  final StreamController<String> _eventController;

  GameSimulationManager(this._repository)
      : _simulationController = StreamController<GameMatch?>.broadcast(),
        _eventController = StreamController<String>.broadcast();

  // Streams
  Stream<GameMatch?> get simulationStream => _simulationController.stream;
  Stream<String> get eventStream => _eventController.stream;

  // Game simulation
  /// 試合をシミュレーション実行
  Future<GameMatch?> simulateMatch(String matchId) async {
    try {
      final match = await _repository.loadGameMatch(matchId);
      if (match == null) return null;

      if (match.status != MatchStatus.scheduled) {
        _addEvent('試合は既に開始済みまたは終了済みです');
        return match;
      }

      // 試合開始
      final startedMatch = match.start();
      await _repository.saveGameMatch(startedMatch);
      _simulationController.add(startedMatch);
      _addEvent('試合開始: ${startedMatch.homeSchoolId} vs ${startedMatch.awaySchoolId}');

      // 試合進行シミュレーション
      final simulatedMatch = await _simulateGameProgress(startedMatch);
      
      // 試合終了
      await _repository.saveGameMatch(simulatedMatch);
      _simulationController.add(null);
      _addEvent('試合終了: ${simulatedMatch.resultSummary}');

      return simulatedMatch;
    } catch (e) {
      print('試合シミュレーションに失敗: $e');
      _addEvent('シミュレーションエラー: $e');
      return null;
    }
  }

  /// 試合の進行をシミュレーション
  Future<GameMatch> _simulateGameProgress(GameMatch match) async {
    final random = Random();
    final maxInnings = 9;
    int currentInning = 1;
    
    Map<String, dynamic> homeStats = Map.from(match.homeTeamStats);
    Map<String, dynamic> awayStats = Map.from(match.awayTeamStats);
    Map<String, PlayerPerformance> performances = Map.from(match.playerPerformances);
    
    int homeScore = 0;
    int awayScore = 0;

    _addEvent('試合進行開始');

    // 各イニングのシミュレーション
    while (currentInning <= maxInnings) {
      _addEvent('${currentInning}回表開始');
      
      // アウェイチームの攻撃
      final awayRuns = _simulateInning(awayStats, random);
      awayScore += awayRuns;
      if (awayRuns > 0) {
        _addEvent('${currentInning}回表: アウェイ${awayRuns}点');
      }

      _addEvent('${currentInning}回裏開始');
      
      // ホームチームの攻撃
      final homeRuns = _simulateInning(homeStats, random);
      homeScore += homeRuns;
      if (homeRuns > 0) {
        _addEvent('${currentInning}回裏: ホーム${homeRuns}点');
      }

      // 7回以降で10点差がついた場合、コールドゲーム
      if (currentInning >= 7 && (homeScore - awayScore).abs() >= 10) {
        _addEvent('${currentInning}回でコールドゲーム');
        break;
      }

      currentInning++;
    }

    // 選手の活躍度を評価
    performances = _evaluatePlayerPerformances(
      homeScore: homeScore,
      awayScore: awayScore,
      homeStats: homeStats,
      awayStats: awayStats,
      homePlayers: match.homePlayerIds,
      awayPlayers: match.awayPlayerIds,
    );

    // 試合結果を確定
    final completedMatch = match.complete(
      homeScore: homeScore,
      awayScore: awayScore,
      innings: currentInning - 1,
      homeStats: homeStats,
      awayStats: awayStats,
      performances: performances,
    );

    _addEvent('試合結果: ホーム${homeScore}-${awayScore} (${currentInning - 1}回)');
    return completedMatch;
  }

  /// 1イニングのシミュレーション
  int _simulateInning(Map<String, dynamic> teamStats, Random random) {
    int runs = 0;
    int outs = 0;
    int baseRunners = 0;
    
    while (outs < 3) {
      // 打席の結果を決定
      final atBatResult = _simulateAtBat(random);
      
      switch (atBatResult) {
        case 'hit':
          teamStats['hits'] = (teamStats['hits'] ?? 0) + 1;
          if (baseRunners == 3) {
            runs++;
            baseRunners = 2;
          } else if (baseRunners == 2) {
            baseRunners = 3;
          } else if (baseRunners == 1) {
            baseRunners = 2;
          }
          baseRunners++;
          break;
        case 'walk':
          teamStats['walks'] = (teamStats['walks'] ?? 0) + 1;
          if (baseRunners == 3) {
            runs++;
            baseRunners = 2;
          } else if (baseRunners == 2) {
            baseRunners = 3;
          } else if (baseRunners == 1) {
            baseRunners = 2;
          }
          baseRunners++;
          break;
        case 'out':
          teamStats['strikeouts'] = (teamStats['strikeouts'] ?? 0) + 1;
          outs++;
          break;
        case 'error':
          teamStats['errors'] = (teamStats['errors'] ?? 0) + 1;
          if (baseRunners == 3) {
            runs++;
            baseRunners = 2;
          } else if (baseRunners == 2) {
            baseRunners = 3;
          } else if (baseRunners == 1) {
            baseRunners = 2;
          }
          baseRunners++;
          break;
      }
    }
    
    return runs;
  }

  /// 打席の結果をシミュレーション
  String _simulateAtBat(Random random) {
    final roll = random.nextDouble();
    
    if (roll < 0.25) return 'hit';      // 25% 安打
    if (roll < 0.35) return 'walk';     // 10% 四球
    if (roll < 0.40) return 'error';    // 5% 失策
    return 'out';                        // 60% アウト
  }

  /// 選手の活躍度を評価
  Map<String, PlayerPerformance> _evaluatePlayerPerformances({
    required int homeScore,
    required int awayScore,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required List<String> homePlayers,
    required List<String> awayPlayers,
  }) {
    final performances = <String, PlayerPerformance>{};
    final random = Random();

    // ホームチーム選手の評価
    for (final playerId in homePlayers) {
      performances[playerId] = _evaluateIndividualPerformance(
        homeScore,
        homeStats,
        random,
      );
    }

    // アウェイチーム選手の評価
    for (final playerId in awayPlayers) {
      performances[playerId] = _evaluateIndividualPerformance(
        awayScore,
        awayStats,
        random,
      );
    }

    return performances;
  }

  /// 個別選手の活躍度を評価
  PlayerPerformance _evaluateIndividualPerformance(
    int teamScore,
    Map<String, dynamic> teamStats,
    Random random,
  ) {
    final baseScore = teamScore * 0.3;
    final hitsBonus = (teamStats['hits'] ?? 0) * 0.1;
    final errorsPenalty = (teamStats['errors'] ?? 0) * 0.2;
    final randomFactor = (random.nextDouble() - 0.5) * 2;
    
    final performanceScore = baseScore + hitsBonus - errorsPenalty + randomFactor;
    
    if (performanceScore >= 3.0) return PlayerPerformance.excellent;
    if (performanceScore >= 1.5) return PlayerPerformance.good;
    if (performanceScore >= -0.5) return PlayerPerformance.average;
    if (performanceScore >= -2.0) return PlayerPerformance.poor;
    return PlayerPerformance.terrible;
  }

  // Tournament simulation
  /// 大会全体をシミュレーション
  Future<bool> simulateTournament(String tournamentId) async {
    try {
      final tournament = await _repository.loadTournament(tournamentId);
      if (tournament == null) return false;

      if (tournament.status != TournamentStatus.upcoming) {
        _addEvent('大会は既に開始済みまたは終了済みです');
        return false;
      }

      // 大会開始
      final startedTournament = tournament.start();
      await _repository.saveTournament(startedTournament);
      _addEvent('大会開始: ${startedTournament.name}');

      // 全ての試合をシミュレーション
      final matches = await _repository.loadGameMatchesByTournament(tournamentId);
      for (final match in matches) {
        await simulateMatch(match.id);
        await Future.delayed(Duration(milliseconds: 500)); // 少し間隔を空ける
      }

      // 大会終了（仮の優勝校を設定）
      final winnerId = tournament.participatingSchoolIds.first;
      final completedTournament = startedTournament.complete(winnerId: winnerId);
      await _repository.saveTournament(completedTournament);
      _addEvent('大会終了: 優勝校 $winnerId');

      return true;
    } catch (e) {
      print('大会シミュレーションに失敗: $e');
      _addEvent('大会シミュレーションエラー: $e');
      return false;
    }
  }

  // Utility methods
  /// イベントを追加
  void _addEvent(String event) {
    _eventController.add(event);
  }

  /// シミュレーション統計を取得
  Future<Map<String, dynamic>> getSimulationStatistics() async {
    try {
      final matches = await _repository.loadAllGameMatches();
      final completedMatches = matches.where((m) => m.isCompleted).toList();
      
      if (completedMatches.isEmpty) {
        return {
          'totalMatches': 0,
          'averageScore': 0.0,
          'totalRuns': 0,
          'totalHits': 0,
        };
      }

      int totalRuns = 0;
      int totalHits = 0;
      
      for (final match in completedMatches) {
        totalRuns += (match.homeScore ?? 0) + (match.awayScore ?? 0);
        totalHits += ((match.homeTeamStats['hits'] ?? 0) as int) + ((match.awayTeamStats['hits'] ?? 0) as int);
      }

      return {
        'totalMatches': completedMatches.length,
        'averageScore': totalRuns / completedMatches.length,
        'totalRuns': totalRuns,
        'totalHits': totalHits,
      };
    } catch (e) {
      print('シミュレーション統計取得に失敗: $e');
      return {};
    }
  }

  // Cleanup
  void dispose() {
    _simulationController.close();
    _eventController.close();
  }
}
