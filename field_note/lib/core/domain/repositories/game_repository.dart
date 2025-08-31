import '../entities/game_state.dart';
import '../entities/game_progress.dart';

/// ゲームデータの保存・読み込みを管理するリポジトリインターフェース
abstract class GameRepository {
  /// ゲーム状態を保存
  Future<bool> saveGameState(GameState gameState);
  
  /// ゲーム状態を読み込み
  Future<GameState?> loadGameState();
  
  /// ゲーム進行状況を保存
  Future<bool> saveGameProgress(GameProgress gameProgress);
  
  /// ゲーム進行状況を読み込み
  Future<GameProgress?> loadGameProgress();
  
  /// 新しいゲームを開始
  Future<bool> startNewGame();
  
  /// ゲームを保存
  Future<bool> saveGame(GameState gameState, GameProgress gameProgress);
  
  /// ゲームを読み込み
  Future<Map<String, dynamic>?> loadGame();
  
  /// ゲームデータを削除
  Future<bool> deleteGame();
  
  /// ゲームデータが存在するかチェック
  Future<bool> hasGameData();
}
