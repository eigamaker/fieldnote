enum EventType {
  playerInjury('選手怪我'),
  playerIllness('選手病気'),
  specialGrowth('特別成長'),
  scoutingChance('スカウトチャンス'),
  teamMorale('チーム士気'),
  weatherEvent('天候イベント'),
  randomEvent('ランダムイベント');

  const EventType(this.label);
  final String label;
}

enum EventImpact {
  positive('ポジティブ'),
  negative('ネガティブ'),
  neutral('中立'),
  mixed('混合');

  const EventImpact(this.label);
  final String label;
}

class GameEvent {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final EventImpact impact;
  final double probability;
  final DateTime occurredAt;
  final String? targetPlayerId;
  final String? targetTeamId;
  final Map<String, dynamic> effects;
  final Map<String, dynamic> conditions;
  final bool isActive;
  final DateTime? resolvedAt;

  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.impact,
    required this.probability,
    required this.occurredAt,
    this.targetPlayerId,
    this.targetTeamId,
    this.effects = const {},
    this.conditions = const {},
    this.isActive = true,
    this.resolvedAt,
  });

  factory GameEvent.initial({
    required String title,
    required String description,
    required EventType type,
    required EventImpact impact,
    required double probability,
    String? targetPlayerId,
    String? targetTeamId,
    Map<String, dynamic> effects = const {},
    Map<String, dynamic> conditions = const {},
  }) {
    return GameEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      impact: impact,
      probability: probability,
      occurredAt: DateTime.now(),
      targetPlayerId: targetPlayerId,
      targetTeamId: targetTeamId,
      effects: effects,
      conditions: conditions,
    );
  }

  GameEvent copyWith({
    String? id,
    String? title,
    String? description,
    EventType? type,
    EventImpact? impact,
    double? probability,
    DateTime? occurredAt,
    String? targetPlayerId,
    String? targetTeamId,
    Map<String, dynamic>? effects,
    Map<String, dynamic>? conditions,
    bool? isActive,
    DateTime? resolvedAt,
  }) {
    return GameEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      impact: impact ?? this.impact,
      probability: probability ?? this.probability,
      occurredAt: occurredAt ?? this.occurredAt,
      targetPlayerId: targetPlayerId ?? this.targetPlayerId,
      targetTeamId: targetTeamId ?? this.targetTeamId,
      effects: effects ?? this.effects,
      conditions: conditions ?? this.conditions,
      isActive: isActive ?? this.isActive,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  GameEvent resolve() {
    return copyWith(
      isActive: false,
      resolvedAt: DateTime.now(),
    );
  }

  bool canOccur(Map<String, dynamic> currentConditions) {
    for (final entry in conditions.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (!currentConditions.containsKey(key)) return false;
      
      final currentValue = currentConditions[key];
      if (currentValue != value) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'impact': impact.name,
      'probability': probability,
      'occurredAt': occurredAt.toIso8601String(),
      'targetPlayerId': targetPlayerId,
      'targetTeamId': targetTeamId,
      'effects': effects,
      'conditions': conditions,
      'isActive': isActive,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.randomEvent,
      ),
      impact: EventImpact.values.firstWhere(
        (e) => e.name == json['impact'],
        orElse: () => EventImpact.neutral,
      ),
      probability: (json['probability'] as num).toDouble(),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      targetPlayerId: json['targetPlayerId'] as String?,
      targetTeamId: json['targetTeamId'] as String?,
      effects: Map<String, dynamic>.from(json['effects'] ?? {}),
      conditions: Map<String, dynamic>.from(json['conditions'] ?? {}),
      isActive: json['isActive'] as bool? ?? true,
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt'] as String) 
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GameEvent(id: $id, title: $title, type: ${type.label}, impact: ${impact.label})';
  }
}
