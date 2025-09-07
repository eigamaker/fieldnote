import 'dart:io';
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import '../database/database_manager.dart';
import '../database/school_table.dart';
import '../../domain/entities/school.dart';

/// 学校データをCSVからデータベースに読み込むサービス
class SchoolDataLoader {
  static const String _csvFileName = 'School.csv';

  /// CSVファイルから学校データを読み込んでデータベースに挿入
  static Future<bool> loadSchoolsFromCsv() async {
    try {
      print('学校データの読み込みを開始...');
      
      // データベースを取得
      final db = await DatabaseManager.database;
      
      // 既存のデータをクリア
      await db.execute(SchoolTable.clearTableSql);
      print('既存の学校データをクリアしました');
      
      // CSVファイルを読み込み（assetsから）
      final csvString = await rootBundle.loadString('assets/$_csvFileName');
      final csvData = const CsvToListConverter().convert(csvString);
      
      if (csvData.isEmpty) {
        throw Exception('CSVファイルが空です');
      }

      // ヘッダー行を取得
      final headers = csvData[0].map((e) => e.toString()).toList();
      print('CSVヘッダー: $headers');
      
      // バッチ挿入用のデータを準備
      final now = DateTime.now().toIso8601String();
      final batch = db.batch();
      int insertedCount = 0;
      
      // データ行を処理
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        if (row.length != headers.length) {
          print('行 ${i + 1} の列数が不正です: ${row.length} != ${headers.length}');
          continue;
        }
        
        try {
          // 行データをマップに変換
          final rowMap = <String, dynamic>{};
          for (int j = 0; j < headers.length; j++) {
            rowMap[headers[j]] = row[j];
          }
          
          // 学校オブジェクトを作成
          final school = School.fromCsvRow(rowMap);
          
          // バッチに追加
          batch.insert(
            SchoolTable.tableName,
            {
              'id': school.id,
              'name': school.name,
              'type': school.type,
              'location': school.location,
              'prefecture': school.prefecture,
              'rank': school.rank,
              'school_strength': school.schoolStrength,
              'created_at': now,
              'updated_at': now,
            },
          );
          
          insertedCount++;
          
          // 1000件ごとにバッチを実行
          if (insertedCount % 1000 == 0) {
            await batch.commit();
            print('$insertedCount 件の学校データを挿入しました');
          }
        } catch (e) {
          print('行 ${i + 1} の解析に失敗: $e');
          continue;
        }
      }
      
      // 残りのバッチを実行
      if (insertedCount % 1000 != 0) {
        await batch.commit();
      }
      
      print('学校データの読み込みが完了しました: $insertedCount 校');
      
      // 統計情報を表示
      await _printSchoolStatistics(db);
      
      return true;
    } catch (e) {
      print('学校データの読み込みに失敗しました: $e');
      return false;
    }
  }

  /// 学校データの統計情報を表示
  static Future<void> _printSchoolStatistics(Database db) async {
    try {
      // 総学校数
      final totalCount = Sqflite.firstIntValue(
        await db.rawQuery(SchoolTable.countSql)
      ) ?? 0;
      
      // 都道府県別の学校数
      final prefectureCounts = await db.rawQuery(SchoolTable.countByPrefectureSql);
      
      // ランク別の学校数
      final rankCounts = await db.rawQuery(SchoolTable.countByRankSql);
      
      print('\n=== 学校データ統計 ===');
      print('総学校数: $totalCount 校');
      print('都道府県数: ${prefectureCounts.length} 都道府県');
      
      print('\n=== ランク別分布 ===');
      for (final row in rankCounts) {
        print('${row['rank']}: ${row['count']} 校');
      }
      
      print('\n=== 都道府県別分布（上位10都道府県） ===');
      for (int i = 0; i < 10 && i < prefectureCounts.length; i++) {
        final row = prefectureCounts[i];
        print('${row['prefecture']}: ${row['count']} 校');
      }
      
    } catch (e) {
      print('統計情報の表示中にエラーが発生しました: $e');
    }
  }

  /// 学校データが既に読み込まれているかチェック
  static Future<bool> isSchoolsLoaded() async {
    try {
      final db = await DatabaseManager.database;
      final count = Sqflite.firstIntValue(
        await db.rawQuery(SchoolTable.countSql)
      ) ?? 0;
      return count > 0;
    } catch (e) {
      print('学校データの存在チェックに失敗しました: $e');
      return false;
    }
  }

  /// 学校データをリセット
  static Future<void> resetSchools() async {
    try {
      final db = await DatabaseManager.database;
      await db.execute(SchoolTable.clearTableSql);
      print('学校データをリセットしました');
    } catch (e) {
      print('学校データのリセットに失敗しました: $e');
      rethrow;
    }
  }
}
