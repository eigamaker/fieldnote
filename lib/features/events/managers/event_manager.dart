import 'dart:async';
import '../../../core/domain/entities/game_event.dart';
import '../../../core/domain/repositories/event_repository.dart';

class EventManager {
  final EventRepository _repository;
  final StreamController<List<GameEvent>> _eventsController = StreamController<List<GameEvent>>.broadcast();
  final StreamController<GameEvent> _newEventController = StreamController<GameEvent>.broadcast();

  EventManager(this._repository);

  // ストリーム
  Stream<List<GameEvent>> get eventsStream => _eventsController.stream;
  Stream<GameEvent> get newEventStream => _newEventController.stream;

  // 初期化
  Future<void> initialize() async {
    if (await _repository.hasEventData()) {
      final events = await _repository.loadAllGameEvents();
      _eventsController.add(events);
    }
  }

  // イベントの追加
  Future<void> addEvent(GameEvent event) async {
    await _repository.saveGameEvent(event);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
    _newEventController.add(event);
  }

  // 複数イベントの追加
  Future<void> addMultipleEvents(List<GameEvent> events) async {
    await _repository.saveGameEvents(events);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
    
    for (final event in events) {
      _newEventController.add(event);
    }
  }

  // イベントの取得
  Future<List<GameEvent>> getAllEvents() async {
    return await _repository.loadAllGameEvents();
  }

  Future<GameEvent?> getEventById(String eventId) async {
    return await _repository.loadGameEvent(eventId);
  }

  // イベントの検索・フィルタリング
  Future<List<GameEvent>> getEventsByType(String eventType) async {
    return await _repository.getEventsByType(eventType);
  }

  Future<List<GameEvent>> getEventsByImpact(String impact) async {
    return await _repository.getEventsByImpact(impact);
  }

  Future<List<GameEvent>> getActiveEvents() async {
    return await _repository.getActiveEvents();
  }

  Future<List<GameEvent>> getResolvedEvents() async {
    return await _repository.getResolvedEvents();
  }

  Future<List<GameEvent>> getEventsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getEventsByDateRange(startDate, endDate);
  }

  // 関連データによる検索
  Future<List<GameEvent>> getEventsByPlayer(String playerId) async {
    return await _repository.getEventsByPlayer(playerId);
  }

  Future<List<GameEvent>> getEventsByTeam(String teamId) async {
    return await _repository.getEventsByTeam(teamId);
  }

  // イベント管理
  Future<void> resolveEvent(String eventId) async {
    final event = await _repository.loadGameEvent(eventId);
    if (event != null) {
      final resolvedEvent = event.resolve();
      await _repository.saveGameEvent(resolvedEvent);
      final allEvents = await _repository.loadAllGameEvents();
      _eventsController.add(allEvents);
    }
  }

  Future<void> activateEvent(String eventId) async {
    await _repository.activateEvent(eventId);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
  }

  Future<void> deactivateEvent(String eventId) async {
    await _repository.deactivateEvent(eventId);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
  }

  // イベントの削除
  Future<void> deleteEvent(String eventId) async {
    await _repository.deleteGameEvent(eventId);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
  }

  Future<void> deleteAllEvents() async {
    await _repository.deleteAllGameEvents();
    _eventsController.add([]);
  }

  // 統計情報
  Future<int> getEventCount() async {
    return await _repository.getEventCount();
  }

  Future<Map<String, int>> getEventCountByType() async {
    return await _repository.getEventCountByType();
  }

  Future<Map<String, int>> getEventCountByImpact() async {
    return await _repository.getEventCountByImpact();
  }

  // データ整合性
  Future<bool> validateData() async {
    return await _repository.validateEventData();
  }

  Future<void> cleanupOldEvents(int daysToKeep) async {
    await _repository.cleanupOldEvents(daysToKeep);
    final allEvents = await _repository.loadAllGameEvents();
    _eventsController.add(allEvents);
  }

  // 週進行時のイベント処理
  Future<List<GameEvent>> processWeeklyEvents(DateTime currentDate) async {
    final activeEvents = await getActiveEvents();
    final resolvedEvents = <GameEvent>[];

    for (final event in activeEvents) {
      // イベントの解決条件をチェック
      if (_shouldResolveEvent(event, currentDate)) {
        final resolvedEvent = event.resolve();
        await _repository.saveGameEvent(resolvedEvent);
        resolvedEvents.add(resolvedEvent);
      }
    }

    if (resolvedEvents.isNotEmpty) {
      final allEvents = await _repository.loadAllGameEvents();
      _eventsController.add(allEvents);
    }

    return resolvedEvents;
  }

  // イベント解決条件の判定
  bool _shouldResolveEvent(GameEvent event, DateTime currentDate) {
    // イベントの種類に応じた解決条件を実装
    switch (event.type) {
      case EventType.playerInjury:
        // 怪我イベントは一定期間後に解決
        final injuryDuration = event.effects['duration'] as int? ?? 2;
        final weeksSinceInjury = currentDate.difference(event.occurredAt).inDays ~/ 7;
        return weeksSinceInjury >= injuryDuration;
      
      case EventType.playerIllness:
        // 病気イベントは短期間で解決
        final illnessDuration = event.effects['duration'] as int? ?? 1;
        final weeksSinceIllness = currentDate.difference(event.occurredAt).inDays ~/ 7;
        return weeksSinceIllness >= illnessDuration;
      
      case EventType.specialGrowth:
        // 特別成長イベントは即座に解決
        return true;
      
      case EventType.scoutingChance:
        // スカウトチャンスは一定期間後に解決
        final chanceDuration = event.effects['duration'] as int? ?? 1;
        final weeksSinceChance = currentDate.difference(event.occurredAt).inDays ~/ 7;
        return weeksSinceChance >= chanceDuration;
      
      case EventType.teamMorale:
        // チーム士気イベントは一定期間後に解決
        final moraleDuration = event.effects['duration'] as int? ?? 2;
        final weeksSinceMorale = currentDate.difference(event.occurredAt).inDays ~/ 7;
        return weeksSinceMorale >= moraleDuration;
      
      case EventType.weatherEvent:
        // 天候イベントは短期間で解決
        final weatherDuration = event.effects['duration'] as int? ?? 1;
        final weeksSinceWeather = currentDate.difference(event.occurredAt).inDays ~/ 7;
        return weeksSinceWeather >= weatherDuration;
      
      case EventType.randomEvent:
        // ランダムイベントは即座に解決
        return true;
      
      default:
        return false;
    }
  }

  // リソース解放
  void dispose() {
    _eventsController.close();
    _newEventController.close();
  }
}
