import 'dart:convert';
import 'dart:io';

/// Simple audit logger that writes JSON lines to logs/audit.log
class AuditLogger {
  final Directory _baseDir;

  AuditLogger(this._baseDir);

  Future<void> log({
    required String action,
    required String resource,
    String? subject,
    String? result,
    Map<String, dynamic>? details,
  }) async {
    try {
      final logsDir = Directory('${_baseDir.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      final file = File('${logsDir.path}/audit.log');
      final entry = {
        'ts': DateTime.now().toIso8601String(),
        'action': action,
        'resource': resource,
        if (subject != null) 'subject': subject,
        if (result != null) 'result': result,
        if (details != null) 'details': details,
      };
      await file.writeAsString(jsonEncode(entry) + '\n', mode: FileMode.append, flush: true);
    } catch (_) {
      // swallow logging errors
    }
  }
}

