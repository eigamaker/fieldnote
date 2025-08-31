/// 学校を管理するエンティティクラス
class School {
  final String id;
  final String name;
  final String prefecture;
  final String city;
  final int level; // 1-5 (1: 弱小校, 5: 強豪校)
  final String type; // 'public', 'private'
  final int studentCount;
  final List<String> playerIds; // 所属選手のIDリスト
  final DateTime establishedDate;

  const School({
    required this.id,
    required this.name,
    required this.prefecture,
    required this.city,
    required this.level,
    required this.type,
    required this.studentCount,
    required this.playerIds,
    required this.establishedDate,
  });

  /// 学校のレベル表示名を取得
  String get levelText {
    switch (level) {
      case 1:
        return '弱小校';
      case 2:
        return '一般校';
      case 3:
        return '中堅校';
      case 4:
        return '強豪校';
      case 5:
        return '名門校';
      default:
        return '不明';
    }
  }

  /// 学校の種類表示名を取得
  String get typeText {
    switch (type) {
      case 'public':
        return '公立';
      case 'private':
        return '私立';
      default:
        return type;
    }
  }

  /// 学校の所在地を取得
  String get location => '$prefecture$city';

  /// 所属選手数を取得
  int get playerCount => playerIds.length;

  /// 学校の詳細情報を取得
  String get detailedInfo {
    return '''
学校名: $name
所在地: $location
レベル: $levelText
種類: $typeText
生徒数: ${studentCount}人
野球部員数: ${playerCount}人
創立: ${establishedDate.year}年
''';
  }

  /// プロパティを更新したコピーを作成
  School copyWith({
    String? id,
    String? name,
    String? prefecture,
    String? city,
    int? level,
    String? type,
    int? studentCount,
    List<String>? playerIds,
    DateTime? establishedDate,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      prefecture: prefecture ?? this.prefecture,
      city: city ?? this.city,
      level: level ?? this.level,
      type: type ?? this.type,
      studentCount: studentCount ?? this.studentCount,
      playerIds: playerIds ?? this.playerIds,
      establishedDate: establishedDate ?? this.establishedDate,
    );
  }

  /// 選手を追加
  School addPlayer(String playerId) {
    if (!playerIds.contains(playerId)) {
      final newPlayerIds = List<String>.from(playerIds)..add(playerId);
      return copyWith(playerIds: newPlayerIds);
    }
    return this;
  }

  /// 選手を削除
  School removePlayer(String playerId) {
    if (playerIds.contains(playerId)) {
      final newPlayerIds = List<String>.from(playerIds)..remove(playerId);
      return copyWith(playerIds: newPlayerIds);
    }
    return this;
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prefecture': prefecture,
      'city': city,
      'level': level,
      'type': type,
      'studentCount': studentCount,
      'playerIds': playerIds,
      'establishedDate': establishedDate.toIso8601String(),
    };
  }

  /// JSON形式から復元
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      prefecture: json['prefecture'],
      city: json['city'],
      level: json['level'],
      type: json['type'],
      studentCount: json['studentCount'],
      playerIds: List<String>.from(json['playerIds'] ?? []),
      establishedDate: DateTime.parse(json['establishedDate']),
    );
  }

  /// 新しい学校を生成
  factory School.generate({
    required String prefecture,
    required String city,
    int? level,
  }) {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // 学校名を生成
    final schoolNames = [
      '第一高校', '第二高校', '第三高校', '第四高校', '第五高校',
      '東高校', '西高校', '南高校', '北高校', '中央高校',
      '桜高校', '梅高校', '松高校', '竹高校', '菊高校',
      '青空高校', '白雲高校', '緑高校', '紅高校', '紫高校',
      '朝日高校', '夕日高校', '星高校', '月高校', '太陽高校'
    ];
    
    final name = schoolNames[random % schoolNames.length];
    
    // レベルを設定（指定がない場合はランダム）
    final schoolLevel = level ?? (1 + (random % 5));
    
    // 生徒数を設定（レベルに応じて変動）
    final baseStudentCount = 800 + (schoolLevel * 100);
    final studentCount = baseStudentCount + (random % 200);
    
    // 学校の種類を設定（80%が公立、20%が私立）
    final schoolType = (random % 100) < 80 ? 'public' : 'private';
    
    // 創立年を設定（1950年以降）
    final establishedYear = 1950 + (random % 70);
    final establishedDate = DateTime(establishedYear);
    
    return School(
      id: 'school_${now.millisecondsSinceEpoch}_${random % 10000}',
      name: name,
      prefecture: prefecture,
      city: city,
      level: schoolLevel,
      type: schoolType,
      studentCount: studentCount,
      playerIds: [],
      establishedDate: establishedDate,
    );
  }
}
