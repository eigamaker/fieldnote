/// 野手のテクニカル能力値を管理するエンティティクラス
class PlayerBatterTechnicalAbilities {
  final int contact;           // ミート (1-150)
  final int power;             // パワー (1-150)
  final int plateDiscipline;   // 選球眼 (1-150)
  final int fielding;          // 守備力 (1-150)
  final int throwing;          // 送球 (1-150)
  final int baseRunning;       // 走塁 (1-150)

  const PlayerBatterTechnicalAbilities({
    required this.contact,
    required this.power,
    required this.plateDiscipline,
    required this.fielding,
    required this.throwing,
    required this.baseRunning,
  });

  /// 野手テクニカル能力値の平均を計算
  double get average {
    return (contact + power + plateDiscipline + fielding + throwing + baseRunning) / 6.0;
  }

  /// 野手テクニカル能力値の合計を計算
  int get total {
    return contact + power + plateDiscipline + fielding + throwing + baseRunning;
  }

  /// 打撃能力の平均を計算
  double get battingAverage {
    return (contact + power + plateDiscipline) / 3.0;
  }

  /// 守備能力の平均を計算
  double get fieldingAverage {
    return (fielding + throwing) / 2.0;
  }

  /// プロパティを更新したコピーを作成
  PlayerBatterTechnicalAbilities copyWith({
    int? contact,
    int? power,
    int? plateDiscipline,
    int? fielding,
    int? throwing,
    int? baseRunning,
  }) {
    return PlayerBatterTechnicalAbilities(
      contact: contact ?? this.contact,
      power: power ?? this.power,
      plateDiscipline: plateDiscipline ?? this.plateDiscipline,
      fielding: fielding ?? this.fielding,
      throwing: throwing ?? this.throwing,
      baseRunning: baseRunning ?? this.baseRunning,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'contact': contact,
      'power': power,
      'plateDiscipline': plateDiscipline,
      'fielding': fielding,
      'throwing': throwing,
      'baseRunning': baseRunning,
    };
  }

  /// JSON形式から復元
  factory PlayerBatterTechnicalAbilities.fromJson(Map<String, dynamic> json) {
    return PlayerBatterTechnicalAbilities(
      contact: json['contact'] ?? 50,
      power: json['power'] ?? 50,
      plateDiscipline: json['plateDiscipline'] ?? 50,
      fielding: json['fielding'] ?? 50,
      throwing: json['throwing'] ?? 50,
      baseRunning: json['baseRunning'] ?? 50,
    );
  }

  /// ランダムな野手テクニカル能力値を生成
  factory PlayerBatterTechnicalAbilities.random() {
    return PlayerBatterTechnicalAbilities(
      contact: _generateRandomAbility(),
      power: _generateRandomAbility(),
      plateDiscipline: _generateRandomAbility(),
      fielding: _generateRandomAbility(),
      throwing: _generateRandomAbility(),
      baseRunning: _generateRandomAbility(),
    );
  }

  /// 高品質な野手テクニカル能力値を生成（スカウトスキルに依存）
  factory PlayerBatterTechnicalAbilities.generateHighQuality(double scoutSkill) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final minValue = (40 + (baseQuality * 30)).round();
    final maxValue = (70 + (baseQuality * 30)).round();
    
    return PlayerBatterTechnicalAbilities(
      contact: _generateRandomAbilityInRange(minValue, maxValue),
      power: _generateRandomAbilityInRange(minValue, maxValue),
      plateDiscipline: _generateRandomAbilityInRange(minValue, maxValue),
      fielding: _generateRandomAbilityInRange(minValue, maxValue),
      throwing: _generateRandomAbilityInRange(minValue, maxValue),
      baseRunning: _generateRandomAbilityInRange(minValue, maxValue),
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
