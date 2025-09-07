/// 選手のメンタル能力値を管理するエンティティクラス
class PlayerMentalAbilities {
  final int concentration;  // 集中力 (1-150)
  final int composure;      // 冷静さ (1-150)
  final int decisionMaking; // 判断力 (1-150)
  final int ambition;       // 向上心 (1-150)
  final int discipline;     // 規律 (1-150)
  final int leadership;     // リーダーシップ (1-150)

  const PlayerMentalAbilities({
    required this.concentration,
    required this.composure,
    required this.decisionMaking,
    required this.ambition,
    required this.discipline,
    required this.leadership,
  });

  /// メンタル能力値の平均を計算
  double get average {
    return (concentration + composure + decisionMaking + ambition + discipline + leadership) / 6.0;
  }

  /// メンタル能力値の合計を計算
  int get total {
    return concentration + composure + decisionMaking + ambition + discipline + leadership;
  }

  /// プロパティを更新したコピーを作成
  PlayerMentalAbilities copyWith({
    int? concentration,
    int? composure,
    int? decisionMaking,
    int? ambition,
    int? discipline,
    int? leadership,
  }) {
    return PlayerMentalAbilities(
      concentration: concentration ?? this.concentration,
      composure: composure ?? this.composure,
      decisionMaking: decisionMaking ?? this.decisionMaking,
      ambition: ambition ?? this.ambition,
      discipline: discipline ?? this.discipline,
      leadership: leadership ?? this.leadership,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'concentration': concentration,
      'composure': composure,
      'decisionMaking': decisionMaking,
      'ambition': ambition,
      'discipline': discipline,
      'leadership': leadership,
    };
  }

  /// JSON形式から復元
  factory PlayerMentalAbilities.fromJson(Map<String, dynamic> json) {
    return PlayerMentalAbilities(
      concentration: json['concentration'] ?? 50,
      composure: json['composure'] ?? 50,
      decisionMaking: json['decisionMaking'] ?? 50,
      ambition: json['ambition'] ?? 50,
      discipline: json['discipline'] ?? 50,
      leadership: json['leadership'] ?? 50,
    );
  }

  /// ランダムなメンタル能力値を生成
  factory PlayerMentalAbilities.random() {
    return PlayerMentalAbilities(
      concentration: _generateRandomAbility(),
      composure: _generateRandomAbility(),
      decisionMaking: _generateRandomAbility(),
      ambition: _generateRandomAbility(),
      discipline: _generateRandomAbility(),
      leadership: _generateRandomAbility(),
    );
  }

  /// 高品質なメンタル能力値を生成（スカウトスキルに依存）
  factory PlayerMentalAbilities.generateHighQuality(double scoutSkill) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final minValue = (40 + (baseQuality * 30)).round();
    final maxValue = (70 + (baseQuality * 30)).round();
    
    return PlayerMentalAbilities(
      concentration: _generateRandomAbilityInRange(minValue, maxValue),
      composure: _generateRandomAbilityInRange(minValue, maxValue),
      decisionMaking: _generateRandomAbilityInRange(minValue, maxValue),
      ambition: _generateRandomAbilityInRange(minValue, maxValue),
      discipline: _generateRandomAbilityInRange(minValue, maxValue),
      leadership: _generateRandomAbilityInRange(minValue, maxValue),
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
