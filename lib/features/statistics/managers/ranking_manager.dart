import 'dart:async';
import '../../../core/domain/entities/player_statistics.dart';
import '../../../core/domain/entities/team_statistics.dart';
import '../../../core/domain/repositories/statistics_repository.dart';

enum RankingType {
  batting('打撃'),
  pitching('投球'),
  fielding('守備'),
  running('走塁'),
  overall('総合');

  const RankingType(this.label);
  final String label;
}

enum RankingOrder {
  ascending('昇順'),
  descending('降順');

  const RankingOrder(this.label);
  final String label;
}

class RankingEntry {
  final int rank;
  final String playerId;
  final String playerName;
  final String teamId;
  final String teamName;
  final String statCategory;
  final double statValue;
  final String statUnit;
  final Map<String, dynamic> additionalStats;

  const RankingEntry({
    required this.rank,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.teamName,
    required this.statCategory,
    required this.statValue,
    required this.statUnit,
    this.additionalStats = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'playerId': playerId,
      'playerName': playerName,
      'teamId': teamId,
      'teamName': teamName,
      'statCategory': statCategory,
      'statValue': statValue,
      'statUnit': statUnit,
      'additionalStats': additionalStats,
    };
  }

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      rank: json['rank'] as int,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      statCategory: json['statCategory'] as String,
      statValue: (json['statValue'] as num).toDouble(),
      statUnit: json['statUnit'] as String,
      additionalStats: Map<String, dynamic>.from(json['additionalStats'] ?? {}),
    );
  }
}

class RankingManager {
  final StatisticsRepository _repository;
  final StreamController<List<RankingEntry>> _rankingsController = StreamController<List<RankingEntry>>.broadcast();
  final StreamController<Map<String, List<RankingEntry>>> _categoryRankingsController = StreamController<Map<String, List<RankingEntry>>>.broadcast();

  RankingManager(this._repository);

  // ストリーム
  Stream<List<RankingEntry>> get rankingsStream => _rankingsController.stream;
  Stream<Map<String, List<RankingEntry>>> get categoryRankingsStream => _categoryRankingsController.stream;

  // 選手ランキングの生成
  Future<List<RankingEntry>> generatePlayerRankings({
    required RankingType rankingType,
    required String period,
    required RankingOrder order,
    int limit = 50,
  }) async {
    final playerStats = await _repository.loadAllPlayerStatistics();
    final periodStats = playerStats.where((stats) => stats.period.name == period).toList();
    
    final rankings = <RankingEntry>[];
    int rank = 1;

    // 統計値でソート
    final sortedStats = _sortPlayerStatsByCategory(periodStats, rankingType, order);
    
    for (final stats in sortedStats.take(limit)) {
      final statValue = _getPlayerStatValue(stats, rankingType);
      final statUnit = _getStatUnit(rankingType);
      
      rankings.add(RankingEntry(
        rank: rank++,
        playerId: stats.playerId,
        playerName: stats.playerName,
        teamId: stats.teamId,
        teamName: stats.teamName,
        statCategory: rankingType.name,
        statValue: statValue,
        statUnit: statUnit,
        additionalStats: _getAdditionalStats(stats, rankingType),
      ));
    }

    _rankingsController.add(rankings);
    return rankings;
  }

  // チームランキングの生成
  Future<List<RankingEntry>> generateTeamRankings({
    required RankingType rankingType,
    required int season,
    required RankingOrder order,
    int limit = 20,
  }) async {
    final teamStats = await _repository.loadAllTeamStatistics();
    final seasonStats = teamStats.where((stats) => stats.season == season).toList();
    
    final rankings = <RankingEntry>[];
    int rank = 1;

    // 統計値でソート
    final sortedStats = _sortTeamStatsByCategory(seasonStats, rankingType, order);
    
    for (final stats in sortedStats.take(limit)) {
      final statValue = _getTeamStatValue(stats, rankingType);
      final statUnit = _getStatUnit(rankingType);
      
      rankings.add(RankingEntry(
        rank: rank++,
        playerId: '', // チームランキングなので空
        playerName: stats.teamName,
        teamId: stats.teamId,
        teamName: stats.teamName,
        statCategory: rankingType.name,
        statValue: statValue,
        statUnit: statUnit,
        additionalStats: _getAdditionalTeamStats(stats, rankingType),
      ));
    }

    _rankingsController.add(rankings);
    return rankings;
  }

  // カテゴリ別ランキングの生成
  Future<Map<String, List<RankingEntry>>> generateCategoryRankings({
    required String period,
    required int season,
    int limit = 20,
  }) async {
    final categoryRankings = <String, List<RankingEntry>>{};
    
    for (final rankingType in RankingType.values) {
      if (rankingType == RankingType.overall) continue;
      
      final playerRankings = await generatePlayerRankings(
        rankingType: rankingType,
        period: period,
        order: RankingOrder.descending,
        limit: limit,
      );
      
      categoryRankings[rankingType.name] = playerRankings;
    }

    _categoryRankingsController.add(categoryRankings);
    return categoryRankings;
  }

  // 選手統計のソート
  List<PlayerStatistics> _sortPlayerStatsByCategory(
    List<PlayerStatistics> stats,
    RankingType rankingType,
    RankingOrder order,
  ) {
    stats.sort((a, b) {
      final aValue = _getPlayerStatValue(a, rankingType);
      final bValue = _getPlayerStatValue(b, rankingType);
      
      if (order == RankingOrder.ascending) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });
    
    return stats;
  }

  // チーム統計のソート
  List<TeamStatistics> _sortTeamStatsByCategory(
    List<TeamStatistics> stats,
    RankingType rankingType,
    RankingOrder order,
  ) {
    stats.sort((a, b) {
      final aValue = _getTeamStatValue(a, rankingType);
      final bValue = _getTeamStatValue(b, rankingType);
      
      if (order == RankingOrder.ascending) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });
    
    return stats;
  }

  // 選手統計値の取得
  double _getPlayerStatValue(PlayerStatistics stats, RankingType rankingType) {
    switch (rankingType) {
      case RankingType.batting:
        return stats.battingAverage;
      case RankingType.pitching:
        return stats.earnedRunAverage;
      case RankingType.fielding:
        // 守備率の計算（仮実装）
        final putouts = stats.fieldingStats['putouts'] as int? ?? 0;
        final assists = stats.fieldingStats['assists'] as int? ?? 0;
        final errors = stats.fieldingStats['errors'] as int? ?? 0;
        final totalChances = putouts + assists + errors;
        if (totalChances == 0) return 0.0;
        return ((putouts + assists) / totalChances).toDouble();
      case RankingType.running:
        return (stats.runningStats['stolenBases'] as int? ?? 0).toDouble();
      case RankingType.overall:
        return stats.onBasePlusSlugging;
    }
  }

  // チーム統計値の取得
  double _getTeamStatValue(TeamStatistics stats, RankingType rankingType) {
    switch (rankingType) {
      case RankingType.batting:
        return stats.teamBattingAverage;
      case RankingType.pitching:
        return stats.teamEarnedRunAverage;
      case RankingType.fielding:
        return stats.fieldingPercentage;
      case RankingType.running:
        return (stats.offensiveStats['stolenBases'] as int? ?? 0).toDouble();
      case RankingType.overall:
        return stats.winningPercentage;
    }
  }

  // 統計単位の取得
  String _getStatUnit(RankingType rankingType) {
    switch (rankingType) {
      case RankingType.batting:
        return '';
      case RankingType.pitching:
        return '';
      case RankingType.fielding:
        return '';
      case RankingType.running:
        return '個';
      case RankingType.overall:
        return '';
    }
  }

  // 追加統計情報の取得（選手）
  Map<String, dynamic> _getAdditionalStats(PlayerStatistics stats, RankingType rankingType) {
    switch (rankingType) {
      case RankingType.batting:
        return {
          'hits': stats.battingStats['hits'] ?? 0,
          'atBats': stats.battingStats['atBats'] ?? 0,
          'homeRuns': stats.battingStats['homeRuns'] ?? 0,
          'rbi': stats.battingStats['rbi'] ?? 0,
        };
      case RankingType.pitching:
        return {
          'wins': stats.pitchingStats['wins'] ?? 0,
          'losses': stats.pitchingStats['losses'] ?? 0,
          'innings': stats.pitchingStats['innings'] ?? 0.0,
          'strikeouts': stats.pitchingStats['strikeouts'] ?? 0,
        };
      case RankingType.fielding:
        return {
          'putouts': stats.fieldingStats['putouts'] ?? 0,
          'assists': stats.fieldingStats['assists'] ?? 0,
          'errors': stats.fieldingStats['errors'] ?? 0,
        };
      case RankingType.running:
        return {
          'stolenBases': stats.runningStats['stolenBases'] ?? 0,
          'caughtStealing': stats.runningStats['caughtStealing'] ?? 0,
        };
      case RankingType.overall:
        return {
          'ops': stats.onBasePlusSlugging,
          'games': stats.gamesPlayed,
        };
    }
  }

  // 追加統計情報の取得（チーム）
  Map<String, dynamic> _getAdditionalTeamStats(TeamStatistics stats, RankingType rankingType) {
    switch (rankingType) {
      case RankingType.batting:
        return {
          'runs': stats.offensiveStats['runsScored'] ?? 0,
          'hits': stats.offensiveStats['hits'] ?? 0,
          'homeRuns': stats.offensiveStats['homeRuns'] ?? 0,
        };
      case RankingType.pitching:
        return {
          'runsAllowed': stats.defensiveStats['runsAllowed'] ?? 0,
          'earnedRuns': stats.pitchingStats['earnedRuns'] ?? 0,
          'strikeouts': stats.pitchingStats['strikeouts'] ?? 0,
        };
      case RankingType.fielding:
        return {
          'putouts': stats.defensiveStats['putouts'] ?? 0,
          'assists': stats.defensiveStats['assists'] ?? 0,
          'errors': stats.defensiveStats['errors'] ?? 0,
        };
      case RankingType.running:
        return {
          'stolenBases': stats.offensiveStats['stolenBases'] ?? 0,
          'caughtStealing': stats.offensiveStats['caughtStealing'] ?? 0,
        };
      case RankingType.overall:
        return {
          'wins': stats.wins,
          'losses': stats.losses,
          'ties': stats.ties,
          'games': stats.gamesPlayed,
        };
    }
  }

  // ランキングの検索・フィルタリング
  Future<List<RankingEntry>> searchRankings({
    required String keyword,
    required RankingType rankingType,
    String? period,
    int? season,
    int limit = 20,
  }) async {
    final allRankings = await generatePlayerRankings(
      rankingType: rankingType,
      period: period ?? 'season',
      order: RankingOrder.descending,
      limit: 100,
    );

    return allRankings
        .where((entry) => 
            entry.playerName.toLowerCase().contains(keyword.toLowerCase()) ||
            entry.teamName.toLowerCase().contains(keyword.toLowerCase()))
        .take(limit)
        .toList();
  }

  // ランキング履歴の取得
  Future<List<RankingEntry>> getRankingHistory({
    required String playerId,
    required RankingType rankingType,
    required String period,
    int limit = 10,
  }) async {
    final playerStats = await _repository.getPlayerStatsHistory(playerId, period);
    final rankings = <RankingEntry>[];
    int rank = 1;

    for (final stats in playerStats) {
      final statValue = _getPlayerStatValue(stats, rankingType);
      final statUnit = _getStatUnit(rankingType);
      
      rankings.add(RankingEntry(
        rank: rank++,
        playerId: stats.playerId,
        playerName: stats.playerName,
        teamId: stats.teamId,
        teamName: stats.teamName,
        statCategory: rankingType.name,
        statValue: statValue,
        statUnit: statUnit,
        additionalStats: _getAdditionalStats(stats, rankingType),
      ));
    }

    return rankings;
  }

  // リソース解放
  void dispose() {
    _rankingsController.close();
    _categoryRankingsController.close();
  }
}
