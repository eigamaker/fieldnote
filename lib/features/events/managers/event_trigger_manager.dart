import 'dart:async';
import '../../../core/domain/entities/event_trigger.dart';
import '../../../core/domain/entities/game_event.dart';
import '../../../core/domain/repositories/event_repository.dart';

class EventTriggerManager {
  final EventRepository _repository;
  final StreamController<List<EventTrigger>> _triggersController = StreamController<List<EventTrigger>>.broadcast();
  final StreamController<EventTrigger> _triggerExecutedController = StreamController<EventTrigger>.broadcast();

  EventTriggerManager(this._repository);

  // ストリーム
  Stream<List<EventTrigger>> get triggersStream => _triggersController.stream;
  Stream<EventTrigger> get triggerExecutedStream => _triggerExecutedController.stream;

  // 初期化
  Future<void> initialize() async {
    final triggers = await _repository.loadAllEventTriggers();
    _triggersController.add(triggers);
  }

  // トリガーの追加
  Future<void> addTrigger(EventTrigger trigger) async {
    await _repository.saveEventTrigger(trigger);
    final allTriggers = await _repository.loadAllEventTriggers();
    _triggersController.add(allTriggers);
  }

  // 複数トリガーの追加
  Future<void> addMultipleTriggers(List<EventTrigger> triggers) async {
    await _repository.saveEventTriggers(triggers);
    final allTriggers = await _repository.loadAllEventTriggers();
    _triggersController.add(allTriggers);
  }

  // トリガーの取得
  Future<List<EventTrigger>> getAllTriggers() async {
    return await _repository.loadAllEventTriggers();
  }

  Future<EventTrigger?> getTriggerById(String triggerId) async {
    return await _repository.loadEventTrigger(triggerId);
  }

  // トリガーの検索・フィルタリング
  Future<List<EventTrigger>> getTriggersByCondition(String condition) async {
    return await _repository.getTriggersByCondition(condition);
  }

  Future<List<EventTrigger>> getTriggersByPriority(String priority) async {
    return await _repository.getTriggersByPriority(priority);
  }

  Future<List<EventTrigger>> getActiveTriggers() async {
    return await _repository.getActiveTriggers();
  }

  Future<List<EventTrigger>> getTriggersForEvent(String eventId) async {
    return await _repository.getTriggersForEvent(eventId);
  }

  // トリガーの管理
  Future<void> updateTrigger(String triggerId, EventTrigger updatedTrigger) async {
    await _repository.updateEventTrigger(triggerId, updatedTrigger);
    final allTriggers = await _repository.loadAllEventTriggers();
    _triggersController.add(allTriggers);
  }

  Future<void> deactivateTrigger(String triggerId) async {
    final trigger = await _repository.loadEventTrigger(triggerId);
    if (trigger != null) {
      final deactivatedTrigger = trigger.copyWith(isActive: false);
      await _repository.saveEventTrigger(deactivatedTrigger);
      final allTriggers = await _repository.loadAllEventTriggers();
      _triggersController.add(allTriggers);
    }
  }

  Future<void> activateTrigger(String triggerId) async {
    final trigger = await _repository.loadEventTrigger(triggerId);
    if (trigger != null) {
      final activatedTrigger = trigger.copyWith(isActive: true);
      await _repository.saveEventTrigger(activatedTrigger);
      final allTriggers = await _repository.loadAllEventTriggers();
      _triggersController.add(allTriggers);
    }
  }

  // トリガーの削除
  Future<void> deleteTrigger(String triggerId) async {
    await _repository.deleteEventTrigger(triggerId);
    final allTriggers = await _repository.loadAllEventTriggers();
    _triggersController.add(allTriggers);
  }

  // 統計情報
  Future<int> getTriggerCount() async {
    return await _repository.getTriggerCount();
  }

  Future<Map<String, int>> getTriggerCountByCondition() async {
    return await _repository.getTriggerCountByCondition();
  }

  // 週進行時のトリガー処理
  Future<List<EventTrigger>> processWeeklyTriggers(DateTime currentDate, Set<String> activeFlags) async {
    final eligibleTriggers = await _repository.getEligibleTriggers(currentDate, activeFlags);
    final executedTriggers = <EventTrigger>[];

    for (final trigger in eligibleTriggers) {
      if (trigger.canTrigger(currentDate, activeFlags)) {
        // トリガーを実行済みとしてマーク
        final executedTrigger = trigger.trigger();
        await _repository.saveEventTrigger(executedTrigger);
        executedTriggers.add(executedTrigger);
        
        // 実行通知
        _triggerExecutedController.add(executedTrigger);
      }
    }

    if (executedTriggers.isNotEmpty) {
      final allTriggers = await _repository.loadAllEventTriggers();
      _triggersController.add(allTriggers);
    }

    return executedTriggers;
  }

  // 特定条件でのトリガー処理
  Future<List<EventTrigger>> processConditionalTriggers(
    TriggerCondition condition,
    DateTime currentDate,
    Set<String> activeFlags,
    Map<String, dynamic> additionalParams,
  ) async {
    final conditionTriggers = await getTriggersByCondition(condition.name);
    final eligibleTriggers = conditionTriggers.where((trigger) => 
      trigger.canTrigger(currentDate, activeFlags)
    ).toList();

    final executedTriggers = <EventTrigger>[];

    for (final trigger in eligibleTriggers) {
      // 追加パラメータによる条件チェック
      if (_checkAdditionalConditions(trigger, additionalParams)) {
        final executedTrigger = trigger.trigger();
        await _repository.saveEventTrigger(executedTrigger);
        executedTriggers.add(executedTrigger);
        
        _triggerExecutedController.add(executedTrigger);
      }
    }

    if (executedTriggers.isNotEmpty) {
      final allTriggers = await _repository.loadAllEventTriggers();
      _triggersController.add(allTriggers);
    }

    return executedTriggers;
  }

  // 追加条件のチェック
  bool _checkAdditionalConditions(EventTrigger trigger, Map<String, dynamic> additionalParams) {
    for (final entry in additionalParams.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (trigger.parameters.containsKey(key)) {
        final triggerValue = trigger.parameters[key];
        if (triggerValue != value) {
          return false;
        }
      }
    }
    return true;
  }

  // トリガーの優先度によるソート
  List<EventTrigger> sortTriggersByPriority(List<EventTrigger> triggers) {
    final priorityOrder = {
      TriggerPriority.critical: 4,
      TriggerPriority.high: 3,
      TriggerPriority.normal: 2,
      TriggerPriority.low: 1,
    };

    triggers.sort((a, b) {
      final aPriority = priorityOrder[a.priority] ?? 0;
      final bPriority = priorityOrder[b.priority] ?? 0;
      return bPriority.compareTo(aPriority);
    });

    return triggers;
  }

  // データ整合性
  Future<bool> validateData() async {
    return await _repository.validateTriggerData();
  }

  Future<void> cleanupExpiredTriggers() async {
    await _repository.cleanupExpiredTriggers();
    final allTriggers = await _repository.loadAllEventTriggers();
    _triggersController.add(allTriggers);
  }

  // リソース解放
  void dispose() {
    _triggersController.close();
    _triggerExecutedController.close();
  }
}
