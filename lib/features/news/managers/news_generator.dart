import 'dart:math';
import '../../../core/domain/entities/news_item.dart';
import '../../../core/domain/entities/player.dart';
import '../../../core/domain/entities/school.dart';
import '../../../core/domain/entities/tournament.dart';
import '../../../core/domain/entities/professional_team.dart';
import '../../../core/domain/entities/professional_player.dart';

class NewsGenerator {
  static final Random _random = Random();

  // 選手活躍ニュースの生成
  static NewsItem generatePlayerPerformanceNews({
    required Player player,
    required String performance,
    NewsImportance importance = NewsImportance.medium,
  }) {
    final titles = [
      '${player.name}選手、${performance}を達成！',
      '${player.name}選手の活躍が話題に',
      '${player.name}選手、素晴らしいプレーを披露',
    ];

    final contents = [
      '${player.schoolName}の${player.name}選手が${performance}を達成し、チームの勝利に大きく貢献しました。',
      '${player.name}選手の卓越した技術と集中力が光る試合となりました。',
      '${player.schoolName}の${player.name}選手が、見事な${performance}で観客を魅了しました。',
    ];

    final title = titles[_random.nextInt(titles.length)];
    final content = contents[_random.nextInt(contents.length)];

    return NewsItem.initial(
      title: title,
      content: content,
      category: NewsCategory.playerPerformance,
      importance: importance,
      relatedPlayerId: player.id,
      relatedTeamId: player.schoolId,
    );
  }

  // 大会結果ニュースの生成
  static NewsItem generateTournamentResultNews({
    required Tournament tournament,
    required String winnerName,
    required String runnerUpName,
    NewsImportance importance = NewsImportance.high,
  }) {
    final titles = [
      '${tournament.type.label}大会、${winnerName}が優勝！',
      '${winnerName}、${tournament.type.label}大会で栄冠を手に',
      '${tournament.type.label}大会、激戦の末${winnerName}が勝利',
    ];

    final contents = [
      '${tournament.type.label}大会が終了し、${winnerName}が優勝、${runnerUpName}が準優勝を果たしました。',
      '${winnerName}の選手たちが素晴らしいチームプレーを見せ、${tournament.type.label}大会を制しました。',
      '${tournament.type.label}大会は大変な盛り上がりを見せ、${winnerName}が栄冠を手にしました。',
    ];

    final title = titles[_random.nextInt(titles.length)];
    final content = contents[_random.nextInt(contents.length)];

    return NewsItem.initial(
      title: title,
      content: content,
      category: NewsCategory.tournamentResult,
      importance: importance,
      relatedTeamId: tournament.participatingSchools.first,
      relatedTournamentId: tournament.id,
    );
  }

  // スカウト活動ニュースの生成
  static NewsItem generateScoutingActivityNews({
    required String scoutName,
    required String schoolName,
    required String discovery,
    NewsImportance importance = NewsImportance.medium,
  }) {
    final titles = [
      '${scoutName}スカウト、${schoolName}で逸材を発見！',
      '${scoutName}スカウトの慧眼、${schoolName}で新星を発掘',
      '${scoutName}スカウト、${schoolName}で有望選手を発見',
    ];

    final contents = [
      '${scoutName}スカウトが${schoolName}で${discovery}を発見し、将来性の高さを評価しています。',
      '${scoutName}スカウトの鋭い観察眼により、${schoolName}で${discovery}が発掘されました。',
      '${scoutName}スカウトが${schoolName}で行った調査で、${discovery}という有望選手が発見されました。',
    ];

    final title = titles[_random.nextInt(titles.length)];
    final content = contents[_random.nextInt(contents.length)];

    return NewsItem.initial(
      title: title,
      content: content,
      category: NewsCategory.scoutingActivity,
      importance: importance,
      relatedTeamId: schoolName,
    );
  }

  // プロ野球ニュースの生成
  static NewsItem generateProfessionalBaseballNews({
    required ProfessionalTeam team,
    required ProfessionalPlayer? player,
    required String event,
    NewsImportance importance = NewsImportance.high,
  }) {
    String title;
    String content;
    String? relatedPlayerId;

    if (player != null) {
      title = '${player.name}選手、${event}！';
      content = '${team.city}${team.name}の${player.name}選手が${event}を達成し、チームの勝利に貢献しました。';
      relatedPlayerId = player.id;
    } else {
      title = '${team.city}${team.name}、${event}';
      content = '${team.city}${team.name}が${event}を達成し、ファンを沸かせました。';
    }

    return NewsItem.initial(
      title: title,
      content: content,
      category: NewsCategory.professionalBaseball,
      importance: importance,
      relatedTeamId: team.id,
      relatedPlayerId: relatedPlayerId,
    );
  }

  // 特別イベントニュースの生成
  static NewsItem generateSpecialEventNews({
    required String eventTitle,
    required String eventDescription,
    NewsImportance importance = NewsImportance.medium,
  }) {
    return NewsItem.initial(
      title: eventTitle,
      content: eventDescription,
      category: NewsCategory.specialEvent,
      importance: importance,
    );
  }

  // 週進行に基づくニュース生成
  static List<NewsItem> generateWeeklyNews({
    required DateTime currentDate,
    required List<Player> activePlayers,
    required List<School> activeSchools,
    required List<Tournament> activeTournaments,
  }) {
    final newsItems = <NewsItem>[];

    // 選手活躍ニュース（確率ベース）
    for (final player in activePlayers) {
      if (_random.nextDouble() < 0.1) { // 10%の確率
        final performances = [
          'ホームラン',
          '完投勝利',
          '3安打',
          '盗塁',
          '好守備',
        ];
        final performance = performances[_random.nextInt(performances.length)];
        
        newsItems.add(generatePlayerPerformanceNews(
          player: player,
          performance: performance,
        ));
      }
    }

    // 大会結果ニュース（大会が終了している場合）
    for (final tournament in activeTournaments) {
      if (tournament.status.name == 'completed' && _random.nextDouble() < 0.8) {
        final winner = tournament.participatingSchools.first;
        final runnerUp = tournament.participatingSchools.length > 1 
            ? tournament.participatingSchools[1] 
            : '不明';
        
        newsItems.add(generateTournamentResultNews(
          tournament: tournament,
          winnerName: winner,
          runnerUpName: runnerUp,
        ));
      }
    }

    // 特別イベントニュース（低確率）
    if (_random.nextDouble() < 0.05) { // 5%の確率
      final specialEvents = [
        ('野球部OB会開催', 'OB会が開催され、現役選手たちが先輩たちから貴重なアドバイスを受けました。'),
        ('野球教室開催', 'プロ野球選手による野球教室が開催され、多くの子どもたちが参加しました。'),
        ('野球用具寄贈', '地域の企業から野球用具が寄贈され、選手たちの練習環境が向上しました。'),
      ];

      final event = specialEvents[_random.nextInt(specialEvents.length)];
      newsItems.add(generateSpecialEventNews(
        eventTitle: event.$1,
        eventDescription: event.$2,
      ));
    }

    return newsItems;
  }

  // 重要度の自動判定
  static NewsImportance determineImportance({
    required String category,
    required Map<String, dynamic> context,
  }) {
    switch (category) {
      case 'playerPerformance':
        final performance = context['performance'] as String?;
        if (performance?.contains('記録') == true || performance?.contains('完投') == true) {
          return NewsImportance.high;
        }
        return NewsImportance.medium;
      
      case 'tournamentResult':
        return NewsImportance.high;
      
      case 'scoutingActivity':
        return NewsImportance.medium;
      
      case 'professionalBaseball':
        return NewsImportance.high;
      
      case 'specialEvent':
        return NewsImportance.medium;
      
      default:
        return NewsImportance.medium;
    }
  }
}
