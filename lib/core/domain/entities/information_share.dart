enum InformationType {
  playerReport('選手レポート'),
  scoutingData('スカウトデータ'),
  teamAnalysis('チーム分析'),
  tournamentInfo('大会情報'),
  marketTrends('市場動向'),
  insiderInfo('内部情報');

  const InformationType(this.label);
  final String label;
}

enum InformationQuality {
  poor('低'),
  fair('普通'),
  good('良'),
  excellent('優秀'),
  exceptional('卓越');

  const InformationQuality(this.label);
  final String label;
}

enum SharePermission {
  private('非公開'),
  shared('共有'),
  exclusive('独占'),
  public('公開');

  const SharePermission(this.label);
  final String label;
}

class InformationShare {
  final String id;
  final String title;
  final String description;
  final InformationType type;
  final InformationQuality quality;
  final SharePermission permission;
  final String ownerScoutId;
  final String ownerScoutName;
  final List<String> sharedWithScoutIds;
  final List<String> sharedWithScoutNames;
  final DateTime creationDate;
  final DateTime lastUpdated;
  final DateTime? expirationDate;
  final Map<String, dynamic> contentData;
  final Map<String, dynamic> metadata;
  final int viewCount;
  final int shareCount;
  final double valueScore;
  final bool isActive;
  final String notes;

  const InformationShare({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.quality,
    required this.permission,
    required this.ownerScoutId,
    required this.ownerScoutName,
    this.sharedWithScoutIds = const [],
    this.sharedWithScoutNames = const [],
    required this.creationDate,
    required this.lastUpdated,
    this.expirationDate,
    this.contentData = const {},
    this.metadata = const {},
    this.viewCount = 0,
    this.shareCount = 0,
    this.valueScore = 0.0,
    this.isActive = true,
    this.notes = '',
  });

  factory InformationShare.initial({
    required String title,
    required String description,
    required InformationType type,
    required InformationQuality quality,
    required SharePermission permission,
    required String ownerScoutId,
    required String ownerScoutName,
  }) {
    return InformationShare(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      quality: quality,
      permission: permission,
      ownerScoutId: ownerScoutId,
      ownerScoutName: ownerScoutName,
      creationDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  InformationShare copyWith({
    String? id,
    String? title,
    String? description,
    InformationType? type,
    InformationQuality? quality,
    SharePermission? permission,
    String? ownerScoutId,
    String? ownerScoutName,
    List<String>? sharedWithScoutIds,
    List<String>? sharedWithScoutNames,
    DateTime? creationDate,
    DateTime? lastUpdated,
    DateTime? expirationDate,
    Map<String, dynamic>? contentData,
    Map<String, dynamic>? metadata,
    int? viewCount,
    int? shareCount,
    double? valueScore,
    bool? isActive,
    String? notes,
  }) {
    return InformationShare(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      quality: quality ?? this.quality,
      permission: permission ?? this.permission,
      ownerScoutId: ownerScoutId ?? this.ownerScoutId,
      ownerScoutName: ownerScoutName ?? this.ownerScoutName,
      sharedWithScoutIds: sharedWithScoutIds ?? this.sharedWithScoutIds,
      sharedWithScoutNames: sharedWithScoutNames ?? this.sharedWithScoutNames,
      creationDate: creationDate ?? this.creationDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      expirationDate: expirationDate ?? this.expirationDate,
      contentData: contentData ?? this.contentData,
      metadata: metadata ?? this.metadata,
      viewCount: viewCount ?? this.viewCount,
      shareCount: shareCount ?? this.shareCount,
      valueScore: valueScore ?? this.valueScore,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  // 共有の追加
  InformationShare addShare(String scoutId, String scoutName) {
    final updatedScoutIds = List<String>.from(sharedWithScoutIds);
    final updatedScoutNames = List<String>.from(sharedWithScoutNames);
    
    if (!updatedScoutIds.contains(scoutId)) {
      updatedScoutIds.add(scoutId);
      updatedScoutNames.add(scoutName);
    }
    
    return copyWith(
      sharedWithScoutIds: updatedScoutIds,
      sharedWithScoutNames: updatedScoutNames,
      shareCount: shareCount + 1,
      lastUpdated: DateTime.now(),
    );
  }

  // 共有の削除
  InformationShare removeShare(String scoutId) {
    final scoutIndex = sharedWithScoutIds.indexOf(scoutId);
    if (scoutIndex != -1) {
      final updatedScoutIds = List<String>.from(sharedWithScoutIds);
      final updatedScoutNames = List<String>.from(sharedWithScoutNames);
      
      updatedScoutIds.removeAt(scoutIndex);
      updatedScoutNames.removeAt(scoutIndex);
      
      return copyWith(
        sharedWithScoutIds: updatedScoutIds,
        sharedWithScoutNames: updatedScoutNames,
        shareCount: (shareCount - 1).clamp(0, shareCount),
        lastUpdated: DateTime.now(),
      );
    }
    return this;
  }

  // 閲覧回数の更新
  InformationShare incrementViewCount() {
    return copyWith(
      viewCount: viewCount + 1,
      lastUpdated: DateTime.now(),
    );
  }

  // コンテンツデータの更新
  InformationShare updateContentData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(contentData);
    updatedData.addAll(newData);
    
    return copyWith(
      contentData: updatedData,
      lastUpdated: DateTime.now(),
    );
  }

  // メタデータの更新
  InformationShare updateMetadata(Map<String, dynamic> newMetadata) {
    final updatedMetadata = Map<String, dynamic>.from(metadata);
    updatedMetadata.addAll(newMetadata);
    
    return copyWith(
      metadata: updatedMetadata,
      lastUpdated: DateTime.now(),
    );
  }

  // 価値スコアの更新
  InformationShare updateValueScore(double newScore) {
    return copyWith(
      valueScore: newScore.clamp(0.0, 100.0),
      lastUpdated: DateTime.now(),
    );
  }

  // 有効期限の設定
  InformationShare setExpirationDate(DateTime expirationDate) {
    return copyWith(
      expirationDate: expirationDate,
      lastUpdated: DateTime.now(),
    );
  }

  // 情報の有効性判定
  bool get isInformationValid {
    if (!isActive) return false;
    if (expirationDate != null && DateTime.now().isAfter(expirationDate!)) {
      return false;
    }
    return true;
  }

  // 共有可能かどうかの判定
  bool canShareWith(String scoutId) {
    if (!isInformationValid) return false;
    if (permission == SharePermission.private) return false;
    if (permission == SharePermission.exclusive && sharedWithScoutIds.isNotEmpty) return false;
    if (sharedWithScoutIds.contains(scoutId)) return false;
    return true;
  }

  // 情報の新鮮度計算
  double get freshnessScore {
    final daysSinceCreation = DateTime.now().difference(creationDate).inDays;
    if (daysSinceCreation <= 1) return 1.0;
    if (daysSinceCreation <= 7) return 0.8;
    if (daysSinceCreation <= 30) return 0.6;
    if (daysSinceCreation <= 90) return 0.4;
    return 0.2;
  }

  // 総合価値スコアの計算
  double get totalValueScore {
    final qualityMultiplier = (quality.index + 1) / InformationQuality.values.length;
    final freshnessMultiplier = freshnessScore;
    final shareMultiplier = 1.0 + (shareCount * 0.1);
    
    return valueScore * qualityMultiplier * freshnessMultiplier * shareMultiplier;
  }

  // 情報の分類
  String get informationCategory {
    switch (type) {
      case InformationType.playerReport:
        return '選手情報';
      case InformationType.scoutingData:
        return 'スカウト情報';
      case InformationType.teamAnalysis:
        return 'チーム情報';
      case InformationType.tournamentInfo:
        return '大会情報';
      case InformationType.marketTrends:
        return '市場情報';
      case InformationType.insiderInfo:
        return '内部情報';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'quality': quality.name,
      'permission': permission.name,
      'ownerScoutId': ownerScoutId,
      'ownerScoutName': ownerScoutName,
      'sharedWithScoutIds': sharedWithScoutIds,
      'sharedWithScoutNames': sharedWithScoutNames,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'contentData': contentData,
      'metadata': metadata,
      'viewCount': viewCount,
      'shareCount': shareCount,
      'valueScore': valueScore,
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory InformationShare.fromJson(Map<String, dynamic> json) {
    return InformationShare(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: InformationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => InformationType.playerReport,
      ),
      quality: InformationQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => InformationQuality.fair,
      ),
      permission: SharePermission.values.firstWhere(
        (e) => e.name == json['permission'],
        orElse: () => SharePermission.private,
      ),
      ownerScoutId: json['ownerScoutId'] as String,
      ownerScoutName: json['ownerScoutName'] as String,
      sharedWithScoutIds: List<String>.from(json['sharedWithScoutIds'] ?? []),
      sharedWithScoutNames: List<String>.from(json['sharedWithScoutNames'] ?? []),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      expirationDate: json['expirationDate'] != null 
          ? DateTime.parse(json['expirationDate'] as String) 
          : null,
      contentData: Map<String, dynamic>.from(json['contentData'] ?? {}),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      viewCount: json['viewCount'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? 0,
      valueScore: (json['valueScore'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InformationShare && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'InformationShare(id: $id, title: $title, type: ${type.label}, quality: ${quality.label})';
  }
}
