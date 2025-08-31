import 'dart:async';
import '../../../core/domain/entities/tournament.dart';
import '../../../core/domain/entities/game_match.dart';
import '../../../core/domain/entities/tournament_result.dart';
import '../../../core/domain/repositories/tournament_repository.dart';

/// 大会システムのマネージャークラス
class TournamentManager {
  final TournamentRepository _repository;
  final StreamController<List<Tournament>> _tournamentsController;
  final StreamController<List<GameMatch>> _matchesController;
  final StreamController<List<TournamentResult>> _resultsController;

  TournamentManager(this._repository)
      : _tournamentsController = StreamController<List<Tournament>>.broadcast(),
        _matchesController = StreamController<List<GameMatch>>.broadcast(),
        _resultsController = StreamController<List<TournamentResult>>.broadcast();

  // Streams
  Stream<List<Tournament>> get tournamentsStream => _tournamentsController.stream;
  Stream<List<GameMatch>> get matchesStream => _matchesController.stream;
  Stream<List<TournamentResult>> get resultsStream => _resultsController.stream;

  // Tournament management
  /// 大会を作成
  Future<Tournament?> createTournament({
    required String name,
    required TournamentType type,
    required TournamentStage stage,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> schoolIds,
  }) async {
    try {
      final tournament = Tournament.initial(
        name: name,
        type: type,
        stage: stage,
        startDate: startDate,
        endDate: endDate,
        schoolIds: schoolIds,
      );

      if (await _repository.validateTournamentData(tournament)) {
        await _repository.saveTournament(tournament);
        await _refreshTournaments();
        return tournament;
      }
      return null;
    } catch (e) {
      print('大会作成に失敗: $e');
      return null;
    }
  }

  /// 大会を開始
  Future<bool> startTournament(String tournamentId) async {
    try {
      final tournament = await _repository.loadTournament(tournamentId);
      if (tournament == null) return false;

      final startedTournament = tournament.start();
      await _repository.saveTournament(startedTournament);
      await _refreshTournaments();
      return true;
    } catch (e) {
      print('大会開始に失敗: $e');
      return false;
    }
  }

  /// 大会を終了
  Future<bool> completeTournament(String tournamentId, String winnerId) async {
    try {
      final tournament = await _repository.loadTournament(tournamentId);
      if (tournament == null) return false;

      final completedTournament = tournament.complete(winnerId: winnerId);
      await _repository.saveTournament(completedTournament);
      await _refreshTournaments();
      return true;
    } catch (e) {
      print('大会終了に失敗: $e');
      return false;
    }
  }

  /// 大会を削除
  Future<bool> deleteTournament(String tournamentId) async {
    try {
      await _repository.deleteTournament(tournamentId);
      await _refreshTournaments();
      return true;
    } catch (e) {
      print('大会削除に失敗: $e');
      return false;
    }
  }

  // Tournament queries
  /// 全ての大会を取得
  Future<List<Tournament>> getAllTournaments() async {
    try {
      return await _repository.loadAllTournaments();
    } catch (e) {
      print('大会一覧取得に失敗: $e');
      return [];
    }
  }

  /// 種類別の大会を取得
  Future<List<Tournament>> getTournamentsByType(TournamentType type) async {
    try {
      return await _repository.loadTournamentsByType(type.name);
    } catch (e) {
      print('種類別大会取得に失敗: $e');
      return [];
    }
  }

  /// 状態別の大会を取得
  Future<List<Tournament>> getTournamentsByStatus(TournamentStatus status) async {
    try {
      return await _repository.loadTournamentsByStatus(status.name);
    } catch (e) {
      print('状態別大会取得に失敗: $e');
      return [];
    }
  }

  /// 日付範囲の大会を取得
  Future<List<Tournament>> getTournamentsByDateRange(DateTime start, DateTime end) async {
    try {
      return await _repository.loadTournamentsByDateRange(start, end);
    } catch (e) {
      print('日付範囲大会取得に失敗: $e');
      return [];
    }
  }

  /// 特定の大会を取得
  Future<Tournament?> getTournament(String tournamentId) async {
    try {
      return await _repository.loadTournament(tournamentId);
    } catch (e) {
      print('大会取得に失敗: $e');
      return null;
    }
  }

  // Tournament scheduling
  /// 年間大会スケジュールを作成
  Future<List<Tournament>> createAnnualSchedule({
    required int year,
    required List<String> availableSchools,
  }) async {
    try {
      final tournaments = <Tournament>[];

      // 春の大会（3月）
      final springTournament = await createTournament(
        name: '${year}年春の大会',
        type: TournamentType.spring,
        stage: TournamentStage.prefectural,
        startDate: DateTime(year, 3, 15),
        endDate: DateTime(year, 3, 30),
        schoolIds: availableSchools.take(16).toList(),
      );
      if (springTournament != null) tournaments.add(springTournament);

      // 夏の大会（7月）
      final summerTournament = await createTournament(
        name: '${year}年夏の大会',
        type: TournamentType.summer,
        stage: TournamentStage.national,
        startDate: DateTime(year, 7, 1),
        endDate: DateTime(year, 7, 31),
        schoolIds: availableSchools.take(32).toList(),
      );
      if (summerTournament != null) tournaments.add(summerTournament);

      // 秋の大会（10月）
      final fallTournament = await createTournament(
        name: '${year}年秋の大会',
        type: TournamentType.fall,
        stage: TournamentStage.regional,
        startDate: DateTime(year, 10, 15),
        endDate: DateTime(year, 10, 30),
        schoolIds: availableSchools.take(24).toList(),
      );
      if (fallTournament != null) tournaments.add(fallTournament);

      return tournaments;
    } catch (e) {
      print('年間スケジュール作成に失敗: $e');
      return [];
    }
  }

  // Tournament progression
  /// 大会を進行
  Future<bool> advanceTournament(String tournamentId) async {
    try {
      return await _repository.advanceTournament(tournamentId);
    } catch (e) {
      print('大会進行に失敗: $e');
      return false;
    }
  }

  /// 大会の進行状況を取得
  double getTournamentProgress(Tournament tournament) {
    return tournament.progress;
  }

  /// 大会の統計を取得
  Future<Map<String, dynamic>> getTournamentStatistics() async {
    try {
      return await _repository.getTournamentStatistics();
    } catch (e) {
      print('大会統計取得に失敗: $e');
      return {};
    }
  }

  // Utility methods
  /// 大会の有効性をチェック
  bool isValidTournament(Tournament tournament) {
    return tournament.startDate.isBefore(tournament.endDate) &&
           tournament.participatingSchoolIds.isNotEmpty;
  }

  /// 大会の参加校数を取得
  int getParticipantCount(Tournament tournament) {
    return tournament.participantCount;
  }

  /// 大会の試合数を取得
  int getMatchCount(Tournament tournament) {
    return tournament.matchIds.length;
  }

  // Refresh methods
  Future<void> _refreshTournaments() async {
    try {
      final tournaments = await getAllTournaments();
      _tournamentsController.add(tournaments);
    } catch (e) {
      print('大会一覧更新に失敗: $e');
    }
  }

  Future<void> _refreshMatches() async {
    try {
      final matches = await _repository.loadAllGameMatches();
      _matchesController.add(matches);
    } catch (e) {
      print('試合一覧更新に失敗: $e');
    }
  }

  Future<void> _refreshResults() async {
    try {
      final results = await _repository.loadAllTournamentResults();
      _resultsController.add(results);
    } catch (e) {
      print('結果一覧更新に失敗: $e');
    }
  }

  // Cleanup
  void dispose() {
    _tournamentsController.close();
    _matchesController.close();
    _resultsController.close();
  }
}
