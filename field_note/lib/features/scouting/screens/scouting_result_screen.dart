import 'package:flutter/material.dart';
import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/scout_action.dart';
import '../managers/scouting_manager.dart';
import '../../../shared/widgets/scouting_action_button.dart';

/// スカウト結果画面
class ScoutingResultScreen extends StatelessWidget {
  final ScoutAction scoutAction;
  final List<Player> discoveredPlayers;
  final ScoutingManager scoutingManager;

  const ScoutingResultScreen({
    super.key,
    required this.scoutAction,
    required this.discoveredPlayers,
    required this.scoutingManager,
  });

  @override
  Widget build(BuildContext context) {
    final evaluation = scoutingManager.evaluateScoutingResult(discoveredPlayers);
    final summary = scoutingManager.generateScoutingSummary(
      scoutAction: scoutAction,
      discoveredPlayers: discoveredPlayers,
    );

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('スカウト結果'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 結果サマリー
            _buildResultSummary(summary, evaluation),
            const SizedBox(height: 24),
            
            // 発見した選手一覧
            if (discoveredPlayers.isNotEmpty) ...[
              _buildDiscoveredPlayersSection(),
              const SizedBox(height: 24),
            ],
            
            // アクションボタン
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// 結果サマリーを構築
  Widget _buildResultSummary(String summary, String evaluation) {
    Color summaryColor;
    IconData summaryIcon;
    
    switch (evaluation) {
      case '優秀':
        summaryColor = Colors.purple;
        summaryIcon = Icons.star;
        break;
      case '良好':
        summaryColor = Colors.red;
        summaryIcon = Icons.thumb_up;
        break;
      case '普通':
        summaryColor = Colors.orange;
        summaryIcon = Icons.check_circle;
        break;
      case '未熟':
        summaryColor = Colors.yellow[700]!;
        summaryIcon = Icons.info;
        break;
      default:
        summaryColor = Colors.grey;
        summaryIcon = Icons.close;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: summaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: summaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            summaryIcon,
            size: 48,
            color: summaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'スカウト結果: $evaluation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: summaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 発見した選手セクションを構築
  Widget _buildDiscoveredPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '発見した選手',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          child: ListView.builder(
            itemCount: discoveredPlayers.length,
            itemBuilder: (context, index) {
              final player = discoveredPlayers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getRatingColor(player.overallRating),
                    child: Text(
                      player.overallRating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    player.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${player.positionDisplayName} • ${player.gradeText} • 平均能力: ${player.averageAbility.toStringAsFixed(1)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showPlayerDetails(context, player),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// アクションボタンを構築
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoutingActionButton(
          text: '再度スカウト',
          icon: Icons.refresh,
          color: Colors.blue[600]!,
          onPressed: () => Navigator.of(context).pop(),
        ),
        ScoutingActionButton(
          text: '完了',
          icon: Icons.check,
          color: Colors.green[600]!,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// 選手の詳細情報を表示
  void _showPlayerDetails(BuildContext context, Player player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('選手詳細: ${player.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(player.detailedInfo),
              const SizedBox(height: 16),
              Text(
                '能力値詳細:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildAbilityRow('打撃力', player.abilities.batting),
              _buildAbilityRow('パワー', player.abilities.power),
              _buildAbilityRow('走力', player.abilities.speed),
              _buildAbilityRow('守備力', player.abilities.fielding),
              _buildAbilityRow('肩力', player.abilities.throwing),
              _buildAbilityRow('投球力', player.abilities.pitching),
              _buildAbilityRow('制球力', player.abilities.control),
              _buildAbilityRow('スタミナ', player.abilities.stamina),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  /// 能力値行を構築
  Widget _buildAbilityRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                value >= 80 ? Colors.purple :
                value >= 70 ? Colors.red :
                value >= 60 ? Colors.orange :
                value >= 50 ? Colors.yellow[700]! :
                Colors.green,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// 評価に基づく色を取得
  Color _getRatingColor(String rating) {
    switch (rating) {
      case 'S':
        return Colors.purple;
      case 'A':
        return Colors.red;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.yellow[700]!;
      case 'D':
        return Colors.green;
      case 'E':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
