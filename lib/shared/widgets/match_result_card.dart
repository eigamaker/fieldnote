import 'package:flutter/material.dart';
import '../../core/domain/entities/game_match.dart';

/// 試合結果を表示するカードウィジェット
class MatchResultCard extends StatelessWidget {
  final GameMatch match;
  final VoidCallback? onTap;
  final bool showDetails;

  const MatchResultCard({
    super.key,
    required this.match,
    this.onTap,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMatchHeader(context),
              const SizedBox(height: 12),
              _buildScoreSection(context),
              if (showDetails) ...[
                const SizedBox(height: 16),
                _buildDetailedStats(context),
                const SizedBox(height: 16),
                _buildPlayerPerformances(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context) {
    return Row(
      children: [
        _buildStatusChip(match.status),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${match.homeSchoolId} vs ${match.awaySchoolId}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (match.scheduledDate != null)
                Text(
                  '${match.scheduledDate.toString().substring(0, 10)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
        if (match.innings != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${match.innings}回',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScoreSection(BuildContext context) {
    final homeScore = match.homeScore ?? 0;
    final awayScore = match.awayScore ?? 0;
    final isCompleted = match.isCompleted;
    final homeWon = match.winnerSchoolId == match.homeSchoolId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted 
              ? (homeWon ? Colors.green : Colors.red)
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTeamScore(
            context,
            match.homeSchoolId,
            homeScore,
            isCompleted && homeWon,
            true,
          ),
          _buildVSIndicator(context),
          _buildTeamScore(
            context,
            match.awaySchoolId,
            awayScore,
            isCompleted && !homeWon,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScore(
    BuildContext context,
    String teamId,
    int score,
    bool isWinner,
    bool isHome,
  ) {
    return Column(
      children: [
        Text(
          teamId,
          style: TextStyle(
            fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            color: isWinner 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isWinner 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isWinner 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              score.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isWinner 
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isHome ? 'ホーム' : 'アウェイ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVSIndicator(BuildContext context) {
    return Column(
      children: [
        Text(
          'VS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.sports_baseball,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '試合統計',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'ホーム校',
                match.homeTeamStats,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'アウェイ校',
                match.awayTeamStats,
                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    Map<String, dynamic> stats,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatRow('安打', stats['hits'] ?? 0),
          _buildStatRow('四球', stats['walks'] ?? 0),
          _buildStatRow('三振', stats['strikeouts'] ?? 0),
          _buildStatRow('失策', stats['errors'] ?? 0),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPerformances(BuildContext context) {
    if (match.playerPerformances.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '選手活躍度',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: match.playerPerformances.entries.map((entry) {
            return _buildPerformanceChip(entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPerformanceChip(String playerId, PlayerPerformance performance) {
    Color chipColor;
    String performanceText;
    
    switch (performance) {
      case PlayerPerformance.excellent:
        chipColor = Colors.green;
        performanceText = '優秀';
        break;
      case PlayerPerformance.good:
        chipColor = Colors.blue;
        performanceText = '良好';
        break;
      case PlayerPerformance.average:
        chipColor = Colors.orange;
        performanceText = '普通';
        break;
      case PlayerPerformance.poor:
        chipColor = Colors.red;
        performanceText = '不振';
        break;
      case PlayerPerformance.terrible:
        chipColor = Colors.grey;
        performanceText = '最悪';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPerformanceIcon(performance),
            size: 16,
            color: chipColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$playerId: $performanceText',
            style: TextStyle(
              fontSize: 12,
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPerformanceIcon(PlayerPerformance performance) {
    switch (performance) {
      case PlayerPerformance.excellent:
        return Icons.star;
      case PlayerPerformance.good:
        return Icons.thumb_up;
      case PlayerPerformance.average:
        return Icons.remove;
      case PlayerPerformance.poor:
        return Icons.thumb_down;
      case PlayerPerformance.terrible:
        return Icons.close;
    }
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
}

/// 試合結果の要約を表示するウィジェット
class MatchResultSummary extends StatelessWidget {
  final GameMatch match;

  const MatchResultSummary({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    if (!match.isCompleted) {
      return const SizedBox.shrink();
    }

    final homeScore = match.homeScore ?? 0;
    final awayScore = match.awayScore ?? 0;
    final homeWon = match.winnerSchoolId == match.homeSchoolId;
    final winner = homeWon ? match.homeSchoolId : match.awaySchoolId;
    final scoreDiff = (homeScore - awayScore).abs();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: homeWon ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: homeWon ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            homeWon ? Icons.emoji_events : Icons.sports_baseball,
            color: homeWon ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '優勝: $winner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: homeWon ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  'スコア差: ${scoreDiff}点',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
