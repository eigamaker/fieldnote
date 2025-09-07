/// 学校を管理するエンティティクラス
class School {
  final int id;
  final String name;
  final String type;
  final String location;
  final String prefecture;
  final String rank;
  final int schoolStrength;

  const School({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.prefecture,
    required this.rank,
    required this.schoolStrength,
  });

  /// 学校の強度レベルを取得
  int get strengthLevel {
    switch (rank) {
      case '名門':
        return 4;
      case '強豪':
        return 3;
      case '中堅':
        return 2;
      case '弱小':
        return 1;
      default:
        return 1;
    }
  }

  /// 学校の強度レベル名を取得
  String get strengthLevelName {
    switch (strengthLevel) {
      case 4:
        return '名門校';
      case 3:
        return '強豪校';
      case 2:
        return '中堅校';
      case 1:
        return '一般校';
      default:
        return '一般校';
    }
  }

  /// 学校のレベル（既存コードとの互換性のため）
  int get level => strengthLevel;

  /// 学校のレベルテキスト（既存コードとの互換性のため）
  String get levelText => strengthLevelName;

  /// 学校のタイプテキスト
  String get typeText {
    switch (type) {
      case 'public':
        return '公立';
      case 'private':
        return '私立';
      case 'national':
        return '国立';
      default:
        return '不明';
    }
  }

  /// 生徒数（仮の値）
  int get studentCount => 500 + (schoolStrength * 10);

  /// 野球部員数（仮の値）
  int get playerCount => 20 + (strengthLevel * 5);

  /// 創立年（仮の値）
  DateTime get establishedDate => DateTime(1900 + (schoolStrength * 2));

  /// スカウト発見確率を取得
  double get scoutDiscoveryRate {
    switch (rank) {
      case '名門':
        return 0.8; // 80%
      case '強豪':
        return 0.6; // 60%
      case '中堅':
        return 0.4; // 40%
      case '弱小':
        return 0.2; // 20%
      default:
        return 0.2;
    }
  }

  /// 学校の詳細情報を取得
  String get detailedInfo {
    return '''
名前: $name
所在地: $location
都道府県: $prefecture
ランク: $rank ($strengthLevelName)
強度: $schoolStrength
発見確率: ${(scoutDiscoveryRate * 100).toInt()}%
''';
  }

  /// プロパティを更新したコピーを作成
  School copyWith({
    int? id,
    String? name,
    String? type,
    String? location,
    String? prefecture,
    String? rank,
    int? schoolStrength,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      prefecture: prefecture ?? this.prefecture,
      rank: rank ?? this.rank,
      schoolStrength: schoolStrength ?? this.schoolStrength,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'prefecture': prefecture,
      'rank': rank,
      'schoolStrength': schoolStrength,
    };
  }

  /// JSON形式から復元
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      location: json['location'],
      prefecture: json['prefecture'],
      rank: json['rank'],
      schoolStrength: json['schoolStrength'],
    );
  }

  /// CSV形式から復元
  factory School.fromCsvRow(Map<String, dynamic> row) {
    return School(
      id: int.parse(row['id'].toString()),
      name: row['name'].toString(),
      type: row['type'].toString(),
      location: row['location'].toString(),
      prefecture: row['prefecture'].toString(),
      rank: row['rank'].toString(),
      schoolStrength: int.parse(row['school_strength'].toString()),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is School && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'School(id: $id, name: $name, prefecture: $prefecture, rank: $rank)';
  }
}