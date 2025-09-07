/// 選手の能力値を管理するエンティティクラス
class PlayerAbilities {
  final int batting;      // 打撃力 (1-100)
  final int power;        // パワー (1-100)
  final int speed;        // 走力 (1-100)
  final int fielding;     // 守備力 (1-100)
  final int throwing;     // 肩力 (1-100)
  final int pitching;     // 投球力 (1-100)
  final int control;      // 制球力 (1-100)
  final int stamina;      // スタミナ (1-100)

  const PlayerAbilities({
    required this.batting,
    required this.power,
    required this.speed,
    required this.fielding,
    required this.throwing,
    required this.pitching,
    required this.control,
    required this.stamina,
  });

  /// 総合能力値を計算
  int get totalAbility {
    return batting + power + speed + fielding + throwing + pitching + control + stamina;
  }

  /// 平均能力値を計算
  double get averageAbility {
    return totalAbility / 8.0;
  }

  /// 打者としての能力値を計算
  int get battingAbility {
    return (batting + power + speed) ~/ 3;
  }

  /// 投手としての能力値を計算
  int get pitchingAbility {
    return (pitching + control + stamina) ~/ 3;
  }

  /// 守備者としての能力値を計算
  int get fieldingAbility {
    return (fielding + throwing + speed) ~/ 3;
  }

  /// 能力値の評価を取得
  String get overallRating {
    final avg = averageAbility;
    if (avg >= 85) return 'S';
    if (avg >= 75) return 'A';
    if (avg >= 65) return 'B';
    if (avg >= 55) return 'C';
    if (avg >= 45) return 'D';
    return 'E';
  }

  /// プロパティを更新したコピーを作成
  PlayerAbilities copyWith({
    int? batting,
    int? power,
    int? speed,
    int? fielding,
    int? throwing,
    int? pitching,
    int? control,
    int? stamina,
  }) {
    return PlayerAbilities(
      batting: batting ?? this.batting,
      power: power ?? this.power,
      speed: speed ?? this.speed,
      fielding: fielding ?? this.fielding,
      throwing: throwing ?? this.throwing,
      pitching: pitching ?? this.pitching,
      control: control ?? this.control,
      stamina: stamina ?? this.stamina,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'batting': batting,
      'power': power,
      'speed': speed,
      'fielding': fielding,
      'throwing': throwing,
      'pitching': pitching,
      'control': control,
      'stamina': stamina,
    };
  }

  /// JSON形式から復元
  factory PlayerAbilities.fromJson(Map<String, dynamic> json) {
    return PlayerAbilities(
      batting: json['batting'] ?? 50,
      power: json['power'] ?? 50,
      speed: json['speed'] ?? 50,
      fielding: json['fielding'] ?? 50,
      throwing: json['throwing'] ?? 50,
      pitching: json['pitching'] ?? 50,
      control: json['control'] ?? 50,
      stamina: json['stamina'] ?? 50,
    );
  }

  /// ランダムな能力値を生成
  factory PlayerAbilities.random() {
    return PlayerAbilities(
      batting: _generateRandomAbility(),
      power: _generateRandomAbility(),
      speed: _generateRandomAbility(),
      fielding: _generateRandomAbility(),
      throwing: _generateRandomAbility(),
      pitching: _generateRandomAbility(),
      control: _generateRandomAbility(),
      stamina: _generateRandomAbility(),
    );
  }

  /// 高品質な能力値を生成（スカウトスキルに依存）
  factory PlayerAbilities.generateHighQuality(double scoutSkill) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final minValue = (30 + (baseQuality * 40)).round();
    final maxValue = (60 + (baseQuality * 40)).round();
    
    return PlayerAbilities(
      batting: _generateRandomAbilityInRange(minValue, maxValue),
      power: _generateRandomAbilityInRange(minValue, maxValue),
      speed: _generateRandomAbilityInRange(minValue, maxValue),
      fielding: _generateRandomAbilityInRange(minValue, maxValue),
      throwing: _generateRandomAbilityInRange(minValue, maxValue),
      pitching: _generateRandomAbilityInRange(minValue, maxValue),
      control: _generateRandomAbilityInRange(minValue, maxValue),
      stamina: _generateRandomAbilityInRange(minValue, maxValue),
    );
  }


  /// ランダムな能力値を生成（デフォルト範囲）
  static int _generateRandomAbility() {
    return _generateRandomAbilityInRange(30, 80);
  }

  /// 指定範囲でランダムな能力値を生成
  static int _generateRandomAbilityInRange(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
}
