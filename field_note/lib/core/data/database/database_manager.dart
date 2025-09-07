import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'school_table.dart';
import 'player_table.dart';

/// データベース管理クラス
class DatabaseManager {
  static Database? _database;
  static const String _databaseName = 'field_note.db';
  static const int _databaseVersion = 1;

  /// データベースインスタンスを取得
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// データベースを初期化
  static Future<Database> _initDatabase() async {
    try {
      // アプリケーションのドキュメントディレクトリを取得
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);

      // データベースを開く
      final database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      print('データベースを初期化しました: $path');
      return database;
    } catch (e) {
      print('データベースの初期化に失敗しました: $e');
      rethrow;
    }
  }

  /// データベース作成時のコールバック
  static Future<void> _onCreate(Database db, int version) async {
    try {
      // 学校テーブルを作成
      await db.execute(SchoolTable.createTableSql);
      await db.execute(SchoolTable.createIndexesSql);
      
      // 選手テーブルを作成
      await db.execute(PlayerTable.createPlayerTableSql);
      await db.execute(PlayerTable.createCurrentAbilitiesTableSql);
      await db.execute(PlayerTable.createPotentialAbilitiesTableSql);
      await db.execute(PlayerTable.createScoutedAbilitiesTableSql);
      await db.execute(PlayerTable.createIndexesSql);
      
      print('データベーステーブルを作成しました');
    } catch (e) {
      print('テーブル作成に失敗しました: $e');
      rethrow;
    }
  }

  /// データベースアップグレード時のコールバック
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 将来のバージョンアップグレード処理をここに追加
    print('データベースをアップグレードしました: $oldVersion -> $newVersion');
  }

  /// データベースを閉じる
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('データベースを閉じました');
    }
  }

  /// データベースをリセット（テスト用）
  static Future<void> reset() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // データベースファイルを削除
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);
      final file = File(path);
      
      if (await file.exists()) {
        await file.delete();
        print('データベースファイルを削除しました');
      }

      // 新しいデータベースを作成
      _database = await _initDatabase();
    } catch (e) {
      print('データベースのリセットに失敗しました: $e');
      rethrow;
    }
  }

  /// データベースの状態を確認
  static Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await database;
      
      // テーブル一覧を取得
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
      );
      
      // 学校テーブルの行数を取得
      final schoolCount = Sqflite.firstIntValue(
        await db.rawQuery(SchoolTable.countSql)
      ) ?? 0;
      
      // データベースファイルのサイズを取得
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);
      final file = File(path);
      final fileSize = await file.exists() ? await file.length() : 0;
      
      return {
        'databasePath': path,
        'databaseVersion': _databaseVersion,
        'tables': tables.map((table) => table['name']).toList(),
        'schoolCount': schoolCount,
        'fileSizeBytes': fileSize,
        'fileSizeKB': (fileSize / 1024).round(),
        'fileSizeMB': (fileSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      print('データベース情報の取得に失敗しました: $e');
      return {
        'error': e.toString(),
      };
    }
  }
}
