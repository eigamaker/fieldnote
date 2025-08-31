import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// JSONファイルを使用したシンプルなデータ保存クラス
class JsonStorage {
  static const String _gameStateFileName = 'game_state.json';
  static const String _gameProgressFileName = 'game_progress.json';

  /// アプリケーションのドキュメントディレクトリを取得
  Future<Directory> get _documentsDirectory async {
    if (Platform.isWindows) {
      return Directory('${Directory.current.path}/data');
    }
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  /// ファイルパスを取得
  Future<String> _getFilePath(String fileName) async {
    final directory = await _documentsDirectory;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return '${directory.path}/$fileName';
  }

  /// データを保存
  Future<bool> saveData(String fileName, Map<String, dynamic> data) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);
      final jsonString = jsonEncode(data);
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print('データ保存エラー: $e');
      return false;
    }
  }

  /// データを読み込み
  Future<Map<String, dynamic>?> loadData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);
      
      if (!await file.exists()) {
        return null;
      }
      
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('データ読み込みエラー: $e');
      return null;
    }
  }

  /// データを削除
  Future<bool> deleteData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      print('データ削除エラー: $e');
      return false;
    }
  }

  /// ゲーム状態を保存
  Future<bool> saveGameState(Map<String, dynamic> gameState) async {
    return await saveData(_gameStateFileName, gameState);
  }

  /// ゲーム状態を読み込み
  Future<Map<String, dynamic>?> loadGameState() async {
    return await loadData(_gameStateFileName);
  }

  /// ゲーム進行状況を保存
  Future<bool> saveGameProgress(Map<String, dynamic> gameProgress) async {
    return await saveData(_gameProgressFileName, gameProgress);
  }

  /// ゲーム進行状況を読み込み
  Future<Map<String, dynamic>?> loadGameProgress() async {
    return await loadData(_gameProgressFileName);
  }

  /// すべてのデータを削除
  Future<bool> clearAllData() async {
    try {
      await deleteData(_gameStateFileName);
      await deleteData(_gameProgressFileName);
      return true;
    } catch (e) {
      print('全データ削除エラー: $e');
      return false;
    }
  }

  /// データファイルが存在するかチェック
  Future<bool> hasData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// ゲームデータが存在するかチェック
  Future<bool> hasGameData() async {
    final hasState = await hasData(_gameStateFileName);
    final hasProgress = await hasData(_gameProgressFileName);
    return hasState || hasProgress;
  }
}
