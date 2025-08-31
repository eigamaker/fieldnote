import 'package:flutter/material.dart';
import '../../../core/domain/entities/scout_skills.dart';
import '../../scout_skills/managers/skill_manager.dart';
import '../../../shared/widgets/skill_progress_bar.dart';

/// スカウトスキル画面
/// スキルの表示、レベルアップ、スキルポイント分配のUI
class SkillScreen extends StatefulWidget {
  final SkillManager skillManager;
  final String scoutId;
  final String scoutName;

  const SkillScreen({
    super.key,
    required this.skillManager,
    required this.scoutId,
    required this.scoutName,
  });

  @override
  State<SkillScreen> createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
  ScoutSkills? _scoutSkills;
  bool _isLoading = true;
  String? _selectedSkillForLevelUp;

  @override
  void initState() {
    super.initState();
    _loadScoutSkills();
  }

  Future<void> _loadScoutSkills() async {
    setState(() => _isLoading = true);
    try {
      final skills = await widget.skillManager.getScoutSkills(widget.scoutId);
      if (mounted) {
        setState(() {
          _scoutSkills = skills;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('スキルデータの読み込みに失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _levelUpSkill(String skillName) async {
    if (_scoutSkills == null) return;
    
    try {
      final success = await widget.skillManager.levelUpSkill(widget.scoutId, skillName);
      if (success) {
        await _loadScoutSkills();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('スキルレベルアップ成功！'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('スキルレベルアップに失敗しました'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLevelUpDialog(String skillName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$skillName をレベルアップ'),
        content: Text('スキルポイントを1消費して$skillNameをレベルアップしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _levelUpSkill(skillName);
            },
            child: const Text('レベルアップ'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String skillName, int level, Color color) {
    final canLevelUp = _scoutSkills?.availableSkillPoints != null && 
                      _scoutSkills!.availableSkillPoints > 0 && 
                      level < 100;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              progress: level / 100.0,
              color: color,
              height: 12,
              showLabel: false,
              showPercentage: false,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'スキルポイント: ${_scoutSkills?.availableSkillPoints ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (canLevelUp)
                  ElevatedButton(
                    onPressed: () => _showLevelUpDialog(skillName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('レベルアップ'),
                  )
                else
                  Text(
                    level >= 100 ? '最大レベル' : 'スキルポイント不足',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillSummary() {
    if (_scoutSkills == null) return const SizedBox.shrink();
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'スキルサマリー',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    '総スキルレベル',
                    '${_scoutSkills!.totalSkillLevel}',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    '平均レベル',
                    '${_scoutSkills!.averageSkillLevel.toStringAsFixed(1)}',
                    Icons.analytics,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'スキルポイント',
                    '${_scoutSkills!.availableSkillPoints}',
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
                  child: _buildSummaryItem(
                    'スカウト成功率',
                    '${(_scoutSkills!.scoutingSuccessRate * 100).toStringAsFixed(1)}%',
                    Icons.search,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    '選手品質向上',
                    '${(_scoutSkills!.playerQualityBonus * 100).toStringAsFixed(1)}%',
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

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.scoutName}のスキル'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scoutSkills == null
              ? const Center(child: Text('スキルデータが見つかりません'))
              : RefreshIndicator(
                  onRefresh: _loadScoutSkills,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _buildSkillSummary(),
                        const SizedBox(height: 16),
                        Text(
                          '個別スキル',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSkillCard('探索力', _scoutSkills!.exploration, Colors.blue),
                        _buildSkillCard('観察力', _scoutSkills!.observation, Colors.green),
                        _buildSkillCard('分析力', _scoutSkills!.analysis, Colors.orange),
                        _buildSkillCard('洞察力', _scoutSkills!.insight, Colors.purple),
                        _buildSkillCard('交渉力', _scoutSkills!.negotiation, Colors.red),
                        _buildSkillCard('スタミナ', _scoutSkills!.stamina, Colors.teal),
                        const SizedBox(height: 16),
                        Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'スキル詳細',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _scoutSkills!.detailedInfo,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
