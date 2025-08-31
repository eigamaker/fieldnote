enum TriggerCondition {
  weeklyProgression('週進行'),
  playerAction('選手アクション'),
  tournamentResult('大会結果'),
  scoutingActivity('スカウト活動'),
  professionalGame('プロ野球試合'),
  randomChance('ランダムチャンス'),
  specificDate('特定日'),
  playerCondition('選手状態');

  const TriggerCondition(this.label);
  final String label;
}

enum TriggerPriority {
  low('低'),
  normal('通常'),
  high('高'),
  critical('重要');

  const TriggerPriority(this.label);
  final String label;
}

class EventTrigger {
  final String id;
  final String eventId;
  final TriggerCondition condition;
  final TriggerPriority priority;
  final Map<String, dynamic> parameters;
  final bool isActive;
  final DateTime? lastTriggered;
  final int cooldownWeeks;
  final int maxOccurrences;
  final int currentOccurrences;
  final List<String> requiredFlags;
  final List<String> excludedFlags;

  const EventTrigger({
    required this.id,
    required this.eventId,
    required this.condition,
    required this.priority,
    this.parameters = const {},
    this.isActive = true,
    this.lastTriggered,
    this.cooldownWeeks = 0,
    this.maxOccurrences = -1,
    this.currentOccurrences = 0,
    this.requiredFlags = const [],
    this.excludedFlags = const [],
  });

  factory EventTrigger.initial({
    required String eventId,
    required TriggerCondition condition,
    required TriggerPriority priority,
    Map<String, dynamic> parameters = const {},
    int cooldownWeeks = 0,
    int maxOccurrences = -1,
    List<String> requiredFlags = const [],
    List<String> excludedFlags = const [],
  }) {
    return EventTrigger(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId,
      condition: condition,
      priority: priority,
      parameters: parameters,
      cooldownWeeks: cooldownWeeks,
      maxOccurrences: maxOccurrences,
      requiredFlags: requiredFlags,
      excludedFlags: excludedFlags,
    );
  }

  EventTrigger copyWith({
    String? id,
    String? eventId,
    TriggerCondition? condition,
    TriggerPriority? priority,
    Map<String, dynamic>? parameters,
    bool? isActive,
    DateTime? lastTriggered,
    int? cooldownWeeks,
    int? maxOccurrences,
    int? currentOccurrences,
    List<String>? requiredFlags,
    List<String>? excludedFlags,
  }) {
    return EventTrigger(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      condition: condition ?? this.condition,
      priority: priority ?? this.priority,
      parameters: parameters ?? this.parameters,
      isActive: isActive ?? this.isActive,
      lastTriggered: lastTriggered ?? this.lastTriggered,
      cooldownWeeks: cooldownWeeks ?? this.cooldownWeeks,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      currentOccurrences: currentOccurrences ?? this.currentOccurrences,
      requiredFlags: requiredFlags ?? this.requiredFlags,
      excludedFlags: excludedFlags ?? this.excludedFlags,
    );
  }

  EventTrigger trigger() {
    return copyWith(
      lastTriggered: DateTime.now(),
      currentOccurrences: currentOccurrences + 1,
    );
  }

  bool canTrigger(DateTime currentDate, Set<String> activeFlags) {
    if (!isActive) return false;
    
    // 最大発生回数チェック
    if (maxOccurrences > 0 && currentOccurrences >= maxOccurrences) {
      return false;
    }
    
    // クールダウンチェック
    if (cooldownWeeks > 0 && lastTriggered != null) {
      final weeksSinceLastTrigger = currentDate.difference(lastTriggered!).inDays ~/ 7;
      if (weeksSinceLastTrigger < cooldownWeeks) {
        return false;
      }
    }
    
    // 必須フラグチェック
    for (final flag in requiredFlags) {
      if (!activeFlags.contains(flag)) {
        return false;
      }
    }
    
    // 除外フラグチェック
    for (final flag in excludedFlags) {
      if (activeFlags.contains(flag)) {
        return false;
      }
    }
    
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'condition': condition.name,
      'priority': priority.name,
      'parameters': parameters,
      'isActive': isActive,
      'lastTriggered': lastTriggered?.toIso8601String(),
      'cooldownWeeks': cooldownWeeks,
      'maxOccurrences': maxOccurrences,
      'currentOccurrences': currentOccurrences,
      'requiredFlags': requiredFlags,
      'excludedFlags': excludedFlags,
    };
  }

  factory EventTrigger.fromJson(Map<String, dynamic> json) {
    return EventTrigger(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      condition: TriggerCondition.values.firstWhere(
        (e) => e.name == json['condition'],
        orElse: () => TriggerCondition.randomChance,
      ),
      priority: TriggerPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TriggerPriority.normal,
      ),
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
      isActive: json['isActive'] as bool? ?? true,
      lastTriggered: json['lastTriggered'] != null 
          ? DateTime.parse(json['lastTriggered'] as String) 
          : null,
      cooldownWeeks: json['cooldownWeeks'] as int? ?? 0,
      maxOccurrences: json['maxOccurrences'] as int? ?? -1,
      currentOccurrences: json['currentOccurrences'] as int? ?? 0,
      requiredFlags: List<String>.from(json['requiredFlags'] ?? []),
      excludedFlags: List<String>.from(json['excludedFlags'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventTrigger && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EventTrigger(id: $id, eventId: $eventId, condition: ${condition.label}, priority: ${priority.label})';
  }
}
