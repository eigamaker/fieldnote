import 'package:flutter/foundation.dart';

enum NewsCategory {
  playerPerformance('選手活躍'),
  tournamentResult('大会結果'),
  scoutingActivity('スカウト活動'),
  professionalBaseball('プロ野球'),
  specialEvent('特別イベント');

  const NewsCategory(this.label);
  final String label;
}

enum NewsImportance {
  low('低'),
  medium('中'),
  high('高'),
  critical('重要');

  const NewsImportance(this.label);
  final String label;
}

@immutable
class NewsItem {
  final String id;
  final String title;
  final String content;
  final NewsCategory category;
  final NewsImportance importance;
  final DateTime publishedAt;
  final String? relatedPlayerId;
  final String? relatedTeamId;
  final String? relatedTournamentId;
  final Map<String, dynamic> metadata;

  const NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.importance,
    required this.publishedAt,
    this.relatedPlayerId,
    this.relatedTeamId,
    this.relatedTournamentId,
    this.metadata = const {},
  });

  factory NewsItem.initial({
    required String title,
    required String content,
    required NewsCategory category,
    required NewsImportance importance,
    String? relatedPlayerId,
    String? relatedTeamId,
    String? relatedTournamentId,
    Map<String, dynamic> metadata = const {},
  }) {
    return NewsItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      category: category,
      importance: importance,
      publishedAt: DateTime.now(),
      relatedPlayerId: relatedPlayerId,
      relatedTeamId: relatedTeamId,
      relatedTournamentId: relatedTournamentId,
      metadata: metadata,
    );
  }

  NewsItem copyWith({
    String? id,
    String? title,
    String? content,
    NewsCategory? category,
    NewsImportance? importance,
    DateTime? publishedAt,
    String? relatedPlayerId,
    String? relatedTeamId,
    String? relatedTournamentId,
    Map<String, dynamic>? metadata,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      importance: importance ?? this.importance,
      publishedAt: publishedAt ?? this.publishedAt,
      relatedPlayerId: relatedPlayerId ?? this.relatedPlayerId,
      relatedTeamId: relatedTeamId ?? this.relatedTeamId,
      relatedTournamentId: relatedTournamentId ?? this.relatedTournamentId,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.name,
      'importance': importance.name,
      'publishedAt': publishedAt.toIso8601String(),
      'relatedPlayerId': relatedPlayerId,
      'relatedTeamId': relatedTeamId,
      'relatedTournamentId': relatedTournamentId,
      'metadata': metadata,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: NewsCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NewsCategory.specialEvent,
      ),
      importance: NewsImportance.values.firstWhere(
        (e) => e.name == json['importance'],
        orElse: () => NewsImportance.medium,
      ),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      relatedPlayerId: json['relatedPlayerId'] as String?,
      relatedTeamId: json['relatedTeamId'] as String?,
      relatedTournamentId: json['relatedTournamentId'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NewsItem(id: $id, title: $title, category: ${category.label}, importance: ${importance.label})';
  }
}
