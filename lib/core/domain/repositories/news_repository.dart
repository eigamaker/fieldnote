import '../entities/news_item.dart';

abstract class NewsRepository {
  // 基本的なCRUD操作
  Future<void> saveNewsItem(NewsItem newsItem);
  Future<NewsItem?> loadNewsItem(String newsId);
  Future<void> deleteNewsItem(String newsId);
  Future<bool> hasNewsData();

  // 一括操作
  Future<void> saveNewsItems(List<NewsItem> newsItems);
  Future<List<NewsItem>> loadAllNewsItems();
  Future<void> deleteAllNewsItems();

  // 検索・フィルタリング
  Future<List<NewsItem>> searchNewsByKeyword(String keyword);
  Future<List<NewsItem>> filterNewsByCategory(String category);
  Future<List<NewsItem>> filterNewsByImportance(String importance);
  Future<List<NewsItem>> getNewsByDateRange(DateTime startDate, DateTime endDate);

  // 関連データによる検索
  Future<List<NewsItem>> getNewsByPlayer(String playerId);
  Future<List<NewsItem>> getNewsByTeam(String teamId);
  Future<List<NewsItem>> getNewsByTournament(String tournamentId);

  // 統計・分析
  Future<int> getNewsCount();
  Future<Map<String, int>> getNewsCountByCategory();
  Future<Map<String, int>> getNewsCountByImportance();
  Future<List<NewsItem>> getRecentNews(int limit);

  // ニュース管理
  Future<void> markNewsAsRead(String newsId);
  Future<void> markNewsAsImportant(String newsId);
  Future<List<NewsItem>> getUnreadNews();
  Future<List<NewsItem>> getImportantNews();

  // データ整合性
  Future<bool> validateNewsData();
  Future<void> cleanupOldNews(int daysToKeep);
}
