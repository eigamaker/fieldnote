import 'dart:async';
import '../../../core/domain/entities/game_state.dart';
import '../../../core/domain/entities/game_progress.dart';
import '../../../core/domain/repositories/game_repository.dart';

/// ゲームの進行状況を管理するマネージャークラス
class GameProgressManager {
  final GameRepository _repository;
  
  GameState _gameState = GameState.initial();
  GameProgress _gameProgress = GameProgress.initial();
  
  // 状態変更の通知用ストリーム
  final StreamController<GameState> _gameStateController = 
      StreamController<GameState>.broadcast();
  final StreamController<GameProgress> _gameProgressController = 
      StreamController<GameProgress>.broadcast();
  
  GameProgressManager(this._repository);

  /// ゲーム状態のストリーム
  Stream<GameState> get gameStateStream => _gameStateController.stream;
  
  /// ゲーム進行状況のストリーム
  Stream<GameProgress> get gameProgressStream => _gameProgressController.stream;
  
  /// 現在のゲーム状態
  GameState get currentGameState => _gameState;
  
  /// 現在のゲーム進行状況
  GameProgress get currentGameProgress => _gameProgress;

  /// 新しいゲームを開始
  Future<bool> startNewGame() async {
    try {
      _gameState = GameState.initial().startGame();
      _gameProgress = GameProgress.initial();
      
      // 状態を通知
      _gameStateController.add(_gameState);
      _gameProgressController.add(_gameProgress);
      
      // リポジトリに保存
      return await _repository.startNewGame();
    } catch (e) {
      print('新しいゲーム開始エラー: $e');
      return false;
    }
  }

  /// ゲームを一時停止
  Future<bool> pauseGame() async {
    try {
      _gameState = _gameState.pauseGame();
      _gameStateController.add(_gameState);
      
      // 現在の状態を保存
      return await _repository.saveGame(_gameState, _gameProgress);
    } catch (e) {
      print('ゲーム一時停止エラー: $e');
      return false;
    }
  }

  /// ゲームを再開
  Future<bool> resumeGame() async {
    try {
      _gameState = _gameState.resumeGame();
      _gameStateController.add(_gameState);
      
      // 現在の状態を保存
      return await _repository.saveGame(_gameState, _gameProgress);
    } catch (e) {
      print('ゲーム再開エラー: $e');
      return false;
    }
  }

  /// ゲームを終了
  Future<bool> endGame() async {
    try {
      _gameState = _gameState.endGame();
      _gameStateController.add(_gameState);
      
      // 最終状態を保存
      return await _repository.saveGame(_gameState, _gameProgress);
    } catch (e) {
      print('ゲーム終了エラー: $e');
      return false;
    }
  }

  /// 次の週に進む
  Future<bool> advanceWeek() async {
    try {
      _gameProgress = _gameProgress.advanceWeek();
      _gameProgressController.add(_gameProgress);
      
      // 進行状況を保存
      return await _repository.saveGameProgress(_gameProgress);
    } catch (e) {
      print('週進行エラー: $e');
      return false;
    }
  }

  /// 次の月に進む
  Future<bool> advanceMonth() async {
    try {
      _gameProgress = _gameProgress.advanceMonth();
      _gameProgressController.add(_gameProgress);
      
      // 進行状況を保存
      return await _repository.saveGameProgress(_gameProgress);
    } catch (e) {
      print('月進行エラー: $e');
      return false;
    }
  }

  /// 次の年に進む
  Future<bool> advanceYear() async {
    try {
      _gameProgress = _gameProgress.advanceYear();
      _gameProgressController.add(_gameProgress);
      
      // 進行状況を保存
      return await _repository.saveGameProgress(_gameProgress);
    } catch (e) {
      print('年進行エラー: $e');
      return false;
    }
  }

  /// ゲームを保存
  Future<bool> saveGame() async {
    try {
      return await _repository.saveGame(_gameState, _gameProgress);
    } catch (e) {
      print('ゲーム保存エラー: $e');
      return false;
    }
  }

  /// ゲームを読み込み
  Future<bool> loadGame() async {
    try {
      final gameData = await _repository.loadGame();
      if (gameData != null) {
        final gameStateData = gameData['gameState'];
        final gameProgressData = gameData['gameProgress'];
        
        if (gameStateData != null) {
          _gameState = GameState.fromJson(gameStateData);
          _gameStateController.add(_gameState);
        }
        
        if (gameProgressData != null) {
          _gameProgress = GameProgress.fromJson(gameProgressData);
          _gameProgressController.add(_gameProgress);
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print('ゲーム読み込みエラー: $e');
      return false;
    }
  }

  /// ゲームデータを削除
  Future<bool> deleteGame() async {
    try {
      _gameState = GameState.initial();
      _gameProgress = GameProgress.initial();
      
      _gameStateController.add(_gameState);
      _gameProgressController.add(_gameProgress);
      
      return await _repository.deleteGame();
    } catch (e) {
      print('ゲーム削除エラー: $e');
      return false;
    }
  }

  /// ゲームデータが存在するかチェック
  Future<bool> hasGameData() async {
    return await _repository.hasGameData();
  }

  /// リソースを解放
  void dispose() {
    _gameStateController.close();
    _gameProgressController.close();
  }
}
