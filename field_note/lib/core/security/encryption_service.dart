import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Simple pluggable encryption service.
///
/// Default is disabled (passthrough). Call [configureWithRandomKey] or
/// [configureWithPassphrase] to enable AES-GCM encryption.
class EncryptionService {
  SecretKey? _key;
  final AesGcm _alg = AesGcm.with256bits();

  bool get isEnabled => _key != null;

  /// Enables encryption with a securely generated random key.
  /// Returns a base64-encoded key which should be stored securely by the app.
  Future<String> configureWithRandomKey() async {
    final randomBytes = _randomBytes(32);
    _key = SecretKey(randomBytes);
    return base64Encode(randomBytes);
  }

  /// Enables encryption with a base64-encoded key (as returned by
  /// [configureWithRandomKey]).
  Future<void> configureWithBase64Key(String base64Key) async {
    final keyBytes = base64Decode(base64Key);
    if (keyBytes.length != 32) {
      throw ArgumentError('Invalid key length: ' + keyBytes.length.toString());
    }
    _key = SecretKey(keyBytes);
  }

  /// Derives a key from a passphrase + salt using PBKDF2-HMAC-SHA256.
  /// Returns the salt used (base64) so it can be stored and reused.
  Future<String> configureWithPassphrase(String passphrase, {String? base64Salt}) async {
    final salt = base64Salt != null ? base64Decode(base64Salt) : _randomBytes(16);
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 150000,
      bits: 256,
    );
    final newKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
    _key = newKey;
    return base64Encode(salt);
  }

  /// Encrypts [plainText] and returns a map that can be JSON-encoded and stored.
  /// The returned map contains algorithm name, nonce, ciphertext and mac.
  Future<Map<String, dynamic>> encrypt(Map<String, dynamic> plainText) async {
    if (_key == null) {
      // Passthrough format for compatibility
      return {
        '_format': 'plain-v1',
        'data': plainText,
      };
    }

    final nonce = _randomBytes(12);
    final data = utf8.encode(jsonEncode(plainText));
    final secretBox = await _alg.encrypt(
      data,
      secretKey: _key!,
      nonce: nonce,
    );
    return {
      '_format': 'enc-v1',
      'alg': 'aes-gcm-256',
      'nonce': base64Encode(nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };
  }

  /// Decrypts data produced by [encrypt]. If data is a passthrough format or a
  /// raw object map, returns it unchanged.
  Future<Map<String, dynamic>> decryptIfNeeded(dynamic stored) async {
    if (stored is Map<String, dynamic>) {
      final format = stored['_format'];
      if (format == null) {
        // Raw legacy JSON map
        return stored;
      }
      if (format == 'plain-v1') {
        final data = stored['data'];
        if (data is Map<String, dynamic>) return data;
        throw const FormatException('Invalid plain-v1 data');
      }
      if (format == 'enc-v1') {
        if (_key == null) {
          throw StateError('Encryption key not configured');
        }
        final nonce = base64Decode(stored['nonce'] as String);
        final cipherText = base64Decode(stored['ciphertext'] as String);
        final macBytes = base64Decode(stored['mac'] as String);
        final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));
        final clearBytes = await _alg.decrypt(
          secretBox,
          secretKey: _key!,
        );
        final jsonString = utf8.decode(clearBytes);
        final decoded = jsonDecode(jsonString);
        if (decoded is Map<String, dynamic>) return decoded;
        throw const FormatException('Decrypted payload not a JSON object');
      }
    }
    throw const FormatException('Unsupported storage format');
  }

  Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = rnd.nextInt(256);
    }
    return bytes;
  }
}

