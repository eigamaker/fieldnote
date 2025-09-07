/// Minimal role-based access control (RBAC) for repository/data operations.
class AccessControl {
  final Role currentRole;

  AccessControl({this.currentRole = Role.system});

  bool canRead(Resource resource) {
    switch (currentRole) {
      case Role.admin:
      case Role.system:
        return true;
      case Role.user:
        return resource != Resource.secrets;
      case Role.guest:
        return resource == Resource.gameState || resource == Resource.gameProgress;
    }
  }

  bool canWrite(Resource resource) {
    switch (currentRole) {
      case Role.admin:
      case Role.system:
        return true;
      case Role.user:
        return resource == Resource.gameState || resource == Resource.gameProgress;
      case Role.guest:
        return false;
    }
  }

  bool canDelete(Resource resource) {
    switch (currentRole) {
      case Role.admin:
      case Role.system:
        return true;
      case Role.user:
        return resource == Resource.gameState || resource == Resource.gameProgress;
      case Role.guest:
        return false;
    }
  }
}

enum Role { system, admin, user, guest }

enum Resource { gameState, gameProgress, secrets, backups, logs }

