/// 投手のテクニカル能力値を管理するエンティティクラス
class PlayerPitcherTechnicalAbilities {
  final int velocity;      // 球速 (1-150)
  final int control;       // 制球力 (1-150)
  final int breakingBall;  // 変化球 (1-150)
  final int pitchVariety;  // 球種 (1-150)

  const PlayerPitcherTechnicalAbilities({
    required this.velocity,
    required this.control,
    required this.breakingBall,
    required this.pitchVariety,
  });

  /// 投手テクニカル能力値の平均を計算
  double get average {
    return (velocity + control + breakingBall + pitchVariety) / 4.0;
  }

  /// 投手テクニカル能力値の合計を計算
  int get total {
    return velocity + control + breakingBall + pitchVariety;
  }

  /// 球速を実数値（km/h）に変換
  double get velocityKmh {
    return 125 + (velocity * 0.267);
  }

  /// 変化球の変化量（cm）を計算
  double get breakingBallMovement {
    return 5 + (breakingBall * 0.167);
  }

  /// 習得球種数を計算
  int get learnedPitchCount {
    if (pitchVariety <= 30) return 2; // 直球のみ
    if (pitchVariety <= 60) return 3; // 直球+1変化球
    if (pitchVariety <= 90) return 4; // 直球+2変化球
    if (pitchVariety <= 120) return 5; // 直球+3変化球
    return 6; // 直球+4変化球以上
  }

  /// 制球力からストライク率を計算
  double get strikeRate {
    return 0.6 + (control * 0.00167); // 60-85%
  }

  /// プロパティを更新したコピーを作成
  PlayerPitcherTechnicalAbilities copyWith({
    int? velocity,
    int? control,
    int? breakingBall,
    int? pitchVariety,
  }) {
    return PlayerPitcherTechnicalAbilities(
      velocity: velocity ?? this.velocity,
      control: control ?? this.control,
      breakingBall: breakingBall ?? this.breakingBall,
      pitchVariety: pitchVariety ?? this.pitchVariety,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'velocity': velocity,
      'control': control,
      'breakingBall': breakingBall,
      'pitchVariety': pitchVariety,
    };
  }

  /// JSON形式から復元
  factory PlayerPitcherTechnicalAbilities.fromJson(Map<String, dynamic> json) {
    return PlayerPitcherTechnicalAbilities(
      velocity: json['velocity'] ?? 50,
      control: json['control'] ?? 50,
      breakingBall: json['breakingBall'] ?? 50,
      pitchVariety: json['pitchVariety'] ?? 50,
    );
  }

  /// ランダムな投手テクニカル能力値を生成
  factory PlayerPitcherTechnicalAbilities.random() {
    return PlayerPitcherTechnicalAbilities(
      velocity: _generateRandomAbility(),
      control: _generateRandomAbility(),
      breakingBall: _generateRandomAbility(),
      pitchVariety: _generateRandomAbility(),
    );
  }

  /// 高品質な投手テクニカル能力値を生成（スカウトスキルに依存）
  factory PlayerPitcherTechnicalAbilities.generateHighQuality(double scoutSkill) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final minValue = (40 + (baseQuality * 30)).round();
    final maxValue = (70 + (baseQuality * 30)).round();
    
    return PlayerPitcherTechnicalAbilities(
      velocity: _generateRandomAbilityInRange(minValue, maxValue),
      control: _generateRandomAbilityInRange(minValue, maxValue),
      breakingBall: _generateRandomAbilityInRange(minValue, maxValue),
      pitchVariety: _generateRandomAbilityInRange(minValue, maxValue),
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
