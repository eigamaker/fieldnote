import 'player_physical_abilities.dart';
import 'player_mental_abilities.dart';
import 'player_pitcher_technical_abilities.dart';
import 'player_batter_technical_abilities.dart';

/// 選手の能力値の3つの値を管理するエンティティクラス
class PlayerAbilityValues {
  final PlayerPhysicalAbilities currentPhysical;
  final PlayerPhysicalAbilities potentialPhysical;
  final PlayerPhysicalAbilities scoutedPhysical;
  
  final PlayerMentalAbilities currentMental;
  final PlayerMentalAbilities potentialMental;
  final PlayerMentalAbilities scoutedMental;
  
  final PlayerPitcherTechnicalAbilities? currentPitcherTechnical;
  final PlayerPitcherTechnicalAbilities? potentialPitcherTechnical;
  final PlayerPitcherTechnicalAbilities? scoutedPitcherTechnical;
  
  final PlayerBatterTechnicalAbilities? currentBatterTechnical;
  final PlayerBatterTechnicalAbilities? potentialBatterTechnical;
  final PlayerBatterTechnicalAbilities? scoutedBatterTechnical;

  const PlayerAbilityValues({
    required this.currentPhysical,
    required this.potentialPhysical,
    required this.scoutedPhysical,
    required this.currentMental,
    required this.potentialMental,
    required this.scoutedMental,
    this.currentPitcherTechnical,
    this.potentialPitcherTechnical,
    this.scoutedPitcherTechnical,
    this.currentBatterTechnical,
    this.potentialBatterTechnical,
    this.scoutedBatterTechnical,
  });

  /// 投手かどうかを判定
  bool get isPitcher => currentPitcherTechnical != null;

  /// 野手かどうかを判定
  bool get isBatter => currentBatterTechnical != null;

  /// 現在のOverall評価を計算（投手）
  double get currentPitcherOverall {
    if (!isPitcher) return 0.0;
    return (currentPhysical.average * 0.25) + 
           (currentMental.average * 0.25) + 
           (currentPitcherTechnical!.average * 0.50);
  }

  /// 現在のOverall評価を計算（野手）
  double get currentBatterOverall {
    if (!isBatter) return 0.0;
    return (currentPhysical.average * 0.30) + 
           (currentMental.average * 0.20) + 
           (currentBatterTechnical!.average * 0.50);
  }

  /// 現在のOverall評価を取得
  double get currentOverall {
    if (isPitcher) return currentPitcherOverall;
    if (isBatter) return currentBatterOverall;
    return 0.0;
  }

  /// スカウト分析のOverall評価を計算（投手）
  double get scoutedPitcherOverall {
    if (!isPitcher) return 0.0;
    return (scoutedPhysical.average * 0.25) + 
           (scoutedMental.average * 0.25) + 
           (scoutedPitcherTechnical!.average * 0.50);
  }

  /// スカウト分析のOverall評価を計算（野手）
  double get scoutedBatterOverall {
    if (!isBatter) return 0.0;
    return (scoutedPhysical.average * 0.30) + 
           (scoutedMental.average * 0.20) + 
           (scoutedBatterTechnical!.average * 0.50);
  }

  /// スカウト分析のOverall評価を取得
  double get scoutedOverall {
    if (isPitcher) return scoutedPitcherOverall;
    if (isBatter) return scoutedBatterOverall;
    return 0.0;
  }

  /// ポテンシャル上限のOverall評価を計算（投手）
  double get potentialPitcherOverall {
    if (!isPitcher) return 0.0;
    return (potentialPhysical.average * 0.25) + 
           (potentialMental.average * 0.25) + 
           (potentialPitcherTechnical!.average * 0.50);
  }

  /// ポテンシャル上限のOverall評価を計算（野手）
  double get potentialBatterOverall {
    if (!isBatter) return 0.0;
    return (potentialPhysical.average * 0.30) + 
           (potentialMental.average * 0.20) + 
           (potentialBatterTechnical!.average * 0.50);
  }

  /// ポテンシャル上限のOverall評価を取得
  double get potentialOverall {
    if (isPitcher) return potentialPitcherOverall;
    if (isBatter) return potentialBatterOverall;
    return 0.0;
  }

  /// 高校時代のOverall評価ランクを取得
  String get overallRating {
    final overall = currentOverall;
    if (overall >= 90) return 'S';
    if (overall >= 80) return 'A';
    if (overall >= 70) return 'B';
    if (overall >= 60) return 'C';
    if (overall >= 50) return 'D';
    return 'E';
  }

  /// スカウト分析のOverall評価ランクを取得
  String get scoutedOverallRating {
    final overall = scoutedOverall;
    if (overall >= 90) return 'S';
    if (overall >= 80) return 'A';
    if (overall >= 70) return 'B';
    if (overall >= 60) return 'C';
    if (overall >= 50) return 'D';
    return 'E';
  }

  /// プロパティを更新したコピーを作成
  PlayerAbilityValues copyWith({
    PlayerPhysicalAbilities? currentPhysical,
    PlayerPhysicalAbilities? potentialPhysical,
    PlayerPhysicalAbilities? scoutedPhysical,
    PlayerMentalAbilities? currentMental,
    PlayerMentalAbilities? potentialMental,
    PlayerMentalAbilities? scoutedMental,
    PlayerPitcherTechnicalAbilities? currentPitcherTechnical,
    PlayerPitcherTechnicalAbilities? potentialPitcherTechnical,
    PlayerPitcherTechnicalAbilities? scoutedPitcherTechnical,
    PlayerBatterTechnicalAbilities? currentBatterTechnical,
    PlayerBatterTechnicalAbilities? potentialBatterTechnical,
    PlayerBatterTechnicalAbilities? scoutedBatterTechnical,
  }) {
    return PlayerAbilityValues(
      currentPhysical: currentPhysical ?? this.currentPhysical,
      potentialPhysical: potentialPhysical ?? this.potentialPhysical,
      scoutedPhysical: scoutedPhysical ?? this.scoutedPhysical,
      currentMental: currentMental ?? this.currentMental,
      potentialMental: potentialMental ?? this.potentialMental,
      scoutedMental: scoutedMental ?? this.scoutedMental,
      currentPitcherTechnical: currentPitcherTechnical ?? this.currentPitcherTechnical,
      potentialPitcherTechnical: potentialPitcherTechnical ?? this.potentialPitcherTechnical,
      scoutedPitcherTechnical: scoutedPitcherTechnical ?? this.scoutedPitcherTechnical,
      currentBatterTechnical: currentBatterTechnical ?? this.currentBatterTechnical,
      potentialBatterTechnical: potentialBatterTechnical ?? this.potentialBatterTechnical,
      scoutedBatterTechnical: scoutedBatterTechnical ?? this.scoutedBatterTechnical,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'currentPhysical': currentPhysical.toJson(),
      'potentialPhysical': potentialPhysical.toJson(),
      'scoutedPhysical': scoutedPhysical.toJson(),
      'currentMental': currentMental.toJson(),
      'potentialMental': potentialMental.toJson(),
      'scoutedMental': scoutedMental.toJson(),
      'currentPitcherTechnical': currentPitcherTechnical?.toJson(),
      'potentialPitcherTechnical': potentialPitcherTechnical?.toJson(),
      'scoutedPitcherTechnical': scoutedPitcherTechnical?.toJson(),
      'currentBatterTechnical': currentBatterTechnical?.toJson(),
      'potentialBatterTechnical': potentialBatterTechnical?.toJson(),
      'scoutedBatterTechnical': scoutedBatterTechnical?.toJson(),
    };
  }

  /// JSON形式から復元
  factory PlayerAbilityValues.fromJson(Map<String, dynamic> json) {
    return PlayerAbilityValues(
      currentPhysical: PlayerPhysicalAbilities.fromJson(json['currentPhysical']),
      potentialPhysical: PlayerPhysicalAbilities.fromJson(json['potentialPhysical']),
      scoutedPhysical: PlayerPhysicalAbilities.fromJson(json['scoutedPhysical']),
      currentMental: PlayerMentalAbilities.fromJson(json['currentMental']),
      potentialMental: PlayerMentalAbilities.fromJson(json['potentialMental']),
      scoutedMental: PlayerMentalAbilities.fromJson(json['scoutedMental']),
      currentPitcherTechnical: json['currentPitcherTechnical'] != null 
          ? PlayerPitcherTechnicalAbilities.fromJson(json['currentPitcherTechnical'])
          : null,
      potentialPitcherTechnical: json['potentialPitcherTechnical'] != null 
          ? PlayerPitcherTechnicalAbilities.fromJson(json['potentialPitcherTechnical'])
          : null,
      scoutedPitcherTechnical: json['scoutedPitcherTechnical'] != null 
          ? PlayerPitcherTechnicalAbilities.fromJson(json['scoutedPitcherTechnical'])
          : null,
      currentBatterTechnical: json['currentBatterTechnical'] != null 
          ? PlayerBatterTechnicalAbilities.fromJson(json['currentBatterTechnical'])
          : null,
      potentialBatterTechnical: json['potentialBatterTechnical'] != null 
          ? PlayerBatterTechnicalAbilities.fromJson(json['potentialBatterTechnical'])
          : null,
      scoutedBatterTechnical: json['scoutedBatterTechnical'] != null 
          ? PlayerBatterTechnicalAbilities.fromJson(json['scoutedBatterTechnical'])
          : null,
    );
  }

  /// 新しい選手の能力値を生成（投手）
  factory PlayerAbilityValues.generatePitcher({
    required double scoutSkill,
    required int talentRank,
  }) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final talentMultiplier = 1.0 + (talentRank - 1) * 0.2;
    
    // 現在値（高校生レベル）
    final currentPhysical = PlayerPhysicalAbilities.generateHighQuality(scoutSkill);
    final currentMental = PlayerMentalAbilities.generateHighQuality(scoutSkill);
    final currentPitcherTechnical = PlayerPitcherTechnicalAbilities.generateHighQuality(scoutSkill);
    
    // ポテンシャル上限値（才能ランクに基づく）
    final potentialPhysical = _generatePotentialAbilities(currentPhysical, talentMultiplier);
    final potentialMental = _generatePotentialAbilities(currentMental, talentMultiplier);
    final potentialPitcherTechnical = _generatePotentialPitcherAbilities(currentPitcherTechnical, talentMultiplier);
    
    // スカウト分析値（現在値に誤差を加える）
    final scoutedPhysical = _generateScoutedAbilities(currentPhysical, scoutSkill);
    final scoutedMental = _generateScoutedAbilities(currentMental, scoutSkill);
    final scoutedPitcherTechnical = _generateScoutedPitcherAbilities(currentPitcherTechnical, scoutSkill);
    
    return PlayerAbilityValues(
      currentPhysical: currentPhysical,
      potentialPhysical: potentialPhysical,
      scoutedPhysical: scoutedPhysical,
      currentMental: currentMental,
      potentialMental: potentialMental,
      scoutedMental: scoutedMental,
      currentPitcherTechnical: currentPitcherTechnical,
      potentialPitcherTechnical: potentialPitcherTechnical,
      scoutedPitcherTechnical: scoutedPitcherTechnical,
    );
  }

  /// 新しい選手の能力値を生成（野手）
  factory PlayerAbilityValues.generateBatter({
    required double scoutSkill,
    required int talentRank,
  }) {
    final baseQuality = (scoutSkill / 100.0).clamp(0.0, 1.0);
    final talentMultiplier = 1.0 + (talentRank - 1) * 0.2;
    
    // 現在値（高校生レベル）
    final currentPhysical = PlayerPhysicalAbilities.generateHighQuality(scoutSkill);
    final currentMental = PlayerMentalAbilities.generateHighQuality(scoutSkill);
    final currentBatterTechnical = PlayerBatterTechnicalAbilities.generateHighQuality(scoutSkill);
    
    // ポテンシャル上限値（才能ランクに基づく）
    final potentialPhysical = _generatePotentialAbilities(currentPhysical, talentMultiplier);
    final potentialMental = _generatePotentialAbilities(currentMental, talentMultiplier);
    final potentialBatterTechnical = _generatePotentialBatterAbilities(currentBatterTechnical, talentMultiplier);
    
    // スカウト分析値（現在値に誤差を加える）
    final scoutedPhysical = _generateScoutedAbilities(currentPhysical, scoutSkill);
    final scoutedMental = _generateScoutedAbilities(currentMental, scoutSkill);
    final scoutedBatterTechnical = _generateScoutedBatterAbilities(currentBatterTechnical, scoutSkill);
    
    return PlayerAbilityValues(
      currentPhysical: currentPhysical,
      potentialPhysical: potentialPhysical,
      scoutedPhysical: scoutedPhysical,
      currentMental: currentMental,
      potentialMental: potentialMental,
      scoutedMental: scoutedMental,
      currentBatterTechnical: currentBatterTechnical,
      potentialBatterTechnical: potentialBatterTechnical,
      scoutedBatterTechnical: scoutedBatterTechnical,
    );
  }

  /// ポテンシャル能力値を生成（フィジカル・メンタル共通）
  static PlayerPhysicalAbilities _generatePotentialAbilities(PlayerPhysicalAbilities current, double talentMultiplier) {
    return PlayerPhysicalAbilities(
      strength: (current.strength * talentMultiplier).clamp(1, 150).round(),
      agility: (current.agility * talentMultiplier).clamp(1, 150).round(),
      stamina: (current.stamina * talentMultiplier).clamp(1, 150).round(),
      flexibility: (current.flexibility * talentMultiplier).clamp(1, 150).round(),
      balance: (current.balance * talentMultiplier).clamp(1, 150).round(),
      explosiveness: (current.explosiveness * talentMultiplier).clamp(1, 150).round(),
    );
  }

  static PlayerMentalAbilities _generatePotentialAbilities(PlayerMentalAbilities current, double talentMultiplier) {
    return PlayerMentalAbilities(
      concentration: (current.concentration * talentMultiplier).clamp(1, 150).round(),
      composure: (current.composure * talentMultiplier).clamp(1, 150).round(),
      decisionMaking: (current.decisionMaking * talentMultiplier).clamp(1, 150).round(),
      ambition: (current.ambition * talentMultiplier).clamp(1, 150).round(),
      discipline: (current.discipline * talentMultiplier).clamp(1, 150).round(),
      leadership: (current.leadership * talentMultiplier).clamp(1, 150).round(),
    );
  }

  /// ポテンシャル能力値を生成（投手テクニカル）
  static PlayerPitcherTechnicalAbilities _generatePotentialPitcherAbilities(PlayerPitcherTechnicalAbilities current, double talentMultiplier) {
    return PlayerPitcherTechnicalAbilities(
      velocity: (current.velocity * talentMultiplier).clamp(1, 150).round(),
      control: (current.control * talentMultiplier).clamp(1, 150).round(),
      breakingBall: (current.breakingBall * talentMultiplier).clamp(1, 150).round(),
      pitchVariety: (current.pitchVariety * talentMultiplier).clamp(1, 150).round(),
    );
  }

  /// ポテンシャル能力値を生成（野手テクニカル）
  static PlayerBatterTechnicalAbilities _generatePotentialBatterAbilities(PlayerBatterTechnicalAbilities current, double talentMultiplier) {
    return PlayerBatterTechnicalAbilities(
      contact: (current.contact * talentMultiplier).clamp(1, 150).round(),
      power: (current.power * talentMultiplier).clamp(1, 150).round(),
      plateDiscipline: (current.plateDiscipline * talentMultiplier).clamp(1, 150).round(),
      fielding: (current.fielding * talentMultiplier).clamp(1, 150).round(),
      throwing: (current.throwing * talentMultiplier).clamp(1, 150).round(),
      baseRunning: (current.baseRunning * talentMultiplier).clamp(1, 150).round(),
    );
  }

  /// スカウト分析能力値を生成（フィジカル・メンタル共通）
  static PlayerPhysicalAbilities _generateScoutedAbilities(PlayerPhysicalAbilities current, double scoutSkill) {
    final errorRange = (100 - scoutSkill) / 10; // スカウトスキルが低いほど誤差が大きい
    return PlayerPhysicalAbilities(
      strength: _addRandomError(current.strength, errorRange),
      agility: _addRandomError(current.agility, errorRange),
      stamina: _addRandomError(current.stamina, errorRange),
      flexibility: _addRandomError(current.flexibility, errorRange),
      balance: _addRandomError(current.balance, errorRange),
      explosiveness: _addRandomError(current.explosiveness, errorRange),
    );
  }

  static PlayerMentalAbilities _generateScoutedAbilities(PlayerMentalAbilities current, double scoutSkill) {
    final errorRange = (100 - scoutSkill) / 10;
    return PlayerMentalAbilities(
      concentration: _addRandomError(current.concentration, errorRange),
      composure: _addRandomError(current.composure, errorRange),
      decisionMaking: _addRandomError(current.decisionMaking, errorRange),
      ambition: _addRandomError(current.ambition, errorRange),
      discipline: _addRandomError(current.discipline, errorRange),
      leadership: _addRandomError(current.leadership, errorRange),
    );
  }

  /// スカウト分析能力値を生成（投手テクニカル）
  static PlayerPitcherTechnicalAbilities _generateScoutedPitcherAbilities(PlayerPitcherTechnicalAbilities current, double scoutSkill) {
    final errorRange = (100 - scoutSkill) / 10;
    return PlayerPitcherTechnicalAbilities(
      velocity: _addRandomError(current.velocity, errorRange),
      control: _addRandomError(current.control, errorRange),
      breakingBall: _addRandomError(current.breakingBall, errorRange),
      pitchVariety: _addRandomError(current.pitchVariety, errorRange),
    );
  }

  /// スカウト分析能力値を生成（野手テクニカル）
  static PlayerBatterTechnicalAbilities _generateScoutedBatterAbilities(PlayerBatterTechnicalAbilities current, double scoutSkill) {
    final errorRange = (100 - scoutSkill) / 10;
    return PlayerBatterTechnicalAbilities(
      contact: _addRandomError(current.contact, errorRange),
      power: _addRandomError(current.power, errorRange),
      plateDiscipline: _addRandomError(current.plateDiscipline, errorRange),
      fielding: _addRandomError(current.fielding, errorRange),
      throwing: _addRandomError(current.throwing, errorRange),
      baseRunning: _addRandomError(current.baseRunning, errorRange),
    );
  }

  /// ランダムな誤差を追加
  static int _addRandomError(int value, double errorRange) {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final error = ((random - 50) / 50.0) * errorRange;
    return (value + error).clamp(1, 150).round();
  }
}
