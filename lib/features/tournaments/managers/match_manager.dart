import 'dart:async';
import '../../../core/domain/entities/game_match.dart';
import '../../../core/domain/entities/tournament.dart';
import '../../../core/domain/repositories/tournament_repository.dart';

/// 試合管理のマネージャークラス
class MatchManager {
  final TournamentRepository _repository;
  final StreamController<List<GameMatch>> _matchesController;
  final StreamController<GameMatch?> _currentMatchController;

  MatchManager(this._repository)
      : _matchesController = StreamController<List<GameMatch>>.broadcast(),
        _currentMatchController = StreamController<GameMatch?>.broadcast();

  // Streams
  Stream<List<GameMatch>> get matchesStream => _matchesController.stream;
  Stream<GameMatch?> get currentMatchStream => _currentMatchController.stream;

  // Match management
  /// 試合をスケジュール
  Future<GameMatch?> scheduleMatch({
    required String tournamentId,
    required String homeSchoolId,
    required String awaySchoolId,
    required DateTime scheduledDate,
    required List<String> homePlayers,
    required List<String> awayPlayers,
  }) async {
    try {
      final match = GameMatch.initial(
        tournamentId: tournamentId,
        homeSchoolId: homeSchoolId,
        awaySchoolId: awaySchoolId,
        scheduledDate: scheduledDate,
        homePlayers: homePlayers,
        awayPlayers: awayPlayers,
      );

      if (await _repository.validateGameMatchData(match)) {
        await _repository.saveGameMatch(match);
        await _refreshMatches();
        return match;
      }
      return null;
    } catch (e) {
      print('試合スケジュールに失敗: $e');
      return null;
    }
  }

  /// 試合を開始
  Future<bool> startMatch(String matchId) async {
    try {
      final match = await _repository.loadGameMatch(matchId);
      if (match == null) return false;

      final startedMatch = match.start();
      await _repository.saveGameMatch(startedMatch);
      _currentMatchController.add(startedMatch);
      await _refreshMatches();
      return true;
    } catch (e) {
      print('試合開始に失敗: $e');
      return false;
    }
  }

  /// 試合を終了
  Future<bool> completeMatch({
    required String matchId,
    required int homeScore,
    required int awayScore,
    required int innings,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required Map<String, String> performances,
  }) async {
    try {
      final match = await _repository.loadGameMatch(matchId);
      if (match == null) return false;

      // パフォーマンスを変換
      final playerPerformances = <String, PlayerPerformance>{};
      performances.forEach((playerId, performanceName) {
        final performance = PlayerPerformance.values.firstWhere(
          (p) => p.name == performanceName,
          orElse: () => PlayerPerformance.average,
        );
        playerPerformances[playerId] = performance;
      });

      final completedMatch = match.complete(
        homeScore: homeScore,
        awayScore: awayScore,
        innings: innings,
        homeStats: homeStats,
        awayStats: awayStats,
        performances: playerPerformances,
      );

      await _repository.saveGameMatch(completedMatch);
      _currentMatchController.add(null);
      await _refreshMatches();
      return true;
    } catch (e) {
      print('試合終了に失敗: $e');
      return false;
    }
  }

  /// 試合を中止
  Future<bool> cancelMatch(String matchId, String reason) async {
    try {
      final match = await _repository.loadGameMatch(matchId);
      if (match == null) return false;

      final cancelledMatch = match.cancel(reason: reason);
      await _repository.saveGameMatch(cancelledMatch);
      await _refreshMatches();
      return true;
    } catch (e) {
      print('試合中止に失敗: $e');
      return false;
    }
  }

  // Match queries
  /// 全ての試合を取得
  Future<List<GameMatch>> getAllMatches() async {
    try {
      return await _repository.loadAllGameMatches();
    } catch (e) {
      print('試合一覧取得に失敗: $e');
      return [];
    }
  }

  /// 大会別の試合を取得
  Future<List<GameMatch>> getMatchesByTournament(String tournamentId) async {
    try {
      return await _repository.loadGameMatchesByTournament(tournamentId);
    } catch (e) {
      print('大会別試合取得に失敗: $e');
      return [];
    }
  }

  /// 学校別の試合を取得
  Future<List<GameMatch>> getMatchesBySchool(String schoolId) async {
    try {
      return await _repository.loadGameMatchesBySchool(schoolId);
    } catch (e) {
      print('学校別試合取得に失敗: $e');
      return [];
    }
  }

  /// 状態別の試合を取得
  Future<List<GameMatch>> getMatchesByStatus(MatchStatus status) async {
    try {
      return await _repository.loadGameMatchesByStatus(status.name);
    } catch (e) {
      print('状態別試合取得に失敗: $e');
      return [];
    }
  }

  /// 日付範囲の試合を取得
  Future<List<GameMatch>> getMatchesByDateRange(DateTime start, DateTime end) async {
    try {
      return await _repository.loadGameMatchesByDateRange(start, end);
    } catch (e) {
      print('日付範囲試合取得に失敗: $e');
      return [];
    }
  }

  /// 特定の試合を取得
  Future<GameMatch?> getMatch(String matchId) async {
    try {
      return await _repository.loadGameMatch(matchId);
    } catch (e) {
      print('試合取得に失敗: $e');
      return null;
    }
  }

  // Tournament bracket management
  /// トーナメント形式で試合をスケジュール
  Future<List<GameMatch>> scheduleTournamentMatches({
    required String tournamentId,
    required List<String> schoolIds,
    required DateTime startDate,
  }) async {
    try {
      final matches = <GameMatch>[];
      final shuffledSchools = List<String>.from(schoolIds)..shuffle();
      
      // 2校ずつペアにして試合を作成
      for (int i = 0; i < shuffledSchools.length - 1; i += 2) {
        final homeSchool = shuffledSchools[i];
        final awaySchool = shuffledSchools[i + 1];
        
        // 仮の選手リスト（実際の実装では学校から選手を取得）
        final homePlayers = ['player_${homeSchool}_1', 'player_${homeSchool}_2'];
        final awayPlayers = ['player_${awaySchool}_1', 'player_${awaySchool}_2'];
        
        final match = await scheduleMatch(
          tournamentId: tournamentId,
          homeSchoolId: homeSchool,
          awaySchoolId: awaySchool,
          scheduledDate: startDate.add(Duration(days: i ~/ 2)),
          homePlayers: homePlayers,
          awayPlayers: awayPlayers,
        );
        
        if (match != null) {
          matches.add(match);
        }
      }
      
      return matches;
    } catch (e) {
      print('トーナメント試合スケジュールに失敗: $e');
      return [];
    }
  }

  // Match statistics
  /// 試合統計を取得
  Future<Map<String, dynamic>> getMatchStatistics() async {
    try {
      final matches = await getAllMatches();
      final completedMatches = matches.where((m) => m.isCompleted).toList();
      
      if (completedMatches.isEmpty) {
        return {
          'totalMatches': 0,
          'completedMatches': 0,
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
        'totalMatches': matches.length,
        'completedMatches': completedMatches.length,
        'averageScore': totalRuns / completedMatches.length,
        'totalRuns': totalRuns,
        'totalHits': totalHits,
      };
    } catch (e) {
      print('試合統計取得に失敗: $e');
      return {};
    }
  }

  /// 学校の試合成績を取得
  Future<Map<String, dynamic>> getSchoolMatchRecord(String schoolId) async {
    try {
      final matches = await getMatchesBySchool(schoolId);
      final completedMatches = matches.where((m) => m.isCompleted).toList();
      
      int wins = 0;
      int losses = 0;
      int totalRunsScored = 0;
      int totalRunsAllowed = 0;
      
      for (final match in completedMatches) {
        final isHome = match.homeSchoolId == schoolId;
        final schoolScore = isHome ? match.homeScore ?? 0 : match.awayScore ?? 0;
        final opponentScore = isHome ? match.awayScore ?? 0 : match.homeScore ?? 0;
        
        totalRunsScored += schoolScore;
        totalRunsAllowed += opponentScore;
        
        if (schoolScore > opponentScore) {
          wins++;
        } else {
          losses++;
        }
      }
      
      return {
        'schoolId': schoolId,
        'totalMatches': completedMatches.length,
        'wins': wins,
        'losses': losses,
        'winPercentage': completedMatches.isEmpty ? 0.0 : wins / completedMatches.length,
        'totalRunsScored': totalRunsScored,
        'totalRunsAllowed': totalRunsAllowed,
        'runDifferential': totalRunsScored - totalRunsAllowed,
      };
    } catch (e) {
      print('学校試合成績取得に失敗: $e');
      return {};
    }
  }

  // Utility methods
  /// 試合の有効性をチェック
  bool isValidMatch(GameMatch match) {
    return match.homeSchoolId.isNotEmpty &&
           match.awaySchoolId.isNotEmpty &&
           match.scheduledDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  /// 試合の進行状況を取得
  String getMatchProgress(GameMatch match) {
    if (match.isCompleted) return '終了';
    if (match.isInProgress) return '試合中';
    if (match.isScheduled) return '予定';
    return '不明';
  }

  // Refresh methods
  Future<void> _refreshMatches() async {
    try {
      final matches = await getAllMatches();
      _matchesController.add(matches);
    } catch (e) {
      print('試合一覧更新に失敗: $e');
    }
  }

  // Cleanup
  void dispose() {
    _matchesController.close();
    _currentMatchController.close();
  }
}
