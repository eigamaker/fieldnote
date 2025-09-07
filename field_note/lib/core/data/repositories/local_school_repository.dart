import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import '../../domain/entities/school.dart';
import '../../domain/repositories/school_repository.dart';

/// 学校データのローカルリポジトリ実装
class LocalSchoolRepository implements SchoolRepository {
  static const String _schoolsFileName = 'schools.json';
  static const String _csvFileName = 'School.csv';
  
  List<School>? _schools;

  @override
  Future<List<School>> getAllSchools() async {
    if (_schools != null) {
      return _schools!;
    }

    // まずJSONファイルから読み込みを試行
    final jsonFile = File(_schoolsFileName);
    if (await jsonFile.exists()) {
      try {
        final jsonString = await jsonFile.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        _schools = jsonList.map((json) => School.fromJson(json)).toList();
        return _schools!;
      } catch (e) {
        print('JSONファイルの読み込みに失敗: $e');
      }
    }

    // JSONファイルが存在しない場合はCSVから読み込んでJSONに保存
    await _loadFromCsvAndSaveToJson();
    return _schools!;
  }

  @override
  Future<School?> getSchoolById(int id) async {
    final schools = await getAllSchools();
    try {
      return schools.firstWhere((school) => school.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<School>> getSchoolsByPrefecture(String prefecture) async {
    final schools = await getAllSchools();
    return schools.where((school) => school.prefecture == prefecture).toList();
  }

  @override
  Future<List<School>> getSchoolsByRank(String rank) async {
    final schools = await getAllSchools();
    return schools.where((school) => school.rank == rank).toList();
  }

  @override
  Future<List<School>> getSchoolsByStrengthLevel(int strengthLevel) async {
    final schools = await getAllSchools();
    return schools.where((school) => school.strengthLevel == strengthLevel).toList();
  }

  @override
  Future<bool> saveSchool(School school) async {
    final schools = await getAllSchools();
    final index = schools.indexWhere((s) => s.id == school.id);
    
    if (index >= 0) {
      schools[index] = school;
    } else {
      schools.add(school);
    }
    
    _schools = schools;
    return await _saveToJson();
  }

  @override
  Future<bool> deleteSchool(int id) async {
    final schools = await getAllSchools();
    schools.removeWhere((school) => school.id == id);
    _schools = schools;
    return await _saveToJson();
  }

  @override
  Future<bool> initializeSchools() async {
    // CSVファイルから学校データを読み込んでJSONに保存
    await _loadFromCsvAndSaveToJson();
    return _schools != null && _schools!.isNotEmpty;
  }

  /// CSVファイルから学校データを読み込んでJSONに保存
  Future<void> _loadFromCsvAndSaveToJson() async {
    try {
      final csvFile = File(_csvFileName);
      if (!await csvFile.exists()) {
        throw Exception('CSVファイルが見つかりません: $_csvFileName');
      }

      final csvString = await csvFile.readAsString();
      final csvData = const CsvToListConverter().convert(csvString);
      
      if (csvData.isEmpty) {
        throw Exception('CSVファイルが空です');
      }

      // ヘッダー行を取得
      final headers = csvData[0].map((e) => e.toString()).toList();
      
      // データ行を処理
      final schools = <School>[];
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        if (row.length != headers.length) continue;
        
        final rowMap = <String, dynamic>{};
        for (int j = 0; j < headers.length; j++) {
          rowMap[headers[j]] = row[j];
        }
        
        try {
          final school = School.fromCsvRow(rowMap);
          schools.add(school);
        } catch (e) {
          print('行 ${i + 1} の解析に失敗: $e');
          continue;
        }
      }

      _schools = schools;
      await _saveToJson();
      
      print('学校データを初期化しました: ${schools.length}校');
    } catch (e) {
      print('CSVファイルの読み込みに失敗: $e');
      rethrow;
    }
  }

  /// 学校データをJSONファイルに保存
  Future<bool> _saveToJson() async {
    try {
      if (_schools == null) return false;
      
      final jsonList = _schools!.map((school) => school.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      final jsonFile = File(_schoolsFileName);
      await jsonFile.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print('JSONファイルの保存に失敗: $e');
      return false;
    }
  }

  /// 学校データをリセット（テスト用）
  Future<void> resetSchools() async {
    _schools = null;
    final jsonFile = File(_schoolsFileName);
    if (await jsonFile.exists()) {
      await jsonFile.delete();
    }
  }
}
