import 'dart:math';
import '../../../core/domain/entities/game_event.dart';
import '../../../core/domain/entities/event_trigger.dart';

class EventCalculator {
  static final Random _random = Random();

  // イベント発生確率の計算
  static double calculateEventProbability({
    required GameEvent event,
    required Map<String, dynamic> currentConditions,
    required Set<String> activeFlags,
  }) {
    double baseProbability = event.probability;
    
    // 現在の条件による確率調整
    baseProbability = _adjustProbabilityByConditions(
      baseProbability,
      event.conditions,
      currentConditions,
    );
    
    // アクティブフラグによる確率調整
    baseProbability = _adjustProbabilityByFlags(
      baseProbability,
      event,
      activeFlags,
    );
    
    // イベントタイプによる確率調整
    baseProbability = _adjustProbabilityByEventType(
      baseProbability,
      event.type,
      currentConditions,
    );
    
    // 確率の範囲制限（0.0 - 1.0）
    return baseProbability.clamp(0.0, 1.0);
  }

  // 条件による確率調整
  static double _adjustProbabilityByConditions(
    double baseProbability,
    Map<String, dynamic> eventConditions,
    Map<String, dynamic> currentConditions,
  ) {
    double adjustedProbability = baseProbability;
    
    for (final entry in eventConditions.entries) {
      final key = entry.key;
      final expectedValue = entry.value;
      
      if (currentConditions.containsKey(key)) {
        final currentValue = currentConditions[key];
        
        // 数値の場合の調整
        if (currentValue is num && expectedValue is num) {
          final difference = (currentValue - expectedValue).abs();
          final adjustment = 1.0 - (difference / 100.0); // 100を基準とした調整
          adjustedProbability *= adjustment.clamp(0.1, 2.0);
        }
        
        // 文字列の場合の調整
        else if (currentValue == expectedValue) {
          adjustedProbability *= 1.5; // 条件一致で確率上昇
        }
      }
    }
    
    return adjustedProbability;
  }

  // フラグによる確率調整
  static double _adjustProbabilityByFlags(
    double baseProbability,
    GameEvent event,
    Set<String> activeFlags,
  ) {
    double adjustedProbability = baseProbability;
    
    // 必須フラグのチェック
    for (final flag in event.conditions['requiredFlags'] ?? []) {
      if (activeFlags.contains(flag)) {
        adjustedProbability *= 1.2; // 必須フラグがアクティブで確率上昇
      } else {
        adjustedProbability *= 0.1; // 必須フラグが非アクティブで確率大幅下降
      }
    }
    
    // 除外フラグのチェック
    for (final flag in event.conditions['excludedFlags'] ?? []) {
      if (activeFlags.contains(flag)) {
        adjustedProbability *= 0.1; // 除外フラグがアクティブで確率大幅下降
      }
    }
    
    return adjustedProbability;
  }

  // イベントタイプによる確率調整
  static double _adjustProbabilityByEventType(
    double baseProbability,
    EventType eventType,
    Map<String, dynamic> currentConditions,
  ) {
    double adjustedProbability = baseProbability;
    
    switch (eventType) {
      case EventType.playerInjury:
        // 選手の疲労度や練習量による調整
        final fatigue = currentConditions['playerFatigue'] as num? ?? 0;
        final practiceIntensity = currentConditions['practiceIntensity'] as num? ?? 1;
        
        if (fatigue > 80) adjustedProbability *= 2.0; // 高疲労で怪我確率上昇
        if (practiceIntensity > 8) adjustedProbability *= 1.5; // 高強度練習で怪我確率上昇
        
        break;
        
      case EventType.playerIllness:
        // 季節や選手の体調による調整
        final month = currentConditions['month'] as int? ?? 1;
        final playerHealth = currentConditions['playerHealth'] as num? ?? 100;
        
        if (month == 12 || month == 1 || month == 2) {
          adjustedProbability *= 1.3; // 冬場で病気確率上昇
        }
        if (playerHealth < 70) adjustedProbability *= 1.5; // 体調不良で病気確率上昇
        
        break;
        
      case EventType.specialGrowth:
        // 選手の才能や努力による調整
        final talent = currentConditions['playerTalent'] as num? ?? 50;
        final effort = currentConditions['playerEffort'] as num? ?? 50;
        
        if (talent > 80 && effort > 80) {
          adjustedProbability *= 1.8; // 高才能・高努力で特別成長確率上昇
        }
        
        break;
        
      case EventType.scoutingChance:
        // スカウトのスキルや学校レベルによる調整
        final scoutSkill = currentConditions['scoutSkill'] as num? ?? 50;
        final schoolLevel = currentConditions['schoolLevel'] as num? ?? 50;
        
        if (scoutSkill > 80) adjustedProbability *= 1.4; // 高スキルでスカウトチャンス確率上昇
        if (schoolLevel > 80) adjustedProbability *= 1.3; // 高レベル校でスカウトチャンス確率上昇
        
        break;
        
      case EventType.teamMorale:
        // チームの成績や雰囲気による調整
        final teamRecord = currentConditions['teamRecord'] as num? ?? 0.5;
        final teamAtmosphere = currentConditions['teamAtmosphere'] as num? ?? 50;
        
        if (teamRecord > 0.7) adjustedProbability *= 1.3; // 好成績で士気イベント確率上昇
        if (teamAtmosphere < 30) adjustedProbability *= 1.6; // 低士気で士気イベント確率上昇
        
        break;
        
      case EventType.weatherEvent:
        // 季節や地域による調整
        final month = currentConditions['month'] as int? ?? 1;
        final region = currentConditions['region'] as String? ?? '関東';
        
        if (month == 6 || month == 7) {
          adjustedProbability *= 1.4; // 梅雨時期で天候イベント確率上昇
        }
        if (region == '北海道') {
          adjustedProbability *= 1.2; // 北海道で天候イベント確率上昇
        }
        
        break;
        
      case EventType.randomEvent:
        // ランダムイベントは基本確率をそのまま使用
        break;
    }
    
    return adjustedProbability;
  }

  // イベントの影響度評価
  static double calculateEventImpact({
    required GameEvent event,
    required Map<String, dynamic> targetContext,
  }) {
    double impactScore = 0.0;
    
    switch (event.impact) {
      case EventImpact.positive:
        impactScore = 1.0;
        break;
      case EventImpact.negative:
        impactScore = -1.0;
        break;
      case EventImpact.neutral:
        impactScore = 0.0;
        break;
      case EventImpact.mixed:
        impactScore = 0.5;
        break;
    }
    
    // イベントタイプによる影響度調整
    impactScore = _adjustImpactByEventType(impactScore, event.type, targetContext);
    
    // 重要度による影響度調整
    impactScore = _adjustImpactByImportance(impactScore, event);
    
    return impactScore;
  }

  // イベントタイプによる影響度調整
  static double _adjustImpactByEventType(
    double impactScore,
    EventType eventType,
    Map<String, dynamic> targetContext,
  ) {
    double adjustedImpact = impactScore;
    
    switch (eventType) {
      case EventType.playerInjury:
        // 怪我の深刻度による調整
        final severity = targetContext['injurySeverity'] as num? ?? 1;
        adjustedImpact *= severity;
        break;
        
      case EventType.specialGrowth:
        // 成長の大きさによる調整
        final growthAmount = targetContext['growthAmount'] as num? ?? 1;
        adjustedImpact *= growthAmount;
        break;
        
      case EventType.scoutingChance:
        // スカウトの質による調整
        final scoutQuality = targetContext['scoutQuality'] as num? ?? 1;
        adjustedImpact *= scoutQuality;
        break;
        
      case EventType.teamMorale:
        // 士気の変化量による調整
        final moraleChange = targetContext['moraleChange'] as num? ?? 1;
        adjustedImpact *= moraleChange;
        break;
        
      default:
        break;
    }
    
    return adjustedImpact;
  }

  // 重要度による影響度調整
  static double _adjustImpactByImportance(double impactScore, GameEvent event) {
    // イベントの重要度に応じた調整（実装は簡略化）
    return impactScore;
  }

  // 複数イベントの優先度計算
  static List<GameEvent> prioritizeEvents(List<GameEvent> events) {
    final priorityOrder = {
      EventType.playerInjury: 1,
      EventType.playerIllness: 2,
      EventType.specialGrowth: 3,
      EventType.scoutingChance: 4,
      EventType.teamMorale: 5,
      EventType.weatherEvent: 6,
      EventType.randomEvent: 7,
    };
    
    events.sort((a, b) {
      final aPriority = priorityOrder[a.type] ?? 999;
      final bPriority = priorityOrder[b.type] ?? 999;
      return aPriority.compareTo(bPriority);
    });
    
    return events;
  }

  // イベントの組み合わせ効果計算
  static double calculateCombinationEffect(List<GameEvent> events) {
    if (events.isEmpty) return 0.0;
    
    double totalEffect = 0.0;
    double combinationBonus = 1.0;
    
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final impact = calculateEventImpact(
        event: event,
        targetContext: {},
      );
      
      totalEffect += impact;
      
      // 連続イベントによるボーナス効果
      if (i > 0) {
        final timeDiff = events[i].occurredAt.difference(events[i - 1].occurredAt).inDays;
        if (timeDiff <= 7) { // 1週間以内の連続イベント
          combinationBonus += 0.1;
        }
      }
    }
    
    return totalEffect * combinationBonus;
  }
}
