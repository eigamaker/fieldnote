import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../managers/game_progress_manager.dart';
import '../../../core/domain/entities/game_state.dart';
import '../../../core/domain/entities/game_progress.dart';
import '../../scouting/screens/scouting_screen.dart';
import '../../schools/screens/school_list_screen.dart';

/// ゲーム画面
class GameScreen extends StatefulWidget {
  final GameProgressManager gameProgressManager;

  const GameScreen({
    super.key,
    required this.gameProgressManager,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _currentGameState;
  late GameProgress _currentGameProgress;

  @override
  void initState() {
    super.initState();
    _currentGameState = widget.gameProgressManager.currentGameState;
    _currentGameProgress = widget.gameProgressManager.currentGameProgress;
    
    // 状態変更を監視
    widget.gameProgressManager.gameStateStream.listen((gameState) {
      if (mounted) {
        setState(() {
          _currentGameState = gameState;
        });
      }
    });
    
    widget.gameProgressManager.gameProgressStream.listen((gameProgress) {
      if (mounted) {
        setState(() {
          _currentGameProgress = gameProgress;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('FIELD NOTE - ゲーム'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveGame,
            tooltip: 'ゲーム保存',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _showGameMenu,
            tooltip: 'ゲームメニュー',
          ),
        ],
      ),
      body: Column(
        children: [
          // ゲーム状態表示
          _buildGameStatusCard(),
          
          // 進行状況表示
          _buildProgressCard(),
          
          // 進行ボタン
          _buildProgressButtons(),
          
          // スカウト機能
          _buildScoutingSection(),
          
          // ゲーム情報
          Expanded(
            child: _buildGameInfo(),
          ),
        ],
      ),
    );
  }

  /// ゲーム状態カードを構築
  Widget _buildGameStatusCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'ゲーム状態',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  '開始',
                  _currentGameState.isGameStarted ? 'はい' : 'いいえ',
                  _currentGameState.isGameStarted ? Colors.green : Colors.red,
                ),
                _buildStatusItem(
                  '一時停止',
                  _currentGameState.isGamePaused ? 'はい' : 'いいえ',
                  _currentGameState.isGamePaused ? Colors.orange : Colors.green,
                ),
                _buildStatusItem(
                  '終了',
                  _currentGameState.isGameEnded ? 'はい' : 'いいえ',
                  _currentGameState.isGameEnded ? Colors.red : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 進行状況カードを構築
  Widget _buildProgressCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '進行状況',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _currentGameProgress.progressText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '総週数: ${_currentGameProgress.totalWeeks}週',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 進行ボタンを構築
  Widget _buildProgressButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProgressButton(
            '次の週',
            Icons.arrow_forward,
            Colors.green[600]!,
            _advanceWeek,
          ),
          _buildProgressButton(
            '次の月',
            Icons.arrow_forward,
            Colors.blue[600]!,
            _advanceMonth,
          ),
          _buildProgressButton(
            '次の年',
            Icons.arrow_forward,
            Colors.purple[600]!,
            _advanceYear,
          ),
        ],
      ),
    );
  }

  /// スカウト機能セクションを構築
  Widget _buildScoutingSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'スカウト機能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoutingButton(
                  'スカウト実行',
                  Icons.search,
                  Colors.orange[600]!,
                  _openScoutingScreen,
                ),
                _buildScoutingButton(
                  '学校一覧',
                  Icons.school,
                  Colors.green[600]!,
                  _openSchoolListScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// スカウトボタンを構築
  Widget _buildScoutingButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 120,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 進行ボタンを構築
  Widget _buildProgressButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 100,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ゲーム情報を構築
  Widget _buildGameInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ゲーム情報',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('開始日時', _currentGameState.gameStartTime.toString()),
            if (_currentGameState.gameEndTime != null)
              _buildInfoRow('終了日時', _currentGameState.gameEndTime.toString()),
            _buildInfoRow('現在日時', _currentGameProgress.currentDate.toString()),
            const SizedBox(height: 20),
            Text(
              '今後の機能予定:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('• 選手データ管理'),
            _buildFeatureItem('• スカウトシステム'),
            _buildFeatureItem('• トーナメントシステム'),
            _buildFeatureItem('• 統計・分析機能'),
          ],
        ),
      ),
    );
  }

  /// 状態項目を構築
  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 情報行を構築
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// 機能項目を構築
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 次の週に進む
  void _advanceWeek() async {
    final success = await widget.gameProgressManager.advanceWeek();
    if (!success) {
      _showErrorDialog('週進行に失敗しました');
    }
  }

  /// 次の月に進む
  void _advanceMonth() async {
    final success = await widget.gameProgressManager.advanceMonth();
    if (!success) {
      _showErrorDialog('月進行に失敗しました');
    }
  }

  /// 次の年に進む
  void _advanceYear() async {
    final success = await widget.gameProgressManager.advanceYear();
    if (!success) {
      _showErrorDialog('年進行に失敗しました');
    }
  }

  /// ゲームを保存
  void _saveGame() async {
    final success = await widget.gameProgressManager.saveGame();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ゲームが保存されました'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showErrorDialog('ゲーム保存に失敗しました');
    }
  }

  /// ゲームメニューを表示
  void _showGameMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ゲームメニュー'),
        content: const Text('ゲームを終了しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _exitToMainMenu();
            },
            child: const Text('メインメニューに戻る'),
          ),
        ],
      ),
    );
  }

  /// メインメニューに戻る
  void _exitToMainMenu() {
    Navigator.of(context).pop();
  }

  /// スカウト画面を開く
  void _openScoutingScreen() {
    // TODO: 実際のスカウト画面を開く
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('スカウト機能は今後のバージョンで実装予定です'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// 学校一覧画面を開く
  void _openSchoolListScreen() {
    // TODO: 実際の学校一覧画面を開く
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('学校一覧機能は今後のバージョンで実装予定です'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// エラーダイアログを表示
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
