import 'package:flutter/material.dart';
import '../../../core/domain/entities/scout_skills.dart';
import '../../scout_skills/managers/skill_manager.dart';
import '../../../shared/widgets/skill_progress_bar.dart';

/// スキル詳細画面
/// 個別スキルの詳細情報、推奨事項、バランス分析を表示
class SkillDetailScreen extends StatefulWidget {
  final SkillManager skillManager;
  final ScoutSkills scoutSkills;

  const SkillDetailScreen({
    super.key,
    required this.skillManager,
    required this.scoutSkills,
  });

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  Map<String, String> _recommendations = {};
  Map<String, dynamic> _balanceAnalysis = {};

  @override
  void initState() {
    super.initState();
    _loadSkillAnalysis();
  }

  void _loadSkillAnalysis() {
    _recommendations = widget.skillManager.getSkillRecommendations(widget.scoutSkills);
    _balanceAnalysis = widget.skillManager.analyzeSkillBalance(widget.scoutSkills);
  }

  Widget _buildSkillOverview() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'スキル概要',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    '総スキルレベル',
                    '${widget.scoutSkills.totalSkillLevel}',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    '平均レベル',
                    '${widget.scoutSkills.averageSkillLevel.toStringAsFixed(1)}',
                    Icons.analytics,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    'スキルポイント',
                    '${widget.scoutSkills.availableSkillPoints}',
                    Icons.stars,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    'スカウト成功率',
                    '${(widget.scoutSkills.scoutingSuccessRate * 100).toStringAsFixed(1)}%',
                    Icons.search,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    '選手品質向上',
                    '${(widget.scoutSkills.playerQualityBonus * 100).toStringAsFixed(1)}%',
                    Icons.person_add,
                    Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIndividualSkills() {
    final skills = [
      {'name': '探索力', 'level': widget.scoutSkills.exploration, 'color': Colors.blue},
      {'name': '観察力', 'level': widget.scoutSkills.observation, 'color': Colors.green},
      {'name': '分析力', 'level': widget.scoutSkills.analysis, 'color': Colors.orange},
      {'name': '洞察力', 'level': widget.scoutSkills.insight, 'color': Colors.purple},
      {'name': '交渉力', 'level': widget.scoutSkills.negotiation, 'color': Colors.red},
      {'name': 'スタミナ', 'level': widget.scoutSkills.stamina, 'color': Colors.teal},
    ];

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '個別スキル詳細',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...skills.map((skill) => _buildSkillDetailItem(
              skill['name'] as String,
              skill['level'] as int,
              skill['color'] as Color,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillDetailItem(String skillName, int level, Color color) {
    final progress = level / 100.0;
    final status = _getSkillStatus(level);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lv.$level',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SkillProgressBar(
            skillName: '',
            currentLevel: level,
            maxLevel: 100,
            progress: progress,
            color: color,
            height: 12,
            showLabel: false,
            showPercentage: false,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSkillStatus(int level) {
    if (level >= 80) return '優秀';
    if (level >= 60) return '良好';
    if (level >= 40) return '普通';
    if (level >= 20) return '要改善';
    return '要強化';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case '優秀':
        return Icons.star;
      case '良好':
        return Icons.check_circle;
      case '普通':
        return Icons.info;
      case '要改善':
        return Icons.warning;
      case '要強化':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '優秀':
        return Colors.green;
      case '良好':
        return Colors.blue;
      case '普通':
        return Colors.orange;
      case '要改善':
        return Colors.orange;
      case '要強化':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecommendations() {
    if (_recommendations.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '推奨事項',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '現在のスキルバランスは良好です。特に改善が必要な項目はありません。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '推奨事項',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._recommendations.entries.map((entry) => _buildRecommendationItem(
              entry.key,
              entry.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String skillName, String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getSkillDisplayName(skillName),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSkillDisplayName(String skillKey) {
    switch (skillKey) {
      case 'exploration':
        return '探索力';
      case 'observation':
        return '観察力';
      case 'analysis':
        return '分析力';
      case 'insight':
        return '洞察力';
      case 'negotiation':
        return '交渉力';
      case 'stamina':
        return 'スタミナ';
      default:
        return skillKey;
    }
  }

  Widget _buildBalanceAnalysis() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'スキルバランス分析',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAnalysisItem('バランス状態', _balanceAnalysis['balance'] ?? '不明'),
            _buildAnalysisItem('標準偏差', '${(_balanceAnalysis['standardDeviation'] ?? 0.0).toStringAsFixed(2)}'),
            _buildAnalysisItem('推奨事項', _balanceAnalysis['recommendation'] ?? '不明'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スキル詳細'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _buildSkillOverview(),
            _buildIndividualSkills(),
            _buildRecommendations(),
            _buildBalanceAnalysis(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
