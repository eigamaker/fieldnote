import 'dart:math' show sqrt;

enum ContractType {
  oneTime('一回限り'),
  monthly('月次'),
  quarterly('四半期'),
  annual('年次'),
  projectBased('プロジェクトベース'),
  performanceBased('成果報酬型');

  const ContractType(this.label);
  final String label;
}

enum ContractStatus {
  negotiation('交渉中'),
  active('アクティブ'),
  completed('完了'),
  cancelled('キャンセル'),
  expired('期限切れ'),
  suspended('一時停止');

  const ContractStatus(this.label);
  final String label;
}

enum CustomerType {
  professionalTeam('プロチーム'),
  highSchool('高校'),
  university('大学'),
  independent('個人'),
  organization('組織'),
  other('その他');

  const CustomerType(this.label);
  final String label;
}

class RevenueStream {
  final String id;
  final String scoutId;
  final String scoutName;
  final String name;
  final String description;
  final ContractType contractType;
  final ContractStatus status;
  final CustomerType customerType;
  final String customerName;
  final double contractValue;
  final double monthlyRevenue;
  final double totalRevenue;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? renewalDate;
  final Map<String, dynamic> terms;
  final Map<String, dynamic> performanceMetrics;
  final List<Map<String, dynamic>> revenueHistory;
  final String notes;
  final DateTime lastUpdated;

  const RevenueStream({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.name,
    required this.description,
    required this.contractType,
    required this.status,
    required this.customerType,
    required this.customerName,
    required this.contractValue,
    required this.monthlyRevenue,
    required this.totalRevenue,
    required this.startDate,
    this.endDate,
    this.renewalDate,
    this.terms = const {},
    this.performanceMetrics = const {},
    this.revenueHistory = const [],
    this.notes = '',
    required this.lastUpdated,
  });

  factory RevenueStream.initial({
    required String scoutId,
    required String scoutName,
    required String name,
    required String description,
    required ContractType contractType,
    required CustomerType customerType,
    required String customerName,
    required double contractValue,
  }) {
    return RevenueStream(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      name: name,
      description: description,
      contractType: contractType,
      status: ContractStatus.negotiation,
      customerType: customerType,
      customerName: customerName,
      contractValue: contractValue,
      monthlyRevenue: _calculateMonthlyRevenue(contractType, contractValue),
      totalRevenue: 0.0,
      startDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  static double _calculateMonthlyRevenue(ContractType type, double value) {
    switch (type) {
      case ContractType.monthly:
        return value;
      case ContractType.quarterly:
        return value / 3;
      case ContractType.annual:
        return value / 12;
      case ContractType.oneTime:
      case ContractType.projectBased:
      case ContractType.performanceBased:
        return 0.0; // 月次収入なし
    }
  }

  RevenueStream copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    String? name,
    String? description,
    ContractType? contractType,
    ContractStatus? status,
    CustomerType? customerType,
    String? customerName,
    double? contractValue,
    double? monthlyRevenue,
    double? totalRevenue,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? renewalDate,
    Map<String, dynamic>? terms,
    Map<String, dynamic>? performanceMetrics,
    List<Map<String, dynamic>>? revenueHistory,
    String? notes,
    DateTime? lastUpdated,
  }) {
    return RevenueStream(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      name: name ?? this.name,
      description: description ?? this.description,
      contractType: contractType ?? this.contractType,
      status: status ?? this.status,
      customerType: customerType ?? this.customerType,
      customerName: customerName ?? this.customerName,
      contractValue: contractValue ?? this.contractValue,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      renewalDate: renewalDate ?? this.renewalDate,
      terms: terms ?? this.terms,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
      revenueHistory: revenueHistory ?? this.revenueHistory,
      notes: notes ?? this.notes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // 契約ステータスの更新
  RevenueStream updateStatus(ContractStatus newStatus) {
    return copyWith(
      status: newStatus,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約条件の更新
  RevenueStream updateTerms(Map<String, dynamic> newTerms) {
    final updatedTerms = Map<String, dynamic>.from(terms);
    updatedTerms.addAll(newTerms);
    
    return copyWith(
      terms: updatedTerms,
      lastUpdated: DateTime.now(),
    );
  }

  // パフォーマンス指標の更新
  RevenueStream updatePerformanceMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(performanceMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      performanceMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 収入履歴の追加
  RevenueStream addRevenueRecord({
    required double amount,
    required String description,
    required DateTime date,
  }) {
    final record = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
    
    final updatedHistory = List<Map<String, dynamic>>.from(revenueHistory);
    updatedHistory.add(record);
    
    final newTotalRevenue = totalRevenue + amount;
    
    return copyWith(
      revenueHistory: updatedHistory,
      totalRevenue: newTotalRevenue,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約の延長
  RevenueStream extendContract(DateTime newEndDate, DateTime newRenewalDate) {
    return copyWith(
      endDate: newEndDate,
      renewalDate: newRenewalDate,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約の終了
  RevenueStream completeContract() {
    return copyWith(
      status: ContractStatus.completed,
      endDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  // 契約のキャンセル
  RevenueStream cancelContract(String reason) {
    final updatedTerms = Map<String, dynamic>.from(terms);
    updatedTerms['cancellationReason'] = reason;
    updatedTerms['cancellationDate'] = DateTime.now().toIso8601String();
    
    return copyWith(
      status: ContractStatus.cancelled,
      endDate: DateTime.now(),
      terms: updatedTerms,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約の一時停止
  RevenueStream suspendContract(String reason, DateTime? resumeDate) {
    final updatedTerms = Map<String, dynamic>.from(terms);
    updatedTerms['suspensionReason'] = reason;
    updatedTerms['suspensionDate'] = DateTime.now().toIso8601String();
    if (resumeDate != null) {
      updatedTerms['resumeDate'] = resumeDate.toIso8601String();
    }
    
    return copyWith(
      status: ContractStatus.suspended,
      terms: updatedTerms,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約の再開
  RevenueStream resumeContract() {
    final updatedTerms = Map<String, dynamic>.from(terms);
    updatedTerms['resumeDate'] = DateTime.now().toIso8601String();
    
    return copyWith(
      status: ContractStatus.active,
      terms: updatedTerms,
      lastUpdated: DateTime.now(),
    );
  }

  // 契約の有効性判定
  bool get isContractActive {
    if (status != ContractStatus.active) return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    return true;
  }

  // 契約の更新可能性判定
  bool get isRenewable {
    if (status != ContractStatus.active) return false;
    if (renewalDate == null) return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    
    // 更新日の30日前から更新可能
    final daysUntilRenewal = renewalDate!.difference(DateTime.now()).inDays;
    return daysUntilRenewal <= 30;
  }

  // 契約の期限切れ判定
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  // 契約の残り期間計算
  int? get remainingDays {
    if (endDate == null) return null;
    final remaining = endDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  // 月次収入の予測
  double get projectedMonthlyRevenue {
    if (!isContractActive) return 0.0;
    
    switch (contractType) {
      case ContractType.monthly:
        return monthlyRevenue;
      case ContractType.quarterly:
        return monthlyRevenue;
      case ContractType.annual:
        return monthlyRevenue;
      case ContractType.oneTime:
        return 0.0;
      case ContractType.projectBased:
        // プロジェクトベースの場合は進捗に応じて計算
        final progress = performanceMetrics['progress'] as double? ?? 0.0;
        return (contractValue * progress / 100) / 12;
      case ContractType.performanceBased:
        // 成果報酬型の場合は過去の実績から予測
        if (revenueHistory.isNotEmpty) {
          final recentRevenue = revenueHistory.take(3).map((r) => r['amount'] as double).toList();
          if (recentRevenue.isNotEmpty) {
            return recentRevenue.reduce((a, b) => a + b) / recentRevenue.length;
          }
        }
        return monthlyRevenue;
    }
  }

  // 年間収入の予測
  double get projectedAnnualRevenue {
    return projectedMonthlyRevenue * 12;
  }

  // 収益性の計算
  double get profitability {
    if (totalRevenue == 0) return 0.0;
    
    // 契約価値に対する実際の収入の比率
    return (totalRevenue / contractValue * 100).clamp(0.0, 200.0);
  }

  // 安定性の計算
  double get stability {
    if (revenueHistory.length < 2) return 100.0;
    
    final amounts = revenueHistory.map((r) => r['amount'] as double).toList();
    final mean = amounts.reduce((a, b) => a + b) / amounts.length;
    final variance = amounts.map((amount) => (amount - mean) * (amount - mean)).reduce((a, b) => a + b) / amounts.length;
    final standardDeviation = (variance > 0) ? sqrt(variance) : 0.0;
    
    // 標準偏差が小さいほど安定性が高い
    if (mean == 0) return 100.0;
    return (100 - (standardDeviation / mean * 100)).clamp(0.0, 100.0);
  }

  // 成長率の計算
  double get growthRate {
    if (revenueHistory.length < 2) return 0.0;
    
    final recentRecords = revenueHistory.take(6).toList();
    if (recentRecords.length < 2) return 0.0;
    
    final firstAmount = recentRecords.first['amount'] as double;
    final lastAmount = recentRecords.last['amount'] as double;
    
    if (firstAmount == 0) return 0.0;
    return ((lastAmount - firstAmount) / firstAmount * 100).clamp(-100.0, 100.0);
  }

  // 顧客満足度の計算
  double get customerSatisfaction {
    final satisfaction = performanceMetrics['customerSatisfaction'] as double? ?? 0.0;
    return satisfaction.clamp(0.0, 100.0);
  }

  // 契約の総合評価
  double get overallContractScore {
    double score = 0.0;
    
    // 収益性 (30点)
    if (profitability >= 100) score += 30;
    else if (profitability >= 80) score += 25;
    else if (profitability >= 60) score += 20;
    else if (profitability >= 40) score += 15;
    else if (profitability >= 20) score += 10;
    
    // 安定性 (25点)
    score += stability * 0.25;
    
    // 成長率 (20点)
    if (growthRate >= 20) score += 20;
    else if (growthRate >= 10) score += 15;
    else if (growthRate >= 0) score += 10;
    else if (growthRate >= -10) score += 5;
    
    // 顧客満足度 (15点)
    score += customerSatisfaction * 0.15;
    
    // 契約タイプのボーナス (10点)
    switch (contractType) {
      case ContractType.annual:
        score += 10;
        break;
      case ContractType.quarterly:
        score += 8;
        break;
      case ContractType.monthly:
        score += 6;
        break;
      case ContractType.projectBased:
        score += 4;
        break;
      case ContractType.performanceBased:
        score += 5;
        break;
      case ContractType.oneTime:
        score += 2;
        break;
    }
    
    return score.clamp(0.0, 100.0);
  }

  // リスク評価
  String get riskAssessment {
    if (overallContractScore >= 80) return '低リスク';
    if (overallContractScore >= 60) return '中リスク';
    if (overallContractScore >= 40) return '高リスク';
    return '非常に高リスク';
  }

  // 優先度の計算
  String get priority {
    if (isContractActive && isRenewable) return '高';
    if (isContractActive && remainingDays != null && remainingDays! <= 30) return '高';
    if (status == ContractStatus.negotiation) return '中';
    if (status == ContractStatus.suspended) return '中';
    return '低';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'name': name,
      'description': description,
      'contractType': contractType.name,
      'status': status.name,
      'customerType': customerType.name,
      'customerName': customerName,
      'contractValue': contractValue,
      'monthlyRevenue': monthlyRevenue,
      'totalRevenue': totalRevenue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'renewalDate': renewalDate?.toIso8601String(),
      'terms': terms,
      'performanceMetrics': performanceMetrics,
      'revenueHistory': revenueHistory,
      'notes': notes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory RevenueStream.fromJson(Map<String, dynamic> json) {
    return RevenueStream(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      contractType: ContractType.values.firstWhere(
        (e) => e.name == json['contractType'],
        orElse: () => ContractType.oneTime,
      ),
      status: ContractStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ContractStatus.negotiation,
      ),
      customerType: CustomerType.values.firstWhere(
        (e) => e.name == json['customerType'],
        orElse: () => CustomerType.other,
      ),
      customerName: json['customerName'] as String,
      contractValue: (json['contractValue'] as num?)?.toDouble() ?? 0.0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      renewalDate: json['renewalDate'] != null ? DateTime.parse(json['renewalDate'] as String) : null,
      terms: Map<String, dynamic>.from(json['terms'] ?? {}),
      performanceMetrics: Map<String, dynamic>.from(json['performanceMetrics'] ?? {}),
      revenueHistory: List<Map<String, dynamic>>.from(json['revenueHistory'] ?? []),
      notes: json['notes'] as String? ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RevenueStream && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RevenueStream(id: $id, name: $name, customer: $customerName, status: ${status.label}, value: ¥${contractValue.toStringAsFixed(0)})';
  }
}
