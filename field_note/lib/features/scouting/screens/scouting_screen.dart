import 'package:flutter/material.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/scout_action.dart';
import '../managers/scouting_manager.dart';
import '../../../shared/widgets/scouting_action_button.dart';
import '../../../shared/widgets/scouting_action_button.dart' as shared_widgets;
import 'scouting_result_screen.dart';

/// スカウト画面
class ScoutingScreen extends StatefulWidget {
  final ScoutingManager scoutingManager;
  final List<School> availableSchools;

  const ScoutingScreen({
    super.key,
    required this.scoutingManager,
    required this.availableSchools,
  });

  @override
  State<ScoutingScreen> createState() => _ScoutingScreenState();
}

class _ScoutingScreenState extends State<ScoutingScreen> {
  School? _selectedSchool;
  double _scoutSkill = 50.0;
  bool _isScouting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('スカウト'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 学校選択セクション
            _buildSchoolSelectionSection(),
            const SizedBox(height: 24),
            
            // スカウトスキル設定セクション
            _buildScoutSkillSection(),
            const SizedBox(height: 32),
            
            // スカウト実行ボタン
            _buildScoutingButton(),
            const SizedBox(height: 24),
            
            // 説明文
            _buildDescriptionSection(),
          ],
        ),
      ),
    );
  }

  /// 学校選択セクションを構築
  Widget _buildSchoolSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'スカウト対象校を選択',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            itemCount: widget.availableSchools.length,
            itemBuilder: (context, index) {
              final school = widget.availableSchools[index];
              final isSelected = _selectedSchool?.id == school.id;
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                  child: Text(
                    '${school.level}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  school.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${school.location} • ${school.levelText} • ${school.playerCount}名',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSchool = school;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// スカウトスキル設定セクションを構築
  Widget _buildScoutSkillSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'スカウトスキルを設定',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 16),
        shared_widgets.ScoutSkillSlider(
          value: _scoutSkill,
          onChanged: (value) {
            setState(() {
              _scoutSkill = value;
            });
          },
          label: 'スカウトスキル',
          min: 10.0,
          max: 100.0,
          divisions: 90,
        ),
        Text(
          'スキルが高いほど、優秀な選手を発見できる可能性が高くなります。',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  /// スカウト実行ボタンを構築
  Widget _buildScoutingButton() {
    return Center(
      child: ScoutingActionButton(
        text: 'スカウト実行',
        icon: Icons.search,
        color: Colors.orange[600]!,
        onPressed: _selectedSchool == null ? () {} : _executeScouting,
        isLoading: _isScouting,
        tooltip: '選択した学校でスカウトを実行します',
      ),
    );
  }

  /// 説明文セクションを構築
  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'スカウトについて',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• スカウトを実行すると、1-3名の選手が発見されます\n'
            '• 発見される選手数はスカウトスキルと学校レベルに依存します\n'
            '• 学校レベルが高いほど、優秀な選手を発見しやすくなります\n'
            '• 発見された選手は自動的に学校に配属されます',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// スカウトを実行
  void _executeScouting() async {
    if (_selectedSchool == null) return;

    setState(() {
      _isScouting = true;
    });

    try {
      // スカウトを実行
      final scoutAction = await widget.scoutingManager.executeScouting(
        schoolId: _selectedSchool!.id.toString(),
        scoutSkill: _scoutSkill,
      );

      // 発見した選手を取得
      final discoveredPlayers = await widget.scoutingManager.getSchoolPlayers(_selectedSchool!.id.toString());

      if (mounted) {
        // 結果画面に遷移
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScoutingResultScreen(
              scoutAction: scoutAction,
              discoveredPlayers: discoveredPlayers,
              scoutingManager: widget.scoutingManager,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('スカウト実行エラー: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScouting = false;
        });
      }
    }
  }
}
