import 'package:flutter/material.dart';
import '../../core/domain/entities/tournament.dart';
import '../../core/domain/entities/game_match.dart';

/// トーナメント形式の試合進行を表示するウィジェット
class TournamentBracket extends StatelessWidget {
  final Tournament tournament;
  final List<GameMatch> matches;
  final VoidCallback? onMatchTap;

  const TournamentBracket({
    super.key,
    required this.tournament,
    required this.matches,
    this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: _buildBracketStructure(context),
      ),
    );
  }

  Widget _buildBracketStructure(BuildContext context) {
    final rounds = _calculateRounds();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rounds.map((round) => _buildRound(context, round)).toList(),
    );
  }

  Widget _buildRound(BuildContext context, RoundInfo round) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラウンド名
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              round.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 試合カード
          ...round.matches.map((match) => _buildMatchCard(context, match)),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, GameMatch match) {
    final isCompleted = match.isCompleted;
    final homeTeam = match.homeSchoolId;
    final awayTeam = match.awaySchoolId;
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isCompleted ? 2 : 1,
        color: isCompleted 
            ? Theme.of(context).colorScheme.surfaceVariant
            : Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: onMatchTap != null ? () => onMatchTap!() : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 試合状態
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(match.status),
                    if (match.innings != null)
                      Text(
                        '${match.innings}回',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // ホームチーム
                _buildTeamRow(
                  context,
                  homeTeam,
                  match.homeScore,
                  match.winnerSchoolId == homeTeam,
                ),
                const SizedBox(height: 4),
                // アウェイチーム
                _buildTeamRow(
                  context,
                  awayTeam,
                  match.awayScore,
                  match.winnerSchoolId == awayTeam,
                ),
                if (isCompleted && match.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    match.notes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRow(
    BuildContext context,
    String teamId,
    int? score,
    bool isWinner,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            teamId,
            style: TextStyle(
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              color: isWinner 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        if (score != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isWinner 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score.toString(),
              style: TextStyle(
                color: isWinner 
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(MatchStatus status) {
    Color chipColor;
    String statusText;
    
    switch (status) {
      case MatchStatus.scheduled:
        chipColor = Colors.blue;
        statusText = '予定';
        break;
      case MatchStatus.inProgress:
        chipColor = Colors.green;
        statusText = '試合中';
        break;
      case MatchStatus.completed:
        chipColor = Colors.grey;
        statusText = '終了';
        break;
      case MatchStatus.cancelled:
        chipColor = Colors.red;
        statusText = '中止';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<RoundInfo> _calculateRounds() {
    final rounds = <RoundInfo>[];
    final totalMatches = matches.length;
    
    if (totalMatches == 0) return rounds;

    // 1回戦
    final firstRoundMatches = matches.take((totalMatches + 1) ~/ 2).toList();
    rounds.add(RoundInfo('1回戦', firstRoundMatches));

    // 2回戦以降
    int remainingMatches = totalMatches - firstRoundMatches.length;
    int roundNumber = 2;
    
    while (remainingMatches > 0) {
      final roundMatches = matches.skip(firstRoundMatches.length).take(remainingMatches).toList();
      rounds.add(RoundInfo('${roundNumber}回戦', roundMatches));
      remainingMatches -= roundMatches.length;
      roundNumber++;
    }

    // 決勝戦
    if (rounds.isNotEmpty) {
      final finalMatch = matches.last;
      rounds.add(RoundInfo('決勝', [finalMatch]));
    }

    return rounds;
  }
}

/// ラウンド情報を保持するクラス
class RoundInfo {
  final String name;
  final List<GameMatch> matches;

  RoundInfo(this.name, this.matches);
}

/// トーナメント進行状況を表示するウィジェット
class TournamentProgress extends StatelessWidget {
  final Tournament tournament;
  final List<GameMatch> matches;

  const TournamentProgress({
    super.key,
    required this.tournament,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    final completedMatches = matches.where((m) => m.isCompleted).length;
    final totalMatches = matches.length;
    final progress = totalMatches > 0 ? completedMatches / totalMatches : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '大会進行状況',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '試合進捗: $completedMatches / $totalMatches',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildTournamentStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentStats(BuildContext context) {
    final completedMatches = matches.where((m) => m.isCompleted).toList();
    
    if (completedMatches.isEmpty) {
      return const Text('まだ試合が行われていません');
    }

    int totalRuns = 0;
    int totalHits = 0;
    int totalErrors = 0;

    for (final match in completedMatches) {
      totalRuns += (match.homeScore ?? 0) + (match.awayScore ?? 0);
      totalHits += ((match.homeTeamStats['hits'] ?? 0) as int) + 
                   ((match.awayTeamStats['hits'] ?? 0) as int);
      totalErrors += ((match.homeTeamStats['errors'] ?? 0) as int) + 
                    ((match.awayTeamStats['errors'] ?? 0) as int);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '試合統計',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatItem('総得点', totalRuns.toString(), Icons.sports_baseball),
            ),
            Expanded(
              child: _buildStatItem('総安打', totalHits.toString(), Icons.touch_app),
            ),
            Expanded(
              child: _buildStatItem('総失策', totalErrors.toString(), Icons.error),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
