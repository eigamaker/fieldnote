import '../entities/game_event.dart';
import '../entities/event_trigger.dart';

abstract class EventRepository {
  // ゲームイベントの基本的なCRUD操作
  Future<void> saveGameEvent(GameEvent gameEvent);
  Future<GameEvent?> loadGameEvent(String eventId);
  Future<void> deleteGameEvent(String eventId);
  Future<bool> hasEventData();

  // イベントトリガーの基本的なCRUD操作
  Future<void> saveEventTrigger(EventTrigger eventTrigger);
  Future<EventTrigger?> loadEventTrigger(String triggerId);
  Future<void> deleteEventTrigger(String triggerId);

  // 一括操作
  Future<void> saveGameEvents(List<GameEvent> gameEvents);
  Future<List<GameEvent>> loadAllGameEvents();
  Future<void> saveEventTriggers(List<EventTrigger> eventTriggers);
  Future<List<EventTrigger>> loadAllEventTriggers();

  // ゲームイベントの検索・フィルタリング
  Future<List<GameEvent>> getEventsByType(String eventType);
  Future<List<GameEvent>> getEventsByImpact(String impact);
  Future<List<GameEvent>> getActiveEvents();
  Future<List<GameEvent>> getResolvedEvents();
  Future<List<GameEvent>> getEventsByDateRange(DateTime startDate, DateTime endDate);

  // イベントトリガーの検索・フィルタリング
  Future<List<EventTrigger>> getTriggersByCondition(String condition);
  Future<List<EventTrigger>> getTriggersByPriority(String priority);
  Future<List<EventTrigger>> getActiveTriggers();
  Future<List<EventTrigger>> getTriggersForEvent(String eventId);

  // 関連データによる検索
  Future<List<GameEvent>> getEventsByPlayer(String playerId);
  Future<List<GameEvent>> getEventsByTeam(String teamId);

  // イベント管理
  Future<void> resolveEvent(String eventId);
  Future<void> activateEvent(String eventId);
  Future<void> deactivateEvent(String eventId);
  Future<void> updateEventTrigger(String triggerId, EventTrigger updatedTrigger);

  // 統計・分析
  Future<int> getEventCount();
  Future<int> getTriggerCount();
  Future<Map<String, int>> getEventCountByType();
  Future<Map<String, int>> getEventCountByImpact();
  Future<Map<String, int>> getTriggerCountByCondition();

  // イベント実行
  Future<List<EventTrigger>> getEligibleTriggers(DateTime currentDate, Set<String> activeFlags);
  Future<void> markTriggerAsExecuted(String triggerId);

  // データ整合性
  Future<bool> validateEventData();
  Future<bool> validateTriggerData();
  Future<void> cleanupOldEvents(int daysToKeep);
  Future<void> cleanupExpiredTriggers();
}
