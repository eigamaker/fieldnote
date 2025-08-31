import 'package:flutter/material.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/player.dart';
import '../managers/school_manager.dart';
import '../../../shared/widgets/scouting_action_button.dart';

/// 学校詳細画面
class SchoolDetailScreen extends StatefulWidget {
  final School school;
  final SchoolManager schoolManager;

  const SchoolDetailScreen({
    super.key,
    required this.school,
    required this.schoolManager,
  });

  @override
  State<SchoolDetailScreen> createState() => _SchoolDetailScreenState();
}

class _SchoolDetailScreenState extends State<SchoolDetailScreen> {
  List<Player> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchoolPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(widget.school.name),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 学校情報カード
                  _buildSchoolInfoCard(),
                  const SizedBox(height: 24),
                  
                  // 選手一覧
                  _buildPlayersSection(),
                ],
              ),
            ),
    );
  }

  /// 学校情報カードを構築
  Widget _buildSchoolInfoCard() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 学校レベル表示
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getLevelColor(widget.school.level),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.school.level}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // 学校基本情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.school.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.school.location}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.school.typeText} • 創立: ${widget.school.establishedDate.year}年',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 統計情報
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('生徒数', '${widget.school.studentCount}人', Icons.people),
                _buildStatItem('野球部員', '${widget.school.playerCount}名', Icons.sports_baseball),
                _buildStatItem('レベル', widget.school.levelText, Icons.star),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 統計項目を構築
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.green[600]),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
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

  /// 選手セクションを構築
  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '野球部員一覧',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            Text(
              '${_players.length}名',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (_players.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.sports_baseball,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'まだ選手がいません',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'スカウトを実行して選手を発見しましょう！',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              return _buildPlayerCard(player);
            },
          ),
      ],
    );
  }

  /// 選手カードを構築
  Widget _buildPlayerCard(Player player) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
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
          onPressed: () => _showPlayerDetails(player),
        ),
      ),
    );
  }

  /// 選手の詳細情報を表示
  void _showPlayerDetails(Player player) {
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

  /// 学校レベルに基づく色を取得
  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
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

  /// 学校の選手を読み込み
  Future<void> _loadSchoolPlayers() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // ここでは仮のデータを使用（実際の実装ではScoutingManagerから取得）
      setState(() {
        _players = [];
        _isLoading = false;
      });
    } catch (e) {
      print('学校選手読み込みエラー: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
