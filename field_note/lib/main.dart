import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'core/data/repositories/local_game_repository.dart';
import 'core/security/encryption_service.dart';
import 'core/security/access_control.dart';
import 'core/data/local/json_storage.dart';
import 'core/domain/repositories/game_repository.dart';
import 'core/domain/entities/game_state.dart';
import 'core/domain/entities/game_progress.dart';
import 'features/game_progression/managers/game_progress_manager.dart';
import 'features/game_progression/screens/main_menu_screen.dart';
import 'features/scouting/managers/scouting_manager.dart';
import 'features/schools/managers/school_manager.dart';
import 'features/schools/managers/school_initialization_manager.dart';
import 'core/domain/repositories/player_repository.dart';
import 'core/domain/repositories/school_repository.dart';
import 'core/domain/entities/player.dart';
import 'core/domain/entities/school.dart';
import 'core/data/database/database_manager.dart';
import 'features/players/managers/player_generation_manager.dart';
// TODO: 新しいシステムのインポート（実装完了後に有効化）
// import 'core/domain/repositories/scout_repository.dart';
// import 'core/domain/entities/scout_skills.dart';
// import 'core/domain/entities/experience_system.dart';
// import 'core/domain/entities/player_growth.dart';
// import 'features/scout_skills/managers/skill_manager.dart';
// import 'features/scout_skills/managers/experience_manager.dart';
// import 'features/player_growth/managers/growth_manager.dart';

void main() {
  runApp(const FieldNoteApp());
}

/// FIELD NOTE アプリケーション
class FieldNoteApp extends StatelessWidget {
  const FieldNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIELD NOTE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const FieldNoteHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// FIELD NOTE ホームページ
class FieldNoteHomePage extends StatefulWidget {
  const FieldNoteHomePage({super.key});

  @override
  State<FieldNoteHomePage> createState() => _FieldNoteHomePageState();
}

class _FieldNoteHomePageState extends State<FieldNoteHomePage> {
  late GameRepository _gameRepository;
  late GameProgressManager _gameProgressManager;
  late ScoutingManager _scoutingManager;
  late SchoolManager _schoolManager;
  late SchoolInitializationManager _schoolInitializationManager;
  // TODO: 新しいシステムのマネージャー（実装完了後に有効化）
  // late SkillManager _skillManager;
  // late ExperienceManager _experienceManager;
  // late GrowthManager _growthManager;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  /// ゲームを初期化
  Future<void> _initializeGame() async {
    try {
      // JSONストレージとリポジトリを初期化
      final encryption = EncryptionService();
      await _initEncryptionKey(encryption);
      final jsonStorage = JsonStorage(
        encryption: encryption,
        accessControl: AccessControl(currentRole: Role.system),
        backupKeep: 5,
      );
      _gameRepository = LocalGameRepository(jsonStorage);
      
      // ゲーム進行マネージャーを初期化
      _gameProgressManager = GameProgressManager(_gameRepository);
      
      // データベースを初期化
      await DatabaseManager.database;
      
      // 学校データの初期化
      _schoolInitializationManager = SchoolInitializationManager();
      await _schoolInitializationManager.initializeSchools();
      
      // ゲーム開始時の選手生成
      final schools = await _schoolInitializationManager.getAllSchools();
      if (schools.isNotEmpty) {
        await PlayerGenerationManager.generateGameStartPlayers(
          schools: schools,
          scoutSkill: 50.0, // デフォルトスカウトスキル
        );
      } else {
        print('学校データが読み込まれていないため、選手生成をスキップします');
      }
      
      // スカウト関連のマネージャーを初期化（実際のSchoolRepositoryを使用）
      _scoutingManager = ScoutingManager(_DummyPlayerRepository(), _schoolInitializationManager);
      _schoolManager = SchoolManager(_schoolInitializationManager);
      
      // 新しいシステムのマネージャーを初期化（一時的にダミー実装）
      // TODO: 実際のScoutRepositoryの実装を追加
      // _skillManager = SkillManager(_DummyScoutRepository());
      // _experienceManager = ExperienceManager(_DummyScoutRepository());
      // _growthManager = GrowthManager(_DummyScoutRepository());
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('ゲーム初期化エラー: $e');
      // エラーが発生しても基本的な機能は動作するようにする
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'FIELD NOTE を起動中...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MainMenuScreen(
      gameProgressManager: _gameProgressManager,
    );
  }

  @override
  void dispose() {
    _gameProgressManager.dispose();
    super.dispose();
  }
}

/// ダミーの選手リポジトリ実装
class _DummyPlayerRepository implements PlayerRepository {
  @override
  Future<bool> savePlayer(Player player) async => true;
  
  @override
  Future<Player?> loadPlayer(String playerId) async => null;
  
  @override
  Future<List<Player>> loadAllPlayers() async => [];
  
  @override
  Future<List<Player>> loadPlayersBySchool(String schoolId) async => [];
  
  @override
  Future<bool> deletePlayer(String playerId) async => true;
  
  @override
  Future<bool> hasPlayer(String playerId) async => false;
  
  @override
  Future<int> getPlayerCountBySchool(String schoolId) async => 0;
  
  @override
  Future<int> getTotalPlayerCount() async => 0;
}

/// ダミーの学校リポジトリ実装
class _DummySchoolRepository implements SchoolRepository {
  @override
  Future<bool> saveSchool(School school) async => true;
  
  @override
  Future<School?> loadSchool(String schoolId) async => null;
  
  @override
  Future<List<School>> loadAllSchools() async => [];
  
  @override
  Future<List<School>> loadSchoolsByPrefecture(String prefecture) async => [];
  
  @override
  Future<bool> deleteSchool(String schoolId) async => true;
  
  @override
  Future<bool> hasSchool(String schoolId) async => false;
  
  @override
  Future<int> getSchoolCount() async => 0;
  
  @override
  Future<int> getSchoolCountByPrefecture(String prefecture) async => 0;
  
  @override
  Future<bool> addPlayerToSchool(String schoolId, String playerId) async => true;
  
  @override
  Future<bool> removePlayerFromSchool(String schoolId, String playerId) async => true;

  @override
  Future<School?> getSchoolById(int id) async => null;

  @override
  Future<List<School>> getAllSchools() async => [];

  @override
  Future<List<School>> getSchoolsByRank(String rank) async => [];

  @override
  Future<List<School>> getSchoolsByStrengthLevel(int strengthLevel) async => [];

  @override
  Future<List<School>> getSchoolsByPrefecture(String prefecture) async => [];
}

/// ゲームリポジトリの実装
class _GameRepositoryImpl implements GameRepository {
  final JsonStorage _storage;

  _GameRepositoryImpl(this._storage);

  @override
  Future<bool> saveGameState(GameState gameState) async {
    return await _storage.saveGameState(gameState.toJson());
  }

  @override
  Future<GameState?> loadGameState() async {
    final data = await _storage.loadGameState();
    if (data != null) {
      return GameState.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> saveGameProgress(GameProgress gameProgress) async {
    return await _storage.saveGameProgress(gameProgress.toJson());
  }

  @override
  Future<GameProgress?> loadGameProgress() async {
    final data = await _storage.loadGameProgress();
    if (data != null) {
      return GameProgress.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> startNewGame() async {
    try {
      // 既存のデータを削除
      await _storage.clearAllData();
      
      // 初期状態を保存
      final gameState = GameState.initial().startGame();
      final gameProgress = GameProgress.initial();
      
      final stateSaved = await _storage.saveGameState(gameState.toJson());
      final progressSaved = await _storage.saveGameProgress(gameProgress.toJson());
      
      return stateSaved && progressSaved;
    } catch (e) {
      print('新規ゲーム開始エラー: $e');
      return false;
    }
  }

  @override
  Future<bool> saveGame(GameState gameState, GameProgress gameProgress) async {
    try {
      final stateSaved = await _storage.saveGameState(gameState.toJson());
      final progressSaved = await _storage.saveGameProgress(gameProgress.toJson());
      
      return stateSaved && progressSaved;
    } catch (e) {
      print('ゲーム保存エラー: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> loadGame() async {
    try {
      final gameState = await loadGameState();
      final gameProgress = await loadGameProgress();
      
      if (gameState != null || gameProgress != null) {
        return {
          'gameState': gameState?.toJson(),
          'gameProgress': gameProgress?.toJson(),
        };
      }
      return null;
    } catch (e) {
      print('ゲーム読み込みエラー: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteGame() async {
    return await _storage.clearAllData();
  }

  @override
  Future<bool> hasGameData() async {
    try {
      return await _storage.hasGameData();
    } catch (e) {
      print('ゲームデータ存在チェックエラー: $e');
      return false;
    }
  }
}

/// ローカルの暗号鍵を生成/読み込みする
Future<void> _initEncryptionKey(EncryptionService encryption) async {
  try {
    final Directory baseDir;
    if (Platform.isWindows) {
      baseDir = Directory('${Directory.current.path}/data');
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }
    final secretsDir = Directory('${baseDir.path}/secrets');
    if (!await secretsDir.exists()) {
      await secretsDir.create(recursive: true);
    }
    final keyFile = File('${secretsDir.path}/encryption.key');
    if (await keyFile.exists()) {
      final keyB64 = await keyFile.readAsString();
      await encryption.configureWithBase64Key(keyB64.trim());
    } else {
      final keyB64 = await encryption.configureWithRandomKey();
      await keyFile.writeAsString(keyB64);
    }
  } catch (_) {
    // Fallback: continue without encryption
  }
}
