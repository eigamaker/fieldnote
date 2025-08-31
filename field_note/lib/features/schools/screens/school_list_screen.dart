import 'package:flutter/material.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/player.dart';
import '../managers/school_manager.dart';
import 'school_detail_screen.dart';

/// 学校一覧画面
class SchoolListScreen extends StatefulWidget {
  final SchoolManager schoolManager;

  const SchoolListScreen({
    super.key,
    required this.schoolManager,
  });

  @override
  State<SchoolListScreen> createState() => _SchoolListScreenState();
}

class _SchoolListScreenState extends State<SchoolListScreen> {
  List<School> _schools = [];
  bool _isLoading = true;
  String _selectedPrefecture = 'すべて';

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('学校一覧'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 都道府県フィルター
          _buildPrefectureFilter(),
          
          // 学校一覧
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildSchoolList(),
          ),
        ],
      ),
    );
  }

  /// 都道府県フィルターを構築
  Widget _buildPrefectureFilter() {
    final prefectures = ['すべて', '東京都', '神奈川県', '埼玉県', '千葉県', '大阪府', '愛知県'];
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: prefectures.length,
        itemBuilder: (context, index) {
          final prefecture = prefectures[index];
          final isSelected = _selectedPrefecture == prefecture;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(prefecture),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPrefecture = prefecture;
                });
                _filterSchools();
              },
              selectedColor: Colors.green[200],
              checkmarkColor: Colors.green[800],
            ),
          );
        },
      ),
    );
  }

  /// 学校一覧を構築
  Widget _buildSchoolList() {
    if (_schools.isEmpty) {
      return const Center(
        child: Text(
          '学校が見つかりません',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _schools.length,
      itemBuilder: (context, index) {
        final school = _schools[index];
        return _buildSchoolCard(school);
      },
    );
  }

  /// 学校カードを構築
  Widget _buildSchoolCard(School school) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToSchoolDetail(school),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 学校レベル表示
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getLevelColor(school.level),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${school.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 学校情報
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          school.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${school.location} • ${school.typeText}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 選手数
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${school.playerCount}名',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      Text(
                        '野球部員',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 学校レベルと生徒数
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getLevelColor(school.level).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      school.levelText,
                      style: TextStyle(
                        color: _getLevelColor(school.level),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '生徒数: ${school.studentCount}人',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  /// 学校詳細画面に遷移
  void _navigateToSchoolDetail(School school) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SchoolDetailScreen(
          school: school,
          schoolManager: widget.schoolManager,
        ),
      ),
    );
  }

  /// 学校一覧を読み込み
  Future<void> _loadSchools() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final schools = await widget.schoolManager.getAllSchools();
      setState(() {
        _schools = schools;
        _isLoading = false;
      });
    } catch (e) {
      print('学校一覧読み込みエラー: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 学校をフィルタリング
  void _filterSchools() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      List<School> schools;
      if (_selectedPrefecture == 'すべて') {
        schools = await widget.schoolManager.getAllSchools();
      } else {
        schools = await widget.schoolManager.getSchoolsByPrefecture(_selectedPrefecture);
      }
      
      setState(() {
        _schools = schools;
        _isLoading = false;
      });
    } catch (e) {
      print('学校フィルタリングエラー: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
