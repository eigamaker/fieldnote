import 'player_abilities.dart';

/// 選手を管理するエンティティクラス
class Player {
  final String id;
  final String name;
  final int age;
  final int grade;
  final String position;
  final PlayerAbilities abilities;
  final String schoolId;
  final DateTime discoveredDate;
  final double scoutSkillUsed;

  const Player({
    required this.id,
    required this.name,
    required this.age,
    required this.grade,
    required this.position,
    required this.abilities,
    required this.schoolId,
    required this.discoveredDate,
    required this.scoutSkillUsed,
  });

  /// 選手の総合評価を取得
  String get overallRating => abilities.overallRating;

  /// 選手の平均能力値を取得
  double get averageAbility => abilities.averageAbility;

  /// 選手の総合能力値を取得
  int get totalAbility => abilities.totalAbility;

  /// 選手の打者としての評価を取得
  int get battingRating => abilities.battingAbility;

  /// 選手の投手としての評価を取得
  int get pitchingRating => abilities.pitchingAbility;

  /// 選手の守備者としての評価を取得
  int get fieldingRating => abilities.fieldingAbility;

  /// 選手の年齢に基づく学年を取得
  String get gradeText {
    switch (grade) {
      case 1:
        return '1年生';
      case 2:
        return '2年生';
      case 3:
        return '3年生';
      default:
        return '${grade}年生';
    }
  }

  /// 選手のポジション表示名を取得
  String get positionDisplayName {
    switch (position) {
      case 'P':
        return '投手';
      case 'C':
        return '捕手';
      case '1B':
        return '一塁手';
      case '2B':
        return '二塁手';
      case '3B':
        return '三塁手';
      case 'SS':
        return '遊撃手';
      case 'LF':
        return '左翼手';
      case 'CF':
        return '中堅手';
      case 'RF':
        return '右翼手';
      default:
        return position;
    }
  }

  /// 選手の詳細情報を取得
  String get detailedInfo {
    return '''
名前: $name
年齢: ${age}歳 ($gradeText)
ポジション: $positionDisplayName
総合評価: $overallRating
平均能力: ${averageAbility.toStringAsFixed(1)}
打撃評価: $battingRating
投球評価: $pitchingRating
守備評価: $fieldingRating
発見日: ${discoveredDate.toString().substring(0, 10)}
使用スカウトスキル: ${scoutSkillUsed.toStringAsFixed(1)}
''';
  }

  /// プロパティを更新したコピーを作成
  Player copyWith({
    String? id,
    String? name,
    int? age,
    int? grade,
    String? position,
    PlayerAbilities? abilities,
    String? schoolId,
    DateTime? discoveredDate,
    double? scoutSkillUsed,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      position: position ?? this.position,
      abilities: abilities ?? this.abilities,
      schoolId: schoolId ?? this.schoolId,
      discoveredDate: discoveredDate ?? this.discoveredDate,
      scoutSkillUsed: scoutSkillUsed ?? this.scoutSkillUsed,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'grade': grade,
      'position': position,
      'abilities': abilities.toJson(),
      'schoolId': schoolId,
      'discoveredDate': discoveredDate.toIso8601String(),
      'scoutSkillUsed': scoutSkillUsed,
    };
  }

  /// JSON形式から復元
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      grade: json['grade'],
      position: json['position'],
      abilities: PlayerAbilities.fromJson(json['abilities']),
      schoolId: json['schoolId'],
      discoveredDate: DateTime.parse(json['discoveredDate']),
      scoutSkillUsed: json['scoutSkillUsed']?.toDouble() ?? 0.0,
    );
  }

  /// 新しい選手を生成
  factory Player.generate({
    required String schoolId,
    required double scoutSkill,
    required String position,
  }) {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // 年齢と学年を適切に設定（15-18歳、1-3年生）
    final age = 15 + (random % 4);
    final grade = 1 + (random % 3);
    
    // 名前を生成
    final names = [
      '田中', '佐藤', '鈴木', '高橋', '渡辺', '伊藤', '山本', '中村', '小林', '加藤',
      '吉田', '山田', '佐々木', '山口', '松本', '井上', '木村', '林', '斎藤', '清水',
      '山崎', '森', '池田', '橋本', '阿部', '石川', '山下', '中島', '石井', '小川',
      '前田', '岡田', '長谷川', '藤田', '近藤', '坂本', '福田', '松井', '渡部', '青木',
      '西村', '岡本', '中川', '中野', '原田', '小野', '田村', '竹内', '金子', '和田'
    ];
    final firstNames = [
      '翔太', '健太', '大輔', '誠', '直樹', '浩二', '健一', '正人', '博', '明',
      '達也', '智也', '裕也', '剛', '勇', '進', '学', '悟', '聡', '優',
      '和也', '健二', '正義', '正雄', '正一', '正二', '正三', '正四', '正五', '正六'
    ];
    
    final lastName = names[random % names.length];
    final firstName = firstNames[random % firstNames.length];
    final name = '$lastName $firstName';
    
    // 能力値を生成（スカウトスキルに依存）
    final abilities = PlayerAbilities.generateHighQuality(scoutSkill);
    
    return Player(
      id: 'player_${now.millisecondsSinceEpoch}_${random % 10000}',
      name: name,
      age: age,
      grade: grade,
      position: position,
      abilities: abilities,
      schoolId: schoolId,
      discoveredDate: now,
      scoutSkillUsed: scoutSkill,
    );
  }
}
