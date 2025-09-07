import 'dart:convert';
import 'dart:io';

/// Simple schema migration helper for local JSON storage.
/// Tracks per-file schema versions in schema_versions.json and applies upgrades.
class Migrator {
  final Directory baseDir;
  static const String schemaFile = 'schema_versions.json';

  Migrator(this.baseDir);

  Future<Map<String, int>> loadVersions() async {
    final file = File('${baseDir.path}/$schemaFile');
    if (!await file.exists()) return {};
    try {
      final map = jsonDecode(await file.readAsString());
      return (map as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveVersions(Map<String, int> versions) async {
    final file = File('${baseDir.path}/$schemaFile');
    await file.writeAsString(jsonEncode(versions));
  }

  /// Applies migrations up to latest known versions.
  Future<void> migrate() async {
    final versions = await loadVersions();

    // Current versions
    const gameStateVersion = 1;
    const gameProgressVersion = 1;

    await _migrateFile('game_state.json', versions['game_state.json'] ?? 0, gameStateVersion);
    await _migrateFile('game_progress.json', versions['game_progress.json'] ?? 0, gameProgressVersion);

    versions['game_state.json'] = gameStateVersion;
    versions['game_progress.json'] = gameProgressVersion;
    await saveVersions(versions);
  }

  Future<void> _migrateFile(String fileName, int from, int to) async {
    if (from >= to) return;
    final file = File('${baseDir.path}/$fileName');
    if (!await file.exists()) return;
    final raw = await file.readAsString();
    dynamic data;
    try {
      data = jsonDecode(raw);
    } catch (_) {
      return;
    }

    // In this phase, there are no breaking changes. Placeholder for future.
    int v = from;
    while (v < to) {
      // Example of future migration step:
      // if (v == 0) { data = _upgradeFrom0(data); }
      v++;
    }
    await file.writeAsString(jsonEncode(data));
  }
}

