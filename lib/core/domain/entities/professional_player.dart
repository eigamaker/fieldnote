enum PlayerPosition {
  pitcher('投手'),
  catcher('捕手'),
  firstBase('一塁手'),
  secondBase('二塁手'),
  thirdBase('三塁手'),
  shortstop('遊撃手'),
  leftField('左翼手'),
  centerField('中堅手'),
  rightField('右翼手'),
  designatedHitter('指名打者');

  const PlayerPosition(this.label);
  final String label;
}

enum PlayerStatus {
  active('現役'),
  injured('怪我'),
  suspended('出場停止'),
  retired('引退'),
  freeAgent('フリーエージェント');

  const PlayerStatus(this.label);
  final String label;
}

class ProfessionalPlayer {
  final String id;
  final String name;
  final String teamId;
  final PlayerPosition primaryPosition;
  final List<PlayerPosition> positions;
  final int age;
  final int experience;
  final PlayerStatus status;
  final Map<String, int> abilities;
  final Map<String, dynamic> seasonStats;
  final Map<String, dynamic> careerStats;
  final Map<String, dynamic> achievements;
  final DateTime birthDate;
  final DateTime debutDate;
  final DateTime? retirementDate;
  final int salary;
  final int contractYears;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfessionalPlayer({
    required this.id,
    required this.name,
    required this.teamId,
    required this.primaryPosition,
    required this.positions,
    required this.age,
    required this.experience,
    required this.status,
    required this.abilities,
    required this.seasonStats,
    required this.careerStats,
    required this.achievements,
    required this.birthDate,
    required this.debutDate,
    this.retirementDate,
    required this.salary,
    required this.contractYears,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalPlayer.initial({
    required String id,
    required String name,
    required String teamId,
    required PlayerPosition primaryPosition,
    required List<PlayerPosition> positions,
    required DateTime birthDate,
    required Map<String, int> abilities,
  }) {
    final now = DateTime.now();
    final debutDate = now;
    final age = now.year - birthDate.year;
    
    return ProfessionalPlayer(
      id: id,
      name: name,
      teamId: teamId,
      primaryPosition: primaryPosition,
      positions: positions,
      age: age,
      experience: 0,
      status: PlayerStatus.active,
      abilities: abilities,
      seasonStats: _createInitialSeasonStats(),
      careerStats: _createInitialCareerStats(),
      achievements: _createInitialAchievements(),
      birthDate: birthDate,
      debutDate: debutDate,
      retirementDate: null,
      salary: 10000000, // 1000万円
      contractYears: 1,
      createdAt: now,
      updatedAt: now,
    );
  }

  static Map<String, dynamic> _createInitialSeasonStats() {
    return {
      'games': 0,
      'atBats': 0,
      'hits': 0,
      'homeRuns': 0,
      'runsBattedIn': 0,
      'stolenBases': 0,
      'battingAverage': 0.0,
      'onBasePercentage': 0.0,
      'sluggingPercentage': 0.0,
      'wins': 0,
      'losses': 0,
      'earnedRunAverage': 0.0,
      'inningsPitched': 0.0,
      'strikeouts': 0,
      'walks': 0,
      'hitsAllowed': 0,
      'homeRunsAllowed': 0,
    };
  }

  static Map<String, dynamic> _createInitialCareerStats() {
    return {
      'seasons': 0,
      'totalGames': 0,
      'totalAtBats': 0,
      'totalHits': 0,
      'totalHomeRuns': 0,
      'totalRunsBattedIn': 0,
      'totalStolenBases': 0,
      'careerBattingAverage': 0.0,
      'careerOnBasePercentage': 0.0,
      'careerSluggingPercentage': 0.0,
      'totalWins': 0,
      'totalLosses': 0,
      'careerEarnedRunAverage': 0.0,
      'totalInningsPitched': 0.0,
      'totalStrikeouts': 0,
      'totalWalks': 0,
      'totalHitsAllowed': 0,
      'totalHomeRunsAllowed': 0,
    };
  }

  static Map<String, dynamic> _createInitialAchievements() {
    return {
      'allStarAppearances': 0,
      'mvpAwards': 0,
      'goldGloveAwards': 0,
      'silverSluggerAwards': 0,
      'rookieOfTheYear': 0,
      'championships': 0,
      'battingTitles': 0,
      'homeRunTitles': 0,
      'rbiTitles': 0,
      'stolenBaseTitles': 0,
      'eraTitles': 0,
      'strikeoutTitles': 0,
      'saveTitles': 0,
    };
  }

  ProfessionalPlayer copyWith({
    String? id,
    String? name,
    String? teamId,
    PlayerPosition? primaryPosition,
    List<PlayerPosition>? positions,
    int? age,
    int? experience,
    PlayerStatus? status,
    Map<String, int>? abilities,
    Map<String, dynamic>? seasonStats,
    Map<String, dynamic>? careerStats,
    Map<String, dynamic>? achievements,
    DateTime? birthDate,
    DateTime? debutDate,
    DateTime? retirementDate,
    int? salary,
    int? contractYears,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      teamId: teamId ?? this.teamId,
      primaryPosition: primaryPosition ?? this.primaryPosition,
      positions: positions ?? this.positions,
      age: age ?? this.age,
      experience: experience ?? this.experience,
      status: status ?? this.status,
      abilities: abilities ?? this.abilities,
      seasonStats: seasonStats ?? this.seasonStats,
      careerStats: careerStats ?? this.careerStats,
      achievements: achievements ?? this.achievements,
      birthDate: birthDate ?? this.birthDate,
      debutDate: debutDate ?? this.debutDate,
      retirementDate: retirementDate ?? this.retirementDate,
      salary: salary ?? this.salary,
      contractYears: contractYears ?? this.contractYears,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  ProfessionalPlayer updateAge(DateTime currentDate) {
    final newAge = currentDate.year - birthDate.year;
    return copyWith(age: newAge);
  }

  ProfessionalPlayer addExperience(int years) {
    return copyWith(experience: experience + years);
  }

  ProfessionalPlayer updateStatus(PlayerStatus newStatus) {
    return copyWith(status: newStatus);
  }

  ProfessionalPlayer retire(DateTime retirementDate) {
    return copyWith(
      status: PlayerStatus.retired,
      retirementDate: retirementDate,
    );
  }

  ProfessionalPlayer transferToTeam(String newTeamId) {
    return copyWith(teamId: newTeamId);
  }

  ProfessionalPlayer updateAbilities(Map<String, int> newAbilities) {
    final updatedAbilities = Map<String, int>.from(abilities);
    updatedAbilities.addAll(newAbilities);
    return copyWith(abilities: updatedAbilities);
  }

  ProfessionalPlayer updateSeasonStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(seasonStats);
    updatedStats.addAll(newStats);
    
    // 打率を計算
    final atBats = updatedStats['atBats'] ?? 0;
    final hits = updatedStats['hits'] ?? 0;
    if (atBats > 0) {
      updatedStats['battingAverage'] = hits / atBats;
    }
    
    // 出塁率を計算（簡易版）
    final walks = updatedStats['walks'] ?? 0;
    final totalPlateAppearances = atBats + walks;
    if (totalPlateAppearances > 0) {
      updatedStats['onBasePercentage'] = (hits + walks) / totalPlateAppearances;
    }
    
    // 長打率を計算（簡易版）
    final homeRuns = updatedStats['homeRuns'] ?? 0;
    if (atBats > 0) {
      updatedStats['sluggingPercentage'] = (hits + homeRuns * 3) / atBats;
    }
    
    return copyWith(seasonStats: updatedStats);
  }

  ProfessionalPlayer resetSeasonStats() {
    return copyWith(seasonStats: _createInitialSeasonStats());
  }

  ProfessionalPlayer updateCareerStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(careerStats);
    updatedStats.addAll(newStats);
    return copyWith(careerStats: updatedStats);
  }

  ProfessionalPlayer addAchievement(String achievementType, int count) {
    final updatedAchievements = Map<String, dynamic>.from(achievements);
    final currentCount = updatedAchievements[achievementType] ?? 0;
    updatedAchievements[achievementType] = currentCount + count;
    return copyWith(achievements: updatedAchievements);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teamId': teamId,
      'primaryPosition': primaryPosition.name,
      'positions': positions.map((p) => p.name).toList(),
      'age': age,
      'experience': experience,
      'status': status.name,
      'abilities': abilities,
      'seasonStats': seasonStats,
      'careerStats': careerStats,
      'achievements': achievements,
      'birthDate': birthDate.toIso8601String(),
      'debutDate': debutDate.toIso8601String(),
      'retirementDate': retirementDate?.toIso8601String(),
      'salary': salary,
      'contractYears': contractYears,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfessionalPlayer.fromJson(Map<String, dynamic> json) {
    return ProfessionalPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      teamId: json['teamId'] as String,
      primaryPosition: PlayerPosition.values.firstWhere((e) => e.name == json['primaryPosition']),
      positions: (json['positions'] as List).map((p) => PlayerPosition.values.firstWhere((e) => e.name == p)).toList(),
      age: json['age'] as int,
      experience: json['experience'] as int,
      status: PlayerStatus.values.firstWhere((e) => e.name == json['status']),
      abilities: Map<String, int>.from(json['abilities']),
      seasonStats: Map<String, dynamic>.from(json['seasonStats']),
      careerStats: Map<String, dynamic>.from(json['careerStats']),
      achievements: Map<String, dynamic>.from(json['achievements']),
      birthDate: DateTime.parse(json['birthDate'] as String),
      debutDate: DateTime.parse(json['debutDate'] as String),
      retirementDate: json['retirementDate'] != null ? DateTime.parse(json['retirementDate'] as String) : null,
      salary: json['salary'] as int,
      contractYears: json['contractYears'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfessionalPlayer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProfessionalPlayer(id: $id, name: $name, position: ${primaryPosition.label}, team: $teamId)';
  }
}
