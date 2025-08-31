enum NetworkConnectionType {
  colleague('同僚'),
  mentor('師匠'),
  student('弟子'),
  competitor('競合'),
  acquaintance('知人'),
  friend('友人');

  const NetworkConnectionType(this.label);
  final String label;
}

enum NetworkTrustLevel {
  low('低'),
  medium('中'),
  high('高'),
  veryHigh('非常に高い');

  const NetworkTrustLevel(this.label);
  final String label;
}

class ScoutNetwork {
  final String id;
  final String scoutId;
  final String scoutName;
  final List<NetworkConnection> connections;
  final Map<String, dynamic> networkStats;
  final DateTime lastUpdated;

  const ScoutNetwork({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    this.connections = const [],
    this.networkStats = const {},
    required this.lastUpdated,
  });

  factory ScoutNetwork.initial({
    required String scoutId,
    required String scoutName,
  }) {
    return ScoutNetwork(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      lastUpdated: DateTime.now(),
    );
  }

  ScoutNetwork copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    List<NetworkConnection>? connections,
    Map<String, dynamic>? networkStats,
    DateTime? lastUpdated,
  }) {
    return ScoutNetwork(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      connections: connections ?? this.connections,
      networkStats: networkStats ?? this.networkStats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // 接続の追加
  ScoutNetwork addConnection(NetworkConnection connection) {
    final updatedConnections = List<NetworkConnection>.from(connections);
    updatedConnections.add(connection);
    
    return copyWith(
      connections: updatedConnections,
      lastUpdated: DateTime.now(),
    );
  }

  // 接続の更新
  ScoutNetwork updateConnection(String connectionId, NetworkConnection updatedConnection) {
    final updatedConnections = connections.map((conn) {
      if (conn.id == connectionId) {
        return updatedConnection;
      }
      return conn;
    }).toList();
    
    return copyWith(
      connections: updatedConnections,
      lastUpdated: DateTime.now(),
    );
  }

  // 接続の削除
  ScoutNetwork removeConnection(String connectionId) {
    final updatedConnections = connections.where((conn) => conn.id != connectionId).toList();
    
    return copyWith(
      connections: updatedConnections,
      lastUpdated: DateTime.now(),
    );
  }

  // ネットワーク統計の更新
  ScoutNetwork updateNetworkStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(networkStats);
    updatedStats.addAll(newStats);
    
    return copyWith(
      networkStats: updatedStats,
      lastUpdated: DateTime.now(),
    );
  }

  // 信頼できる接続の取得
  List<NetworkConnection> get trustedConnections {
    return connections.where((conn) => 
      conn.trustLevel == NetworkTrustLevel.high || 
      conn.trustLevel == NetworkTrustLevel.veryHigh
    ).toList();
  }

  // 特定のタイプの接続の取得
  List<NetworkConnection> getConnectionsByType(NetworkConnectionType type) {
    return connections.where((conn) => conn.connectionType == type).toList();
  }

  // ネットワークの強度計算
  double get networkStrength {
    if (connections.isEmpty) return 0.0;
    
    double totalStrength = 0.0;
    for (final connection in connections) {
      totalStrength += connection.trustLevel.index + 1;
    }
    
    return totalStrength / connections.length;
  }

  // アクティブな接続数
  int get activeConnectionCount {
    return connections.where((conn) => conn.isActive).length;
  }

  // ネットワークの多様性
  double get networkDiversity {
    final types = connections.map((conn) => conn.connectionType).toSet();
    return types.length / NetworkConnectionType.values.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'connections': connections.map((conn) => conn.toJson()).toList(),
      'networkStats': networkStats,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ScoutNetwork.fromJson(Map<String, dynamic> json) {
    return ScoutNetwork(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      connections: (json['connections'] as List<dynamic>?)
          ?.map((conn) => NetworkConnection.fromJson(conn as Map<String, dynamic>))
          .toList() ?? [],
      networkStats: Map<String, dynamic>.from(json['networkStats'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoutNetwork && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScoutNetwork(id: $id, scoutName: $scoutName, connections: ${connections.length})';
  }
}

class NetworkConnection {
  final String id;
  final String connectedScoutId;
  final String connectedScoutName;
  final NetworkConnectionType connectionType;
  final NetworkTrustLevel trustLevel;
  final DateTime establishedDate;
  final DateTime lastContactDate;
  final bool isActive;
  final Map<String, dynamic> relationshipData;
  final List<String> sharedInterests;
  final String notes;

  const NetworkConnection({
    required this.id,
    required this.connectedScoutId,
    required this.connectedScoutName,
    required this.connectionType,
    required this.trustLevel,
    required this.establishedDate,
    required this.lastContactDate,
    this.isActive = true,
    this.relationshipData = const {},
    this.sharedInterests = const [],
    this.notes = '',
  });

  factory NetworkConnection.initial({
    required String connectedScoutId,
    required String connectedScoutName,
    required NetworkConnectionType connectionType,
    NetworkTrustLevel trustLevel = NetworkTrustLevel.medium,
  }) {
    return NetworkConnection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      connectedScoutId: connectedScoutId,
      connectedScoutName: connectedScoutName,
      connectionType: connectionType,
      trustLevel: trustLevel,
      establishedDate: DateTime.now(),
      lastContactDate: DateTime.now(),
    );
  }

  NetworkConnection copyWith({
    String? id,
    String? connectedScoutId,
    String? connectedScoutName,
    NetworkConnectionType? connectionType,
    NetworkTrustLevel? trustLevel,
    DateTime? establishedDate,
    DateTime? lastContactDate,
    bool? isActive,
    Map<String, dynamic>? relationshipData,
    List<String>? sharedInterests,
    String? notes,
  }) {
    return NetworkConnection(
      id: id ?? this.id,
      connectedScoutId: connectedScoutId ?? this.connectedScoutId,
      connectedScoutName: connectedScoutName ?? this.connectedScoutName,
      connectionType: connectionType ?? this.connectionType,
      trustLevel: trustLevel ?? this.trustLevel,
      establishedDate: establishedDate ?? this.establishedDate,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      isActive: isActive ?? this.isActive,
      relationshipData: relationshipData ?? this.relationshipData,
      sharedInterests: sharedInterests ?? this.sharedInterests,
      notes: notes ?? this.notes,
    );
  }

  // 接続の更新
  NetworkConnection updateLastContact() {
    return copyWith(
      lastContactDate: DateTime.now(),
    );
  }

  // 信頼レベルの更新
  NetworkConnection updateTrustLevel(NetworkTrustLevel newLevel) {
    return copyWith(
      trustLevel: newLevel,
      lastContactDate: DateTime.now(),
    );
  }

  // 関係データの更新
  NetworkConnection updateRelationshipData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(relationshipData);
    updatedData.addAll(newData);
    
    return copyWith(
      relationshipData: updatedData,
      lastContactDate: DateTime.now(),
    );
  }

  // 共有関心の追加
  NetworkConnection addSharedInterest(String interest) {
    final updatedInterests = List<String>.from(sharedInterests);
    if (!updatedInterests.contains(interest)) {
      updatedInterests.add(interest);
    }
    
    return copyWith(
      sharedInterests: updatedInterests,
      lastContactDate: DateTime.now(),
    );
  }

  // 接続の強度計算
  double get connectionStrength {
    double baseStrength = trustLevel.index + 1;
    final daysSinceContact = DateTime.now().difference(lastContactDate).inDays;
    
    // 最後の連絡から日数が経つと強度が減少
    if (daysSinceContact > 30) {
      baseStrength *= 0.8;
    } else if (daysSinceContact > 7) {
      baseStrength *= 0.9;
    }
    
    return baseStrength;
  }

  // 接続の有効性判定
  bool get isConnectionValid {
    final daysSinceContact = DateTime.now().difference(lastContactDate).inDays;
    return isActive && daysSinceContact <= 90; // 90日以内に連絡がないと無効
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'connectedScoutId': connectedScoutId,
      'connectedScoutName': connectedScoutName,
      'connectionType': connectionType.name,
      'trustLevel': trustLevel.name,
      'establishedDate': establishedDate.toIso8601String(),
      'lastContactDate': lastContactDate.toIso8601String(),
      'isActive': isActive,
      'relationshipData': relationshipData,
      'sharedInterests': sharedInterests,
      'notes': notes,
    };
  }

  factory NetworkConnection.fromJson(Map<String, dynamic> json) {
    return NetworkConnection(
      id: json['id'] as String,
      connectedScoutId: json['connectedScoutId'] as String,
      connectedScoutName: json['connectedScoutName'] as String,
      connectionType: NetworkConnectionType.values.firstWhere(
        (e) => e.name == json['connectionType'],
        orElse: () => NetworkConnectionType.acquaintance,
      ),
      trustLevel: NetworkTrustLevel.values.firstWhere(
        (e) => e.name == json['trustLevel'],
        orElse: () => NetworkTrustLevel.medium,
      ),
      establishedDate: DateTime.parse(json['establishedDate'] as String),
      lastContactDate: DateTime.parse(json['lastContactDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      relationshipData: Map<String, dynamic>.from(json['relationshipData'] ?? {}),
      sharedInterests: List<String>.from(json['sharedInterests'] ?? []),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NetworkConnection && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NetworkConnection(id: $id, connectedScoutName: $connectedScoutName, type: ${connectionType.label})';
  }
}
