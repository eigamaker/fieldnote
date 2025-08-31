import '../entities/player.dart';

/// 選手データの保存・読み込みを管理するリポジトリインターフェース
abstract class PlayerRepository {
  /// 選手を保存
  Future<bool> savePlayer(Player player);
  
  /// 選手を読み込み
  Future<Player?> loadPlayer(String playerId);
  
  /// すべての選手を読み込み
  Future<List<Player>> loadAllPlayers();
  
  /// 学校に所属する選手を読み込み
  Future<List<Player>> loadPlayersBySchool(String schoolId);
  
  /// 選手を削除
  Future<bool> deletePlayer(String playerId);
  
  /// 選手が存在するかチェック
  Future<bool> hasPlayer(String playerId);
  
  /// 学校に所属する選手数を取得
  Future<int> getPlayerCountBySchool(String schoolId);
  
  /// 総選手数を取得
  Future<int> getTotalPlayerCount();
}
