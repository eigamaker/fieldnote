import 'dart:math';
import '../../../core/domain/entities/game_match.dart';

/// 試合計算のサービスクラス
class MatchCalculator {
  static final Random _random = Random();

  /// 試合結果を計算
  static Map<String, dynamic> calculateMatchResult({
    required Map<String, dynamic> homeTeamStats,
    required Map<String, dynamic> awayTeamStats,
    required double homeTeamStrength,
    required double awayTeamStrength,
    double luckFactor = 0.0,
  }) {
    // 基本スコア計算
    final homeBaseScore = _calculateBaseScore(homeTeamStats, homeTeamStrength);
    final awayBaseScore = _calculateBaseScore(awayTeamStats, awayTeamStrength);

    // 運の要素を追加
    final homeLuck = (_random.nextDouble() - 0.5) * luckFactor;
    final awayLuck = (_random.nextDouble() - 0.5) * luckFactor;

    // 最終スコアを計算
    final homeScore = (homeBaseScore + homeLuck).round().clamp(0, 20);
    final awayScore = (awayBaseScore + awayLuck).round().clamp(0, 20);

    return {
      'homeScore': homeScore,
      'awayScore': awayScore,
      'winner': homeScore > awayScore ? 'home' : 'away',
      'totalRuns': homeScore + awayScore,
      'runDifferential': (homeScore - awayScore).abs(),
    };
  }

  /// 基本スコアを計算
  static double _calculateBaseScore(Map<String, dynamic> teamStats, double teamStrength) {
    final hits = (teamStats['hits'] ?? 0) as int;
    final walks = (teamStats['walks'] ?? 0) as int;
    final errors = (teamStats['errors'] ?? 0) as int;
    
    // 安打と四球から得点を計算
    final baseRuns = (hits * 0.3) + (walks * 0.2);
    
    // チーム力による補正
    final strengthBonus = (teamStrength - 1.0) * 2.0;
    
    // 失策によるペナルティ
    final errorPenalty = errors * 0.1;
    
    return (baseRuns + strengthBonus - errorPenalty).clamp(0.0, 15.0);
  }

  /// 選手の活躍度を評価
  static PlayerPerformance evaluatePlayerPerformance({
    required int teamScore,
    required Map<String, dynamic> teamStats,
    required double playerSkill,
    double motivation = 1.0,
  }) {
    // 基本スコア
    final baseScore = teamScore * 0.4;
    
    // チーム統計による補正
    final hitsBonus = ((teamStats['hits'] ?? 0) as int) * 0.15;
    final errorsPenalty = ((teamStats['errors'] ?? 0) as int) * 0.25;
    
    // 選手スキルによる補正
    final skillBonus = (playerSkill - 1.0) * 2.0;
    
    // モチベーションによる補正
    final motivationEffect = (motivation - 1.0) * 1.5;
    
    // ランダム要素
    final randomFactor = (_random.nextDouble() - 0.5) * 1.0;
    
    // 総合スコアを計算
    final totalScore = baseScore + hitsBonus - errorsPenalty + skillBonus + motivationEffect + randomFactor;
    
    // 活躍度を判定
    if (totalScore >= 4.0) return PlayerPerformance.excellent;
    if (totalScore >= 2.0) return PlayerPerformance.good;
    if (totalScore >= 0.0) return PlayerPerformance.average;
    if (totalScore >= -2.0) return PlayerPerformance.poor;
    return PlayerPerformance.terrible;
  }

  /// 試合の統計を計算
  static Map<String, dynamic> calculateMatchStatistics({
    required int homeScore,
    required int awayScore,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required int innings,
  }) {
    final totalRuns = homeScore + awayScore;
    final totalHits = ((homeStats['hits'] ?? 0) as int) + ((awayStats['hits'] ?? 0) as int);
    final totalErrors = ((homeStats['errors'] ?? 0) as int) + ((awayStats['errors'] ?? 0) as int);
    final totalWalks = ((homeStats['walks'] ?? 0) as int) + ((awayStats['walks'] ?? 0) as int);
    final totalStrikeouts = ((homeStats['strikeouts'] ?? 0) as int) + ((awayStats['strikeouts'] ?? 0) as int);

    return {
      'totalRuns': totalRuns,
      'totalHits': totalHits,
      'totalErrors': totalErrors,
      'totalWalks': totalWalks,
      'totalStrikeouts': totalStrikeouts,
      'innings': innings,
      'averageRunsPerInning': totalRuns / innings,
      'hitsPerInning': totalHits / innings,
      'errorRate': totalErrors / innings,
    };
  }

  /// 試合の重要度を評価
  static double evaluateMatchImportance({
    required String tournamentType,
    required String tournamentStage,
    required bool isChampionship,
    required int roundNumber,
  }) {
    double importance = 1.0;
    
    // 大会タイプによる重要度
    switch (tournamentType) {
      case 'summer':
        importance *= 1.5; // 夏の大会は重要
        break;
      case 'spring':
        importance *= 1.2;
        break;
      case 'fall':
        importance *= 1.0;
        break;
    }
    
    // 大会段階による重要度
    switch (tournamentStage) {
      case 'national':
        importance *= 2.0; // 全国大会は最重要
        break;
      case 'regional':
        importance *= 1.5;
        break;
      case 'prefectural':
        importance *= 1.0;
        break;
    }
    
    // 決勝戦の場合は重要度を上げる
    if (isChampionship) {
      importance *= 1.5;
    }
    
    // ラウンド数による重要度（後半戦ほど重要）
    importance *= (1.0 + (roundNumber * 0.1));
    
    return importance.clamp(1.0, 5.0);
  }

  /// 試合の予想結果を計算
  static Map<String, dynamic> predictMatchResult({
    required double homeTeamStrength,
    required double awayTeamStrength,
    required Map<String, dynamic> homeTeamStats,
    required Map<String, dynamic> awayTeamStats,
    int simulationCount = 1000,
  }) {
    int homeWins = 0;
    int awayWins = 0;
    int ties = 0;
    final homeScores = <int>[];
    final awayScores = <int>[];

    // 複数回シミュレーションして統計を取る
    for (int i = 0; i < simulationCount; i++) {
      final result = calculateMatchResult(
        homeTeamStats: homeTeamStats,
        awayTeamStats: awayTeamStats,
        homeTeamStrength: homeTeamStrength,
        awayTeamStrength: awayTeamStrength,
        luckFactor: 0.3,
      );

      homeScores.add(result['homeScore'] as int);
      awayScores.add(result['awayScore'] as int);

      if (result['winner'] == 'home') {
        homeWins++;
      } else if (result['winner'] == 'away') {
        awayWins++;
      } else {
        ties++;
      }
    }

    // 平均スコアを計算
    final avgHomeScore = homeScores.reduce((a, b) => a + b) / homeScores.length;
    final avgAwayScore = awayScores.reduce((a, b) => a + b) / awayScores.length;

    return {
      'homeWinRate': homeWins / simulationCount,
      'awayWinRate': awayWins / simulationCount,
      'tieRate': ties / simulationCount,
      'predictedHomeScore': avgHomeScore.round(),
      'predictedAwayScore': avgAwayScore.round(),
      'confidence': _calculatePredictionConfidence(homeWins, awayWins, simulationCount),
    };
  }

  /// 予想の信頼度を計算
  static double _calculatePredictionConfidence(int homeWins, int awayWins, int total) {
    final totalWins = homeWins + awayWins;
    if (totalWins == 0) return 0.0;
    
    final winRate = totalWins / total;
    final confidence = winRate * (1.0 - winRate) * 4.0; // 0.0-1.0の範囲
    
    return confidence.clamp(0.0, 1.0);
  }

  /// 選手のMVP候補を評価
  static List<Map<String, dynamic>> evaluateMVPCandidates({
    required Map<String, PlayerPerformance> performances,
    required Map<String, String> playerNames,
    required Map<String, dynamic> teamStats,
  }) {
    final candidates = <Map<String, dynamic>>[];
    
    performances.forEach((playerId, performance) {
      final playerName = playerNames[playerId] ?? 'Unknown Player';
      final performanceScore = _performanceToScore(performance);
      final teamContribution = _calculateTeamContribution(teamStats);
      
      final mvpScore = performanceScore * 0.7 + teamContribution * 0.3;
      
      candidates.add({
        'playerId': playerId,
        'playerName': playerName,
        'performance': performance.name,
        'performanceScore': performanceScore,
        'teamContribution': teamContribution,
        'mvpScore': mvpScore,
      });
    });
    
    // MVPスコアでソート
    candidates.sort((a, b) => (b['mvpScore'] as double).compareTo(a['mvpScore'] as double));
    
    return candidates;
  }

  /// パフォーマンスをスコアに変換
  static double _performanceToScore(PlayerPerformance performance) {
    switch (performance) {
      case PlayerPerformance.excellent:
        return 5.0;
      case PlayerPerformance.good:
        return 4.0;
      case PlayerPerformance.average:
        return 3.0;
      case PlayerPerformance.poor:
        return 2.0;
      case PlayerPerformance.terrible:
        return 1.0;
    }
  }

  /// チームへの貢献度を計算
  static double _calculateTeamContribution(Map<String, dynamic> teamStats) {
    final hits = (teamStats['hits'] ?? 0) as int;
    final runs = (teamStats['runs'] ?? 0) as int;
    final errors = (teamStats['errors'] ?? 0) as int;
    
    if (runs == 0) return 0.0;
    
    final contribution = (hits / runs) - (errors * 0.1);
    return contribution.clamp(0.0, 5.0);
  }
}
