enum OfficeLevel {
  basic('基本'),
  standard('標準'),
  professional('プロフェッショナル'),
  premium('プレミアム'),
  luxury('ラグジュアリー');

  const OfficeLevel(this.label);
  final String label;
}

enum EquipmentType {
  computer('コンピューター'),
  furniture('家具'),
  communication('通信設備'),
  security('セキュリティ'),
  comfort('快適性設備'),
  other('その他');

  const EquipmentType(this.label);
  final String label;
}

enum StaffRole {
  assistant('アシスタント'),
  researcher('リサーチャー'),
  analyst('アナリスト'),
  coordinator('コーディネーター'),
  manager('マネージャー'),
  intern('インターン');

  const StaffRole(this.label);
  final String label;
}

class OfficeManagement {
  final String id;
  final String scoutId;
  final String scoutName;
  final OfficeLevel level;
  final String location;
  final double monthlyRent;
  final double utilities;
  final Map<EquipmentType, List<Map<String, dynamic>>> equipment;
  final List<Map<String, dynamic>> staff;
  final Map<String, dynamic> facilities;
  final Map<String, dynamic> performanceMetrics;
  final DateTime lastUpdated;
  final String notes;

  const OfficeManagement({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.level,
    required this.location,
    required this.monthlyRent,
    required this.utilities,
    required this.equipment,
    required this.staff,
    required this.facilities,
    this.performanceMetrics = const {},
    required this.lastUpdated,
    this.notes = '',
  });

  factory OfficeManagement.initial({
    required String scoutId,
    required String scoutName,
  }) {
    final initialEquipment = <EquipmentType, List<Map<String, dynamic>>>{};
    for (final type in EquipmentType.values) {
      initialEquipment[type] = [];
    }
    
    return OfficeManagement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      level: OfficeLevel.basic,
      location: '自宅オフィス',
      monthlyRent: 0.0,
      utilities: 5000.0,
      equipment: initialEquipment,
      staff: [],
      facilities: {
        'workspace': 10.0, // 平米
        'meetingRoom': false,
        'parking': false,
        'security': false,
        'accessibility': false,
      },
      lastUpdated: DateTime.now(),
    );
  }

  OfficeManagement copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    OfficeLevel? level,
    String? location,
    double? monthlyRent,
    double? utilities,
    Map<EquipmentType, List<Map<String, dynamic>>>? equipment,
    List<Map<String, dynamic>>? staff,
    Map<String, dynamic>? facilities,
    Map<String, dynamic>? performanceMetrics,
    DateTime? lastUpdated,
    String? notes,
  }) {
    return OfficeManagement(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      level: level ?? this.level,
      location: location ?? this.location,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      utilities: utilities ?? this.utilities,
      equipment: equipment ?? this.equipment,
      staff: staff ?? this.staff,
      facilities: facilities ?? this.facilities,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
    );
  }

  // オフィスレベルのアップグレード
  OfficeManagement upgradeOfficeLevel(OfficeLevel newLevel) {
    return copyWith(
      level: newLevel,
      lastUpdated: DateTime.now(),
    );
  }

  // 場所の変更
  OfficeManagement changeLocation(String newLocation, double newRent) {
    return copyWith(
      location: newLocation,
      monthlyRent: newRent,
      lastUpdated: DateTime.now(),
    );
  }

  // 設備の追加
  OfficeManagement addEquipment(EquipmentType type, Map<String, dynamic> equipmentData) {
    final updatedEquipment = Map<EquipmentType, List<Map<String, dynamic>>>.from(equipment);
    final currentList = List<Map<String, dynamic>>.from(updatedEquipment[type] ?? []);
    currentList.add(equipmentData);
    updatedEquipment[type] = currentList;
    
    return copyWith(
      equipment: updatedEquipment,
      lastUpdated: DateTime.now(),
    );
  }

  // 設備の更新
  OfficeManagement updateEquipment(EquipmentType type, String equipmentId, Map<String, dynamic> newData) {
    final updatedEquipment = Map<EquipmentType, List<Map<String, dynamic>>>.from(equipment);
    final currentList = updatedEquipment[type] ?? [];
    final updatedList = currentList.map((item) {
      if (item['id'] == equipmentId) {
        return Map<String, dynamic>.from(item)..addAll(newData);
      }
      return item;
    }).toList();
    updatedEquipment[type] = updatedList;
    
    return copyWith(
      equipment: updatedEquipment,
      lastUpdated: DateTime.now(),
    );
  }

  // 設備の削除
  OfficeManagement removeEquipment(EquipmentType type, String equipmentId) {
    final updatedEquipment = Map<EquipmentType, List<Map<String, dynamic>>>.from(equipment);
    final currentList = updatedEquipment[type] ?? [];
    final updatedList = currentList.where((item) => item['id'] != equipmentId).toList();
    updatedEquipment[type] = updatedList;
    
    return copyWith(
      equipment: updatedEquipment,
      lastUpdated: DateTime.now(),
    );
  }

  // スタッフの追加
  OfficeManagement addStaff(Map<String, dynamic> staffData) {
    final updatedStaff = List<Map<String, dynamic>>.from(staff);
    updatedStaff.add(staffData);
    
    return copyWith(
      staff: updatedStaff,
      lastUpdated: DateTime.now(),
    );
  }

  // スタッフの更新
  OfficeManagement updateStaff(String staffId, Map<String, dynamic> newData) {
    final updatedStaff = staff.map((member) {
      if (member['id'] == staffId) {
        return Map<String, dynamic>.from(member)..addAll(newData);
      }
      return member;
    }).toList();
    
    return copyWith(
      staff: updatedStaff,
      lastUpdated: DateTime.now(),
    );
  }

  // スタッフの削除
  OfficeManagement removeStaff(String staffId) {
    final updatedStaff = staff.where((member) => member['id'] != staffId).toList();
    
    return copyWith(
      staff: updatedStaff,
      lastUpdated: DateTime.now(),
    );
  }

  // 施設の更新
  OfficeManagement updateFacilities(Map<String, dynamic> newFacilities) {
    final updatedFacilities = Map<String, dynamic>.from(facilities);
    updatedFacilities.addAll(newFacilities);
    
    return copyWith(
      facilities: updatedFacilities,
      lastUpdated: DateTime.now(),
    );
  }

  // パフォーマンス指標の更新
  OfficeManagement updatePerformanceMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(performanceMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      performanceMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 月次固定費の計算
  double get monthlyFixedCosts {
    return monthlyRent + utilities;
  }

  // 設備投資額の計算
  double get totalEquipmentInvestment {
    double total = 0.0;
    for (final equipmentList in equipment.values) {
      for (final item in equipmentList) {
        total += (item['cost'] as num?)?.toDouble() ?? 0.0;
      }
    }
    return total;
  }

  // 人件費の計算
  double get monthlyPersonnelCosts {
    double total = 0.0;
    for (final member in staff) {
      total += (member['monthlySalary'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  // 総月次コストの計算
  double get totalMonthlyCosts {
    return monthlyFixedCosts + monthlyPersonnelCosts;
  }

  // オフィス効率性の計算
  double get officeEfficiency {
    double score = 0.0;
    
    // 設備の充実度 (40点)
    final totalEquipment = equipment.values.map((list) => list.length).reduce((a, b) => a + b);
    if (totalEquipment >= 10) score += 40;
    else if (totalEquipment >= 7) score += 30;
    else if (totalEquipment >= 5) score += 20;
    else if (totalEquipment >= 3) score += 10;
    
    // スタッフの充実度 (30点)
    if (staff.length >= 5) score += 30;
    else if (staff.length >= 3) score += 20;
    else if (staff.length >= 1) score += 10;
    
    // 施設の充実度 (20点)
    if (facilities['meetingRoom'] == true) score += 10;
    if (facilities['parking'] == true) score += 5;
    if (facilities['security'] == true) score += 5;
    
    // オフィスレベルのボーナス (10点)
    score += (level.index + 1) * 2;
    
    return score.clamp(0.0, 100.0);
  }

  // 生産性スコアの計算
  double get productivityScore {
    double score = 0.0;
    
    // スタッフの専門性
    final specializedStaff = staff.where((member) => 
      member['role'] == StaffRole.analyst.name || 
      member['role'] == StaffRole.researcher.name
    ).length;
    score += specializedStaff * 15;
    
    // 設備の最新性
    final recentEquipment = equipment.values.expand((list) => list).where((item) {
      final purchaseDate = DateTime.tryParse(item['purchaseDate'] ?? '');
      if (purchaseDate == null) return false;
      return DateTime.now().difference(purchaseDate).inDays < 365;
    }).length;
    score += recentEquipment * 5;
    
    // オフィスレベルの影響
    score += (level.index + 1) * 10;
    
    return score.clamp(0.0, 100.0);
  }

  // コスト効率性の計算
  double get costEfficiency {
    if (totalMonthlyCosts == 0) return 100.0;
    
    // 効率性スコアをコストで割って効率性を計算
    final efficiencyPerCost = officeEfficiency / totalMonthlyCosts;
    return (efficiencyPerCost * 1000).clamp(0.0, 100.0);
  }

  // 成長可能性の計算
  double get growthPotential {
    double score = 0.0;
    
    // 現在のオフィスレベル
    score += (level.index + 1) * 10;
    
    // 拡張可能なスペース
    final currentWorkspace = facilities['workspace'] as double? ?? 0.0;
    if (currentWorkspace < 20) score += 20; // 拡張の余地がある
    else if (currentWorkspace < 50) score += 10;
    
    // スタッフの成長可能性
    final juniorStaff = staff.where((member) => 
      member['role'] == StaffRole.intern.name || 
      member['role'] == StaffRole.assistant.name
    ).length;
    score += juniorStaff * 10;
    
    // 設備のアップグレード可能性
    final upgradableEquipment = equipment.values.expand((list) => list).where((item) =>
      (item['upgradable'] as bool?) ?? false
    ).length;
    score += upgradableEquipment * 5;
    
    return score.clamp(0.0, 100.0);
  }

  // オフィスの総合評価
  double get overallOfficeScore {
    return (officeEfficiency * 0.4 + 
            productivityScore * 0.3 + 
            costEfficiency * 0.2 + 
            growthPotential * 0.1).clamp(0.0, 100.0);
  }

  // 設備の状態チェック
  List<Map<String, dynamic>> get equipmentMaintenanceNeeded {
    final maintenanceList = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    for (final equipmentList in equipment.values) {
      for (final item in equipmentList) {
        final lastMaintenance = DateTime.tryParse(item['lastMaintenance'] ?? '');
        final maintenanceInterval = item['maintenanceInterval'] as int? ?? 365;
        
        if (lastMaintenance != null) {
          final daysSinceMaintenance = now.difference(lastMaintenance).inDays;
          if (daysSinceMaintenance > maintenanceInterval) {
            maintenanceList.add({
              'equipment': item,
              'daysOverdue': daysSinceMaintenance - maintenanceInterval,
              'priority': item['priority'] ?? 'medium',
            });
          }
        }
      }
    }
    
    // 優先度順にソート
    maintenanceList.sort((a, b) {
      final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
      final aPriority = priorityOrder[a['priority']] ?? 1;
      final bPriority = priorityOrder[b['priority']] ?? 1;
      return bPriority.compareTo(aPriority);
    });
    
    return maintenanceList;
  }

  // スタッフのスキル分析
  Map<String, dynamic> get staffSkillAnalysis {
    final skillCounts = <String, int>{};
    final roleDistribution = <String, int>{};
    
    for (final member in staff) {
      final skills = List<String>.from(member['skills'] ?? []);
      for (final skill in skills) {
        skillCounts[skill] = (skillCounts[skill] ?? 0) + 1;
      }
      
      final role = member['role'] as String? ?? 'unknown';
      roleDistribution[role] = (roleDistribution[role] ?? 0) + 1;
    }
    
    return {
      'skillCounts': skillCounts,
      'roleDistribution': roleDistribution,
      'totalStaff': staff.length,
      'averageSkillsPerStaff': skillCounts.values.isEmpty ? 0.0 : 
          skillCounts.values.reduce((a, b) => a + b) / staff.length,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'level': level.name,
      'location': location,
      'monthlyRent': monthlyRent,
      'utilities': utilities,
      'equipment': equipment.map((key, value) => MapEntry(key.name, value)),
      'staff': staff,
      'facilities': facilities,
      'performanceMetrics': performanceMetrics,
      'lastUpdated': lastUpdated.toIso8601String(),
      'notes': notes,
    };
  }

  factory OfficeManagement.fromJson(Map<String, dynamic> json) {
    final equipment = <EquipmentType, List<Map<String, dynamic>>>{};
    final equipmentMap = json['equipment'] as Map<String, dynamic>? ?? {};
    
    for (final type in EquipmentType.values) {
      equipment[type] = List<Map<String, dynamic>>.from(equipmentMap[type.name] ?? []);
    }
    
    return OfficeManagement(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      level: OfficeLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => OfficeLevel.basic,
      ),
      location: json['location'] as String,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
      utilities: (json['utilities'] as num?)?.toDouble() ?? 0.0,
      equipment: equipment,
      staff: List<Map<String, dynamic>>.from(json['staff'] ?? []),
      facilities: Map<String, dynamic>.from(json['facilities'] ?? {}),
      performanceMetrics: Map<String, dynamic>.from(json['performanceMetrics'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OfficeManagement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'OfficeManagement(id: $id, scoutName: $scoutName, level: ${level.label}, location: $location)';
  }
}
