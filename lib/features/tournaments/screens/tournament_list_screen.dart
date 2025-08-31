import 'package:flutter/material.dart';
import '../../../core/domain/entities/tournament.dart';
import '../../tournaments/managers/tournament_manager.dart';

/// 大会一覧画面
class TournamentListScreen extends StatefulWidget {
  final TournamentManager tournamentManager;

  const TournamentListScreen({
    super.key,
    required this.tournamentManager,
  });

  @override
  State<TournamentListScreen> createState() => _TournamentListScreenState();
}

class _TournamentListScreenState extends State<TournamentListScreen> {
  List<Tournament> _tournaments = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tournaments = await widget.tournamentManager.getAllTournaments();
      setState(() {
        _tournaments = tournaments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('大会一覧の読み込みに失敗: $e')),
        );
      }
    }
  }

  List<Tournament> get _filteredTournaments {
    List<Tournament> filtered = _tournaments;

    // フィルター適用
    switch (_selectedFilter) {
      case 'spring':
        filtered = filtered.where((t) => t.type == TournamentType.spring).toList();
        break;
      case 'summer':
        filtered = filtered.where((t) => t.type == TournamentType.summer).toList();
        break;
      case 'fall':
        filtered = filtered.where((t) => t.type == TournamentType.fall).toList();
        break;
      case 'upcoming':
        filtered = filtered.where((t) => t.status == TournamentStatus.upcoming).toList();
        break;
      case 'inProgress':
        filtered = filtered.where((t) => t.status == TournamentStatus.inProgress).toList();
        break;
      case 'completed':
        filtered = filtered.where((t) => t.status == TournamentStatus.completed).toList();
        break;
    }

    // 検索クエリ適用
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.type.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.stage.displayName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大会一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateTournamentDialog,
            tooltip: '新規大会作成',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildSearchSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildTournamentList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTournamentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('全て'),
              selected: _selectedFilter == 'all',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'all';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('春'),
              selected: _selectedFilter == 'spring',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'spring';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('夏'),
              selected: _selectedFilter == 'summer',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'summer';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('秋'),
              selected: _selectedFilter == 'fall',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'fall';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('開催予定'),
              selected: _selectedFilter == 'upcoming',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'upcoming';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('開催中'),
              selected: _selectedFilter == 'inProgress',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'inProgress';
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('終了'),
              selected: _selectedFilter == 'completed',
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = 'completed';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: const InputDecoration(
          labelText: '大会を検索',
          hintText: '大会名、種類、段階で検索',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTournamentList() {
    final tournaments = _filteredTournaments;

    if (tournaments.isEmpty) {
      return const Center(
        child: Text('大会が見つかりません'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTournaments,
      child: ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];
          return _buildTournamentCard(tournament);
        },
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildTournamentIcon(tournament.type),
        title: Text(
          tournament.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tournament.type.displayName} - ${tournament.stage.displayName}'),
            Text('${tournament.startDate.toString().substring(0, 10)} 〜 ${tournament.endDate.toString().substring(0, 10)}'),
            Text('参加校: ${tournament.participantCount}校'),
            Text('状態: ${tournament.status.displayName}'),
          ],
        ),
        trailing: _buildStatusChip(tournament.status),
        onTap: () => _openTournamentDetail(tournament),
        onLongPress: () => _showTournamentOptions(tournament),
      ),
    );
  }

  Widget _buildTournamentIcon(TournamentType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case TournamentType.spring:
        iconData = Icons.local_florist;
        iconColor = Colors.pink;
        break;
      case TournamentType.summer:
        iconData = Icons.wb_sunny;
        iconColor = Colors.orange;
        break;
      case TournamentType.fall:
        iconData = Icons.eco;
        iconColor = Colors.brown;
        break;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildStatusChip(TournamentStatus status) {
    Color chipColor;
    switch (status) {
      case TournamentStatus.upcoming:
        chipColor = Colors.blue;
        break;
      case TournamentStatus.inProgress:
        chipColor = Colors.green;
        break;
      case TournamentStatus.completed:
        chipColor = Colors.grey;
        break;
    }

    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  void _openTournamentDetail(Tournament tournament) {
    // TODO: 大会詳細画面に遷移
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${tournament.name}の詳細を表示')),
    );
  }

  void _showTournamentOptions(Tournament tournament) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('詳細表示'),
            onTap: () {
              Navigator.pop(context);
              _openTournamentDetail(tournament);
            },
          ),
          if (tournament.status == TournamentStatus.upcoming)
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('大会開始'),
              onTap: () {
                Navigator.pop(context);
                _startTournament(tournament);
              },
            ),
          if (tournament.status == TournamentStatus.inProgress)
            ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('大会終了'),
              onTap: () {
                Navigator.pop(context);
                _completeTournament(tournament);
              },
            ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('削除'),
            onTap: () {
              Navigator.pop(context);
              _deleteTournament(tournament);
            },
          ),
        ],
      ),
    );
  }

  void _showCreateTournamentDialog() {
    // TODO: 大会作成ダイアログを表示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('大会作成機能は実装予定です')),
    );
  }

  Future<void> _startTournament(Tournament tournament) async {
    try {
      final success = await widget.tournamentManager.startTournament(tournament.id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${tournament.name}を開始しました')),
          );
          _loadTournaments();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('大会開始に失敗: $e')),
        );
      }
    }
  }

  Future<void> _completeTournament(Tournament tournament) async {
    try {
      // 仮の優勝校を設定
      final winnerId = tournament.participatingSchoolIds.first;
      final success = await widget.tournamentManager.completeTournament(tournament.id, winnerId);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${tournament.name}を終了しました')),
          );
          _loadTournaments();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('大会終了に失敗: $e')),
        );
      }
    }
  }

  Future<void> _deleteTournament(Tournament tournament) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('大会削除'),
        content: Text('${tournament.name}を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await widget.tournamentManager.deleteTournament(tournament.id);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${tournament.name}を削除しました')),
            );
            _loadTournaments();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('大会削除に失敗: $e')),
          );
        }
      }
    }
  }
}
