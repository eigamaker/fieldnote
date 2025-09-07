import 'dart:async';

import '../../../core/domain/repositories/game_repository.dart';
import '../../../core/domain/entities/game_state.dart';
import '../../../core/domain/entities/game_progress.dart';
import '../../data/local/json_storage.dart';

/// Local file-based implementation of GameRepository.
/// Adds simple save coalescing to reduce FS churn.
class LocalGameRepository implements GameRepository {
  final JsonStorage _storage;
  final _saveQueue = _SaveCoalescer(const Duration(milliseconds: 120));

  LocalGameRepository(this._storage);

  @override
  Future<bool> saveGameState(GameState gameState) async {
    return await _storage.saveGameState(gameState.toJson());
  }

  @override
  Future<GameState?> loadGameState() async {
    final data = await _storage.loadGameState();
    if (data != null) {
      return GameState.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> saveGameProgress(GameProgress gameProgress) async {
    return await _storage.saveGameProgress(gameProgress.toJson());
  }

  @override
  Future<GameProgress?> loadGameProgress() async {
    final data = await _storage.loadGameProgress();
    if (data != null) {
      return GameProgress.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> startNewGame() async {
    try {
      await _storage.clearAllData();
      final gameState = GameState.initial().startGame();
      final gameProgress = GameProgress.initial();
      final stateSaved = await _storage.saveGameState(gameState.toJson());
      final progressSaved = await _storage.saveGameProgress(gameProgress.toJson());
      return stateSaved && progressSaved;
    } catch (e) {
      print('新規ゲーム開始エラー: $e');
      return false;
    }
  }

  @override
  Future<bool> saveGame(GameState gameState, GameProgress gameProgress) async {
    try {
      // Coalesce multiple rapid saves
      final completer = Completer<bool>();
      _saveQueue.enqueue(() async {
        final stateSaved = await _storage.saveGameState(gameState.toJson());
        final progressSaved = await _storage.saveGameProgress(gameProgress.toJson());
        completer.complete(stateSaved && progressSaved);
      });
      return await completer.future;
    } catch (e) {
      print('ゲーム保存エラー: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> loadGame() async {
    try {
      final gameState = await loadGameState();
      final gameProgress = await loadGameProgress();
      if (gameState != null || gameProgress != null) {
        return {
          'gameState': gameState?.toJson(),
          'gameProgress': gameProgress?.toJson(),
        };
      }
      return null;
    } catch (e) {
      print('ゲーム読み込みエラー: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteGame() async {
    return await _storage.clearAllData();
  }

  @override
  Future<bool> hasGameData() async {
    try {
      return await _storage.hasGameData();
    } catch (e) {
      print('ゲームデータ存在チェックエラー: $e');
      return false;
    }
  }
}

class _SaveCoalescer {
  final Duration delay;
  Timer? _timer;
  Future<void> Function()? _pending;

  _SaveCoalescer(this.delay);

  void enqueue(Future<void> Function() action) {
    _pending = action;
    _timer?.cancel();
    _timer = Timer(delay, () async {
      final run = _pending;
      _pending = null;
      if (run != null) {
        try {
          await run();
        } catch (_) {}
      }
    });
  }
}

