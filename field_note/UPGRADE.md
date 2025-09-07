# FIELD NOTE: System Upgrades (Architecture, Data, Security, UX)

This document summarizes the long-term improvements integrated across phases.

## Architecture
- Repository extraction: `LocalGameRepository` in `lib/core/data/repositories/`.
- Strengthened storage service: unified `JsonStorage` with encryption/backup/audit/ACL.
- Save coalescing: merges rapid saves to reduce I/O overhead.

## Data Management
- Backups: automatic backup on save/delete to `data/backups/` (keep latest 5).
- Migration framework: per-file schema versions in `data/schema_versions.json`.
- Tooling: `dart run tool/data_migration.dart` to apply migrations.

## Security
- Encryption-at-rest: AES‑GCM via `cryptography` package.
- Key handling: a local base64 key stored in `data/secrets/encryption.key` (development setup).
  - For production, switch to user passphrase + secure storage.
- Access control: role-based read/write/delete guards (system/admin/user/guest).
- Audit logging: JSON lines at `data/logs/audit.log` for saves, loads, deletes, backups.

## Usability
- No UI breakage. Storage and repository are drop-in compatible.
- Future-ready: add a settings screen to manage encryption/backup later.

## How to Use
1. Run the app; an encryption key is auto-generated on first launch.
2. Game saves are encrypted and backed up automatically.
3. To rotate key: delete `data/secrets/encryption.key` (existing data becomes unreadable).
4. To migrate data schema: `dart run tool/data_migration.dart`.

## Notes
- This setup is safe-by-default for local development. For production:
  - Store keys in platform secure storage (e.g., Keychain/Keystore).
  - Offer a passphrase flow and key rotation policy.
  - Expand ACL integration beyond storage into feature modules if needed.

