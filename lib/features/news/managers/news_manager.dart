import 'dart:async';
import '../../../core/domain/entities/news_item.dart';
import '../../../core/domain/repositories/news_repository.dart';

class NewsManager {
  final NewsRepository _repository;
  final StreamController<List<NewsItem>> _newsController = StreamController<List<NewsItem>>.broadcast();
  final StreamController<NewsItem> _latestNewsController = StreamController<NewsItem>.broadcast();

  NewsManager(this._repository);

  // ストリーム
  Stream<List<NewsItem>> get newsStream => _newsController.stream;
  Stream<NewsItem> get latestNewsStream => _latestNewsController.stream;

  // 初期化
  Future<void> initialize() async {
    if (await _repository.hasNewsData()) {
      final newsItems = await _repository.loadAllNewsItems();
      _newsController.add(newsItems);
    }
  }

  // ニュースの追加
  Future<void> addNews(NewsItem newsItem) async {
    await _repository.saveNewsItem(newsItem);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
    _latestNewsController.add(newsItem);
  }

  // 複数ニュースの追加
  Future<void> addMultipleNews(List<NewsItem> newsItems) async {
    await _repository.saveNewsItems(newsItems);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
    
    if (newsItems.isNotEmpty) {
      _latestNewsController.add(newsItems.last);
    }
  }

  // ニュースの取得
  Future<List<NewsItem>> getAllNews() async {
    return await _repository.loadAllNewsItems();
  }

  Future<NewsItem?> getNewsById(String newsId) async {
    return await _repository.loadNewsItem(newsId);
  }

  // ニュースの検索・フィルタリング
  Future<List<NewsItem>> searchNews(String keyword) async {
    return await _repository.searchNewsByKeyword(keyword);
  }

  Future<List<NewsItem>> filterByCategory(String category) async {
    return await _repository.filterNewsByCategory(category);
  }

  Future<List<NewsItem>> filterByImportance(String importance) async {
    return await _repository.filterNewsByImportance(importance);
  }

  Future<List<NewsItem>> getNewsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _repository.getNewsByDateRange(startDate, endDate);
  }

  // 関連データによる検索
  Future<List<NewsItem>> getNewsByPlayer(String playerId) async {
    return await _repository.getNewsByPlayer(playerId);
  }

  Future<List<NewsItem>> getNewsByTeam(String teamId) async {
    return await _repository.getNewsByTeam(teamId);
  }

  Future<List<NewsItem>> getNewsByTournament(String tournamentId) async {
    return await _repository.getNewsByTournament(tournamentId);
  }

  // 統計情報
  Future<int> getNewsCount() async {
    return await _repository.getNewsCount();
  }

  Future<Map<String, int>> getNewsCountByCategory() async {
    return await _repository.getNewsCountByCategory();
  }

  Future<Map<String, int>> getNewsCountByImportance() async {
    return await _repository.getNewsCountByImportance();
  }

  Future<List<NewsItem>> getRecentNews(int limit) async {
    return await _repository.getRecentNews(limit);
  }

  // ニュース管理
  Future<void> markNewsAsRead(String newsId) async {
    await _repository.markNewsAsRead(newsId);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
  }

  Future<void> markNewsAsImportant(String newsId) async {
    await _repository.markNewsAsImportant(newsId);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
  }

  Future<List<NewsItem>> getUnreadNews() async {
    return await _repository.getUnreadNews();
  }

  Future<List<NewsItem>> getImportantNews() async {
    return await _repository.getImportantNews();
  }

  // ニュースの削除
  Future<void> deleteNews(String newsId) async {
    await _repository.deleteNewsItem(newsId);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
  }

  Future<void> deleteAllNews() async {
    await _repository.deleteAllNewsItems();
    _newsController.add([]);
  }

  // データ整合性
  Future<bool> validateData() async {
    return await _repository.validateNewsData();
  }

  Future<void> cleanupOldNews(int daysToKeep) async {
    await _repository.cleanupOldNews(daysToKeep);
    final allNews = await _repository.loadAllNewsItems();
    _newsController.add(allNews);
  }

  // リソース解放
  void dispose() {
    _newsController.close();
    _latestNewsController.close();
  }
}
