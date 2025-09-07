import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../security/encryption_service.dart';
import '../../security/audit_logger.dart';
import '../../security/access_control.dart';

/// JSON file storage with optional encryption, backups, ACL, and audit logs.
class JsonStorage {
  static const String _gameStateFileName = 'game_state.json';
  static const String _gameProgressFileName = 'game_progress.json';
  static const String _schemaFileName = 'schema_versions.json';

  final EncryptionService? _encryption;
  AuditLogger? _audit;
  final AccessControl _acl;
  final int backupKeep; // number of backups to keep per file

  JsonStorage({
    EncryptionService? encryption,
    AccessControl? accessControl,
    this.backupKeep = 5,
  })  : _encryption = encryption,
        _acl = accessControl ?? AccessControl();

  /// Application documents directory (Windows: project/data for dev convenience).
  Future<Directory> get _documentsDirectory async {
    if (Platform.isWindows) {
      return Directory('${Directory.current.path}/data');
    }
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  /// Resolves a file path inside the documents directory.
  Future<String> _getFilePath(String fileName) async {
    final directory = await _documentsDirectory;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return '${directory.path}/$fileName';
  }

  /// Saves a JSON object to the given file name (optionally encrypted).
  Future<bool> saveData(String fileName, Map<String, dynamic> data) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (!_acl.canWrite(_resourceFor(fileName))) {
        throw const FileSystemException('Access denied (write)');
      }

      await _createBackupIfExists(file);

      final toStore = _encryption == null ? data : await _encryption!.encrypt(data);
      final jsonString = jsonEncode(toStore);
      await file.writeAsString(jsonString);

      await _ensureAudit();
      await _audit!.log(action: 'save', resource: fileName, result: 'ok');
      return true;
    } catch (e) {
      print('データ保存エラー: $e');
      try {
        await _ensureAudit();
        await _audit!.log(
          action: 'save',
          resource: fileName,
          result: 'error',
          details: {'error': e.toString()},
        );
      } catch (_) {}
      return false;
    }
  }

  /// Loads a JSON object from the given file name, decrypting if needed.
  Future<Map<String, dynamic>?> loadData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (!_acl.canRead(_resourceFor(fileName))) {
        throw const FileSystemException('Access denied (read)');
      }

      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final decoded = jsonDecode(jsonString);
      final result = _encryption == null
          ? decoded as Map<String, dynamic>
          : await _encryption!.decryptIfNeeded(decoded);

      await _ensureAudit();
      await _audit!.log(action: 'load', resource: fileName, result: 'ok');
      return result;
    } catch (e) {
      print('データ読み込みエラー: $e');
      try {
        await _ensureAudit();
        await _audit!.log(
          action: 'load',
          resource: fileName,
          result: 'error',
          details: {'error': e.toString()},
        );
      } catch (_) {}
      return null;
    }
  }

  /// Deletes the target file (with a backup before deletion).
  Future<bool> deleteData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (!_acl.canDelete(_resourceFor(fileName))) {
        throw const FileSystemException('Access denied (delete)');
      }

      if (await file.exists()) {
        await _createBackupIfExists(file);
        await file.delete();
      }

      await _ensureAudit();
      await _audit!.log(action: 'delete', resource: fileName, result: 'ok');
      return true;
    } catch (e) {
      print('データ削除エラー: $e');
      try {
        await _ensureAudit();
        await _audit!.log(
          action: 'delete',
          resource: fileName,
          result: 'error',
          details: {'error': e.toString()},
        );
      } catch (_) {}
      return false;
    }
  }

  /// Game state helpers
  Future<bool> saveGameState(Map<String, dynamic> gameState) async {
    return await saveData(_gameStateFileName, gameState);
  }

  Future<Map<String, dynamic>?> loadGameState() async {
    return await loadData(_gameStateFileName);
  }

  /// Game progress helpers
  Future<bool> saveGameProgress(Map<String, dynamic> gameProgress) async {
    return await saveData(_gameProgressFileName, gameProgress);
  }

  Future<Map<String, dynamic>?> loadGameProgress() async {
    return await loadData(_gameProgressFileName);
  }

  /// Removes all stored game data.
  Future<bool> clearAllData() async {
    try {
      await deleteData(_gameStateFileName);
      await deleteData(_gameProgressFileName);
      return true;
    } catch (e) {
      print('全データ削除エラー: $e');
      return false;
    }
  }

  Future<bool> hasData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);
      return await file.exists();
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasGameData() async {
    final hasState = await hasData(_gameStateFileName);
    final hasProgress = await hasData(_gameProgressFileName);
    return hasState || hasProgress;
  }

  // --- Backup + audit helpers ---
  Future<void> _createBackupIfExists(File file) async {
    if (!await file.exists()) return;
    final dir = file.parent;
    final backupsDir = Directory('${dir.path}/backups');
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }
    final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
    final base = file.uri.pathSegments.last;
    final backupPath = '${backupsDir.path}/$base.$ts.bak';
    await file.copy(backupPath);
    await _enforceBackupRetention(backupsDir, base);
    await _ensureAudit();
    await _audit!.log(
      action: 'backup',
      resource: base,
      result: 'ok',
      details: {'path': backupPath},
    );
  }

  Future<void> _enforceBackupRetention(Directory backupsDir, String baseName) async {
    try {
      final list = backupsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('$baseName.'))
          .toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      if (list.length > backupKeep) {
        for (var i = backupKeep; i < list.length; i++) {
          try {
            await list[i].delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  Resource _resourceFor(String fileName) {
    switch (fileName) {
      case _gameStateFileName:
        return Resource.gameState;
      case _gameProgressFileName:
        return Resource.gameProgress;
      default:
        return Resource.logs;
    }
  }

  Future<void> _ensureAudit() async {
    if (_audit != null) return;
    final dir = await _documentsDirectory;
    _audit = AuditLogger(dir);
  }
}

