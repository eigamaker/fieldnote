import '../entities/tournament.dart';
import '../entities/game_match.dart';
import '../entities/tournament_result.dart';

/// 大会システムのリポジトリインターフェース
abstract class TournamentRepository {
  // Tournament related
  Future<void> saveTournament(Tournament tournament);
  Future<Tournament?> loadTournament(String tournamentId);
  Future<List<Tournament>> loadAllTournaments();
  Future<List<Tournament>> loadTournamentsByType(String type);
  Future<List<Tournament>> loadTournamentsByStatus(String status);
  Future<List<Tournament>> loadTournamentsByDateRange(DateTime start, DateTime end);
  Future<void> deleteTournament(String tournamentId);
  Future<bool> hasTournament(String tournamentId);

  // GameMatch related
  Future<void> saveGameMatch(GameMatch gameMatch);
  Future<GameMatch?> loadGameMatch(String matchId);
  Future<List<GameMatch>> loadAllGameMatches();
  Future<List<GameMatch>> loadGameMatchesByTournament(String tournamentId);
  Future<List<GameMatch>> loadGameMatchesBySchool(String schoolId);
  Future<List<GameMatch>> loadGameMatchesByStatus(String status);
  Future<List<GameMatch>> loadGameMatchesByDateRange(DateTime start, DateTime end);
  Future<void> deleteGameMatch(String matchId);
  Future<bool> hasGameMatch(String matchId);

  // TournamentResult related
  Future<void> saveTournamentResult(TournamentResult result);
  Future<TournamentResult?> loadTournamentResult(String tournamentId);
  Future<List<TournamentResult>> loadAllTournamentResults();
  Future<List<TournamentResult>> loadTournamentResultsByDateRange(DateTime start, DateTime end);
  Future<void> deleteTournamentResult(String tournamentId);
  Future<bool> hasTournamentResult(String tournamentId);

  // Bulk operations
  Future<void> saveAllTournamentData({
    required List<Tournament> tournaments,
    required List<GameMatch> gameMatches,
    required List<TournamentResult> results,
  });

  Future<Map<String, dynamic>> loadAllTournamentData();

  // Statistical queries
  Future<Map<String, dynamic>> getTournamentStatistics();
  Future<Map<String, dynamic>> getSchoolTournamentHistory(String schoolId);
  Future<Map<String, dynamic>> getPlayerTournamentPerformance(String playerId);
  Future<List<Map<String, dynamic>>> getTopPerformingSchools({int limit = 10});
  Future<List<Map<String, dynamic>>> getTopScoringMatches({int limit = 10});

  // Tournament management
  Future<List<String>> getAvailableSchoolsForTournament({
    required String tournamentType,
    required DateTime startDate,
    required int maxParticipants,
  });

  Future<bool> createTournamentBracket(String tournamentId, List<String> schoolIds);
  Future<bool> advanceTournament(String tournamentId);
  Future<bool> completeTournament(String tournamentId, String winnerId, String runnerUpId);

  // Match management
  Future<bool> scheduleMatch({
    required String tournamentId,
    required String homeSchoolId,
    required String awaySchoolId,
    required DateTime scheduledDate,
    required List<String> homePlayers,
    required List<String> awayPlayers,
  });

  Future<bool> startMatch(String matchId);
  Future<bool> completeMatch({
    required String matchId,
    required int homeScore,
    required int awayScore,
    required int innings,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required Map<String, String> performances,
  });

  Future<bool> cancelMatch(String matchId, String reason);

  // Data validation
  Future<bool> validateTournamentData(Tournament tournament);
  Future<bool> validateGameMatchData(GameMatch gameMatch);
  Future<bool> validateTournamentResultData(TournamentResult result);

  // Cleanup operations
  Future<void> cleanupOldTournaments(DateTime cutoffDate);
  Future<void> cleanupOldGameMatches(DateTime cutoffDate);
  Future<void> cleanupOldTournamentResults(DateTime cutoffDate);
}
