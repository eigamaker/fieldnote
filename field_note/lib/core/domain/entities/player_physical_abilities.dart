/// 選手のフィジカル能力値を管理するエンティティクラス
class PlayerPhysicalAbilities {
  final int strength;      // 筋力 (1-150)
  final int agility;       // 敏捷性 (1-150)
  final int stamina;       // 持久力 (1-150)
  final int flexibility;   // 柔軟性 (1-150)
  final int balance;       // バランス (1-150)
  final int explosiveness; // 瞬発力 (1-150)

  const PlayerPhysicalAbilities({
    required this.strength,
    required this.agility,
    required this.stamina,
    required this.flexibility,
    required this.balance,
    required this.explosiveness,
  });

  /// フィジカル能力値の平均を計算
  double get average {
    return (strength + agility + stamina + flexibility + balance + explosiveness) / 6.0;
  }

  /// フィジカル能力値の合計を計算
  int get total {
    return strength + agility + stamina + flexibility + balance + explosiveness;
  }

  /// プロパティを更新したコピーを作成
  PlayerPhysicalAbilities copyWith({
    int? strength,
    int? agility,
    int? stamina,
    int? flexibility,
    int? balance,
    int? explosiveness,
  }) {
    return PlayerPhysicalAbilities(
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      stamina: stamina ?? this.stamina,
      flexibility: flexibility ?? this.flexibility,
      balance: balance ?? this.balance,
      explosiveness: explosiveness ?? this.explosiveness,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'agility': agility,
      'stamina': stamina,
      'flexibility': flexibility,
      'balance': balance,
      'explosiveness': explosiveness,
    };
  }

  /// JSON形式から復元
  factory PlayerPhysicalAbilities.fromJson(Map<String, dynamic> json) {
    return PlayerPhysicalAbilities(
      strength: json['strength'] ?? 50,
      agility: json['agility'] ?? 50,
      stamina: json['stamina'] ?? 50,
      flexibility: json['flexibility'] ?? 50,
      balance: json['balance'] ?? 50,
      explosiveness: json['explosiveness'] ?? 50,
    );
  }

  /// ランダムなフィジカル能力値を生成
  factory PlayerPhysicalAbilities.random() {
    return PlayerPhysicalAbilities(
      strength: _generateRandomAbility(),
      agility: _generateRandomAbility(),
      stamina: _generateRandomAbility(),
      flexibility: _generateRandomAbility(),
      balance: _generateRandomAbility(),
      explosiveness: _generateRandomAbility(),
    );
  }

  /// 高品質なフィジカル能力値を生成（スカウトスキルに依存）
  factory PlayerPhysicalAbilities.generateHighQuality(double scoutSkill) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final minValue = (40 + (baseQuality * 30)).round();
    final maxValue = (70 + (baseQuality * 30)).round();
    
    return PlayerPhysicalAbilities(
      strength: _generateRandomAbilityInRange(minValue, maxValue),
      agility: _generateRandomAbilityInRange(minValue, maxValue),
      stamina: _generateRandomAbilityInRange(minValue, maxValue),
      flexibility: _generateRandomAbilityInRange(minValue, maxValue),
      balance: _generateRandomAbilityInRange(minValue, maxValue),
      explosiveness: _generateRandomAbilityInRange(minValue, maxValue),
    );
  }

  /// ランダムな能力値を生成（デフォルト範囲）
  static int _generateRandomAbility() {
    return _generateRandomAbilityInRange(40, 80);
  }

  /// 指定範囲でランダムな能力値を生成
  static int _generateRandomAbilityInRange(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
}
