/// ゲームの状態を管理するエンティティクラス
class GameState {
  final bool isGameStarted;
  final bool isGamePaused;
  final bool isGameEnded;
  final DateTime gameStartTime;
  final DateTime? gameEndTime;

  const GameState({
    this.isGameStarted = false,
    this.isGamePaused = false,
    this.isGameEnded = false,
    required this.gameStartTime,
    this.gameEndTime,
  });

  /// ゲーム開始状態のコピーを作成
  GameState copyWith({
    bool? isGameStarted,
    bool? isGamePaused,
    bool? isGameEnded,
    DateTime? gameStartTime,
    DateTime? gameEndTime,
  }) {
    return GameState(
      isGameStarted: isGameStarted ?? this.isGameStarted,
      isGamePaused: isGamePaused ?? this.isGamePaused,
      isGameEnded: isGameEnded ?? this.isGameEnded,
      gameStartTime: gameStartTime ?? this.gameStartTime,
      gameEndTime: gameEndTime ?? this.gameEndTime,
    );
  }

  /// ゲームを開始
  GameState startGame() {
    return copyWith(
      isGameStarted: true,
      isGamePaused: false,
      isGameEnded: false,
      gameStartTime: DateTime.now(),
    );
  }

  /// ゲームを一時停止
  GameState pauseGame() {
    return copyWith(
      isGamePaused: true,
    );
  }

  /// ゲームを再開
  GameState resumeGame() {
    return copyWith(
      isGamePaused: false,
    );
  }

  /// ゲームを終了
  GameState endGame() {
    return copyWith(
      isGameEnded: true,
      gameEndTime: DateTime.now(),
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'isGameStarted': isGameStarted,
      'isGamePaused': isGamePaused,
      'isGameEnded': isGameEnded,
      'gameStartTime': gameStartTime.toIso8601String(),
      'gameEndTime': gameEndTime?.toIso8601String(),
    };
  }

  /// JSON形式から復元
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      isGameStarted: json['isGameStarted'] ?? false,
      isGamePaused: json['isGamePaused'] ?? false,
      isGameEnded: json['isGameEnded'] ?? false,
      gameStartTime: DateTime.parse(json['gameStartTime']),
      gameEndTime: json['gameEndTime'] != null 
          ? DateTime.parse(json['gameEndTime']) 
          : null,
    );
  }

  /// 初期状態のゲーム状態を作成
  factory GameState.initial() {
    return GameState(
      gameStartTime: DateTime.now(),
    );
  }
}
