import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/scout_action.dart';

/// 選手生成ロジックを管理するクラス
class PlayerGenerator {
  static const List<String> _positions = ['P', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF'];
  
  /// スカウトアクションに基づいて選手を生成
  static List<Player> generatePlayersFromScouting({
    required ScoutAction scoutAction,
    required School school,
  }) {
    final players = <Player>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // スカウトスキルに基づく発見確率を計算
    final baseDiscoveryChance = _calculateDiscoveryChance(scoutAction.scoutSkill, school.level);
    
    // 発見する選手数を決定（1-3名）
    final playerCount = _determinePlayerCount(baseDiscoveryChance, random);
    
    // 選手を生成
    for (int i = 0; i < playerCount; i++) {
      final position = _selectPosition(random + i);
      final player = Player.generate(
        schoolId: school.id.toString(),
        scoutSkill: scoutAction.scoutSkill,
        position: position,
      );
      players.add(player);
    }
    
    return players;
  }
  
  /// 発見確率を計算
  static double _calculateDiscoveryChance(double scoutSkill, int schoolLevel) {
    // 基本発見確率（スカウトスキルに依存）
    final baseChance = (scoutSkill / 100.0).clamp(0.0, 1.0);
    
    // 学校レベルによる補正（レベルが高いほど発見しやすい）
    final levelBonus = (schoolLevel - 1) * 0.1;
    
    // 最終発見確率
    final finalChance = (baseChance + levelBonus).clamp(0.1, 0.9);
    
    return finalChance;
  }
  
  /// 発見する選手数を決定
  static int _determinePlayerCount(double discoveryChance, int randomSeed) {
    final random = randomSeed % 100;
    final chance = (discoveryChance * 100).round();
    
    if (random < chance * 0.3) {
      return 3; // 30%の確率で3名
    } else if (random < chance * 0.7) {
      return 2; // 40%の確率で2名
    } else if (random < chance) {
      return 1; // 30%の確率で1名
    } else {
      return 0; // 発見失敗
    }
  }
  
  /// ポジションを選択
  static String _selectPosition(int randomSeed) {
    final random = randomSeed % _positions.length;
    return _positions[random];
  }
  
  /// スカウト結果の品質を評価
  static String evaluateScoutingResult(List<Player> players) {
    if (players.isEmpty) return '失敗';
    
    final totalRating = players.fold(0.0, (sum, player) => sum + player.averageAbility);
    final averageRating = totalRating / players.length;
    
    if (averageRating >= 75) return '優秀';
    if (averageRating >= 65) return '良好';
    if (averageRating >= 55) return '普通';
    return '未熟';
  }
  
  /// スカウト結果のサマリーを生成
  static String generateScoutingSummary({
    required ScoutAction scoutAction,
    required List<Player> discoveredPlayers,
    required String evaluation,
  }) {
    final playerCount = discoveredPlayers.length;
    final schoolName = scoutAction.schoolName;
    final scoutSkill = scoutAction.scoutSkill;
    
    if (playerCount == 0) {
      return '''
スカウト結果: 失敗
対象校: $schoolName
使用スキル: ${scoutSkill.toStringAsFixed(1)}
発見選手: なし
''';
    }
    
    final bestPlayer = discoveredPlayers.reduce((a, b) => 
        a.averageAbility > b.averageAbility ? a : b);
    
    return '''
スカウト結果: $evaluation
対象校: $schoolName
使用スキル: ${scoutSkill.toStringAsFixed(1)}
発見選手: ${playerCount}名
最高評価選手: ${bestPlayer.name} (${bestPlayer.overallRating})
''';
  }
}
