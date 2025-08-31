import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../managers/game_progress_manager.dart';
import 'game_screen.dart';

/// メインメニュー画面
class MainMenuScreen extends StatelessWidget {
  final GameProgressManager gameProgressManager;

  const MainMenuScreen({
    super.key,
    required this.gameProgressManager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // タイトル
            Text(
              'FIELD NOTE',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '野球スカウトゲーム',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 80),
            
            // 新規ゲーム開始ボタン
            _buildMenuButton(
              context,
              '新規ゲーム開始',
              Icons.play_arrow,
              Colors.green[600]!,
              () => _startNewGame(context),
            ),
            const SizedBox(height: 20),
            
            // ゲーム続行ボタン
            FutureBuilder<bool>(
              future: _checkGameData(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return _buildMenuButton(
                    context,
                    'ゲーム続行',
                    Icons.refresh,
                    Colors.blue[600]!,
                    () => _continueGame(context),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            
            // 設定ボタン
            _buildMenuButton(
              context,
              '設定',
              Icons.settings,
              Colors.grey[600]!,
              () => _showSettings(context),
            ),
            const SizedBox(height: 40),
            
            // バージョン情報
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ゲームデータの存在をチェック
  Future<bool> _checkGameData() async {
    return await gameProgressManager.hasGameData();
  }

  /// メニューボタンを構築
  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 新規ゲームを開始
  void _startNewGame(BuildContext context) async {
    final success = await gameProgressManager.startNewGame();
    if (success && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameScreen(
            gameProgressManager: gameProgressManager,
          ),
        ),
      );
    } else {
      _showErrorDialog(context, '新規ゲーム開始に失敗しました');
    }
  }

  /// ゲームを続行
  void _continueGame(BuildContext context) async {
    final success = await gameProgressManager.loadGame();
    if (success && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameScreen(
            gameProgressManager: gameProgressManager,
          ),
        ),
      );
    } else {
      _showErrorDialog(context, 'ゲーム読み込みに失敗しました');
    }
  }

  /// 設定画面を表示
  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('設定'),
        content: const Text('設定機能は今後のバージョンで実装予定です。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// エラーダイアログを表示
  void _showErrorDialog(BuildContext context, String message) {
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
