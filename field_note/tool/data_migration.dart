import 'dart:io';
import '../lib/core/data/migrations/migrator.dart' as local;

Future<void> main(List<String> args) async {
  // Determine base dir similar to JsonStorage
  Directory baseDir;
  if (Platform.isWindows) {
    baseDir = Directory('${Directory.current.path}/data');
  } else {
    baseDir = Directory('${Directory.current.path}/data');
  }
  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
  }

  final migrator = local.Migrator(baseDir);
  await migrator.migrate();
  // Print a simple completion message
  // ignore: avoid_print
  print('Migration completed for directory: ' + baseDir.path);
}
