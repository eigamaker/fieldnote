/// ゲームの進行状況を管理するエンティティクラス
class GameProgress {
  final int currentYear;
  final int currentMonth;
  final int currentWeek;
  final int totalWeeks;
  final DateTime startDate;

  const GameProgress({
    this.currentYear = 1,
    this.currentMonth = 1,
    this.currentWeek = 1,
    this.totalWeeks = 0,
    required this.startDate,
  });

  /// 次の週に進む
  GameProgress advanceWeek() {
    int newWeek = currentWeek + 1;
    int newMonth = currentMonth;
    int newYear = currentYear;

    // 4週間で1ヶ月
    if (newWeek > 4) {
      newWeek = 1;
      newMonth++;
    }

    // 12ヶ月で1年
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }

    return copyWith(
      currentYear: newYear,
      currentMonth: newMonth,
      currentWeek: newWeek,
      totalWeeks: totalWeeks + 1,
    );
  }

  /// 次の月に進む
  GameProgress advanceMonth() {
    int newMonth = currentMonth + 1;
    int newYear = currentYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }

    return copyWith(
      currentYear: newYear,
      currentMonth: newMonth,
      currentWeek: 1,
      totalWeeks: totalWeeks + (5 - currentWeek), // 残りの週を加算
    );
  }

  /// 次の年に進む
  GameProgress advanceYear() {
    return copyWith(
      currentYear: currentYear + 1,
      currentMonth: 1,
      currentWeek: 1,
      totalWeeks: totalWeeks + (52 - ((currentMonth - 1) * 4 + currentWeek - 1)), // 残りの週を加算
    );
  }

  /// 指定した週数だけ進める
  GameProgress advanceByWeeks(int weeks) {
    GameProgress progress = this;
    for (int i = 0; i < weeks; i++) {
      progress = progress.advanceWeek();
    }
    return progress;
  }

  /// プロパティを更新したコピーを作成
  GameProgress copyWith({
    int? currentYear,
    int? currentMonth,
    int? currentWeek,
    int? totalWeeks,
    DateTime? startDate,
  }) {
    return GameProgress(
      currentYear: currentYear ?? this.currentYear,
      currentMonth: currentMonth ?? this.currentMonth,
      currentWeek: currentWeek ?? this.currentWeek,
      totalWeeks: totalWeeks ?? this.totalWeeks,
      startDate: startDate ?? this.startDate,
    );
  }

  /// 現在の日付を取得
  DateTime get currentDate {
    return startDate.add(Duration(days: (totalWeeks * 7)));
  }

  /// 進行状況の文字列表現
  String get progressText {
    return 'Year $currentYear, Month $currentMonth, Week $currentWeek';
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'currentYear': currentYear,
      'currentMonth': currentMonth,
      'currentWeek': currentWeek,
      'totalWeeks': totalWeeks,
      'startDate': startDate.toIso8601String(),
    };
  }

  /// JSON形式から復元
  factory GameProgress.fromJson(Map<String, dynamic> json) {
    return GameProgress(
      currentYear: json['currentYear'] ?? 1,
      currentMonth: json['currentMonth'] ?? 1,
      currentWeek: json['currentWeek'] ?? 1,
      totalWeeks: json['totalWeeks'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
    );
  }

  /// 初期状態の進行状況を作成
  factory GameProgress.initial() {
    return GameProgress(
      startDate: DateTime.now(),
    );
  }
}
