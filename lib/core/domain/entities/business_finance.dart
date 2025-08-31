import 'dart:math' show sqrt;

enum FinancialStatus {
  healthy('健全'),
  stable('安定'),
  warning('注意'),
  critical('危機'),
  bankrupt('破綻');

  const FinancialStatus(this.label);
  final String label;
}

enum RevenueType {
  playerIntroduction('選手紹介'),
  scoutReport('スカウトレポート'),
  teamConsulting('チームコンサル'),
  trainingProgram('研修プログラム'),
  marketAnalysis('市場分析'),
  other('その他');

  const RevenueType(this.label);
  final String label;
}

enum ExpenseType {
  personnel('人件費'),
  office('事務所費'),
  equipment('設備費'),
  travel('旅費'),
  marketing('マーケティング'),
  training('研修費'),
  other('その他');

  const ExpenseType(this.label);
  final String label;
}

class BusinessFinance {
  final String id;
  final String scoutId;
  final String scoutName;
  final double currentBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double annualIncome;
  final double annualExpenses;
  final double profitMargin;
  final FinancialStatus status;
  final Map<RevenueType, double> revenueBreakdown;
  final Map<ExpenseType, double> expenseBreakdown;
  final List<Map<String, dynamic>> transactionHistory;
  final Map<String, dynamic> financialMetrics;
  final DateTime lastUpdated;
  final String notes;

  const BusinessFinance({
    required this.id,
    required this.scoutId,
    required this.scoutName,
    required this.currentBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.annualIncome,
    required this.annualExpenses,
    required this.profitMargin,
    required this.status,
    required this.revenueBreakdown,
    required this.expenseBreakdown,
    this.transactionHistory = const [],
    this.financialMetrics = const {},
    required this.lastUpdated,
    this.notes = '',
  });

  factory BusinessFinance.initial({
    required String scoutId,
    required String scoutName,
  }) {
    final initialRevenue = <RevenueType, double>{};
    final initialExpenses = <ExpenseType, double>{};
    
    for (final type in RevenueType.values) {
      initialRevenue[type] = 0.0;
    }
    for (final type in ExpenseType.values) {
      initialExpenses[type] = 0.0;
    }
    
    return BusinessFinance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scoutId: scoutId,
      scoutName: scoutName,
      currentBalance: 100000.0, // 初期資金10万円
      monthlyIncome: 0.0,
      monthlyExpenses: 0.0,
      annualIncome: 0.0,
      annualExpenses: 0.0,
      profitMargin: 0.0,
      status: FinancialStatus.healthy,
      revenueBreakdown: initialRevenue,
      expenseBreakdown: initialExpenses,
      lastUpdated: DateTime.now(),
    );
  }

  BusinessFinance copyWith({
    String? id,
    String? scoutId,
    String? scoutName,
    double? currentBalance,
    double? monthlyIncome,
    double? monthlyExpenses,
    double? annualIncome,
    double? annualExpenses,
    double? profitMargin,
    FinancialStatus? status,
    Map<RevenueType, double>? revenueBreakdown,
    Map<ExpenseType, double>? expenseBreakdown,
    List<Map<String, dynamic>>? transactionHistory,
    Map<String, dynamic>? financialMetrics,
    DateTime? lastUpdated,
    String? notes,
  }) {
    return BusinessFinance(
      id: id ?? this.id,
      scoutId: scoutId ?? this.scoutId,
      scoutName: scoutName ?? this.scoutName,
      currentBalance: currentBalance ?? this.currentBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      annualIncome: annualIncome ?? this.annualIncome,
      annualExpenses: annualExpenses ?? this.annualExpenses,
      profitMargin: profitMargin ?? this.profitMargin,
      status: status ?? this.status,
      revenueBreakdown: revenueBreakdown ?? this.revenueBreakdown,
      expenseBreakdown: expenseBreakdown ?? this.expenseBreakdown,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      financialMetrics: financialMetrics ?? this.financialMetrics,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
    );
  }

  // 収入の追加
  BusinessFinance addRevenue(RevenueType type, double amount) {
    final updatedRevenue = Map<RevenueType, double>.from(revenueBreakdown);
    updatedRevenue[type] = (updatedRevenue[type] ?? 0.0) + amount;
    
    final newMonthlyIncome = monthlyIncome + amount;
    final newAnnualIncome = annualIncome + amount;
    final newBalance = currentBalance + amount;
    
    return copyWith(
      revenueBreakdown: updatedRevenue,
      monthlyIncome: newMonthlyIncome,
      annualIncome: newAnnualIncome,
      currentBalance: newBalance,
      lastUpdated: DateTime.now(),
    );
  }

  // 支出の追加
  BusinessFinance addExpense(ExpenseType type, double amount) {
    final updatedExpenses = Map<ExpenseType, double>.from(expenseBreakdown);
    updatedExpenses[type] = (updatedExpenses[type] ?? 0.0) + amount;
    
    final newMonthlyExpenses = monthlyExpenses + amount;
    final newAnnualExpenses = annualExpenses + amount;
    final newBalance = currentBalance - amount;
    
    return copyWith(
      expenseBreakdown: updatedExpenses,
      monthlyExpenses: newMonthlyExpenses,
      annualExpenses: newAnnualExpenses,
      currentBalance: newBalance,
      lastUpdated: DateTime.now(),
    );
  }

  // 取引履歴の追加
  BusinessFinance addTransaction({
    required String description,
    required double amount,
    required bool isIncome,
    required String category,
  }) {
    final transaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'description': description,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'date': DateTime.now().toIso8601String(),
    };
    
    final updatedHistory = List<Map<String, dynamic>>.from(transactionHistory);
    updatedHistory.add(transaction);
    
    return copyWith(
      transactionHistory: updatedHistory,
      lastUpdated: DateTime.now(),
    );
  }

  // 財務指標の更新
  BusinessFinance updateFinancialMetrics(Map<String, dynamic> newMetrics) {
    final updatedMetrics = Map<String, dynamic>.from(financialMetrics);
    updatedMetrics.addAll(newMetrics);
    
    return copyWith(
      financialMetrics: updatedMetrics,
      lastUpdated: DateTime.now(),
    );
  }

  // 月次リセット
  BusinessFinance resetMonthly() {
    return copyWith(
      monthlyIncome: 0.0,
      monthlyExpenses: 0.0,
      revenueBreakdown: Map.fromEntries(
        RevenueType.values.map((type) => MapEntry(type, 0.0))
      ),
      expenseBreakdown: Map.fromEntries(
        ExpenseType.values.map((type) => MapEntry(type, 0.0))
      ),
      lastUpdated: DateTime.now(),
    );
  }

  // 年次リセット
  BusinessFinance resetAnnual() {
    return copyWith(
      annualIncome: 0.0,
      annualExpenses: 0.0,
      lastUpdated: DateTime.now(),
    );
  }

  // 利益率の計算
  double get calculatedProfitMargin {
    if (annualIncome == 0) return 0.0;
    return ((annualIncome - annualExpenses) / annualIncome * 100).clamp(-100.0, 100.0);
  }

  // 財務状態の計算
  FinancialStatus get calculatedFinancialStatus {
    if (currentBalance < 0) return FinancialStatus.bankrupt;
    if (currentBalance < 10000) return FinancialStatus.critical;
    if (currentBalance < 50000) return FinancialStatus.warning;
    if (currentBalance < 200000) return FinancialStatus.stable;
    return FinancialStatus.healthy;
  }

  // キャッシュフローの計算
  double get cashFlow {
    return monthlyIncome - monthlyExpenses;
  }

  // 収益性の計算
  double get profitability {
    if (monthlyExpenses == 0) return 0.0;
    return (monthlyIncome / monthlyExpenses).clamp(0.0, 10.0);
  }

  // 効率性の計算
  double get efficiency {
    if (monthlyIncome == 0) return 0.0;
    final totalRevenue = revenueBreakdown.values.reduce((a, b) => a + b);
    if (totalRevenue == 0) return 0.0;
    
    // 主要収益源への集中度を計算
    final sortedRevenue = revenueBreakdown.values.toList()..sort((a, b) => b.compareTo(a));
    final topRevenue = sortedRevenue.take(2).reduce((a, b) => a + b);
    
    return (topRevenue / totalRevenue).clamp(0.0, 1.0);
  }

  // 安定性の計算
  double get stability {
    if (transactionHistory.length < 2) return 100.0;
    
    final amounts = transactionHistory.map((t) => t['amount'] as double).toList();
    final mean = amounts.reduce((a, b) => a + b) / amounts.length;
    final variance = amounts.map((amount) => (amount - mean) * (amount - mean)).reduce((a, b) => a + b) / amounts.length;
    final standardDeviation = sqrt(variance);
    
    // 標準偏差が小さいほど安定性が高い
    return (100 - (standardDeviation / mean * 100)).clamp(0.0, 100.0);
  }

  // 成長率の計算
  double get growthRate {
    if (transactionHistory.length < 2) return 0.0;
    
    final recentTransactions = transactionHistory.take(10).toList();
    final incomeTransactions = recentTransactions.where((t) => t['isIncome'] == true).toList();
    final expenseTransactions = recentTransactions.where((t) => t['isIncome'] == false).toList();
    
    if (incomeTransactions.isEmpty || expenseTransactions.isEmpty) return 0.0;
    
    final avgIncome = incomeTransactions.map((t) => t['amount'] as double).reduce((a, b) => a + b) / incomeTransactions.length;
    final avgExpense = expenseTransactions.map((t) => t['amount'] as double).reduce((a, b) => a + b) / expenseTransactions.length;
    
    if (avgExpense == 0) return 0.0;
    return ((avgIncome - avgExpense) / avgExpense * 100).clamp(-100.0, 100.0);
  }

  // 財務健全性スコアの計算
  double get financialHealthScore {
    double score = 0.0;
    
    // 現在残高 (30点)
    if (currentBalance >= 200000) score += 30;
    else if (currentBalance >= 100000) score += 20;
    else if (currentBalance >= 50000) score += 10;
    
    // 利益率 (25点)
    if (calculatedProfitMargin >= 20) score += 25;
    else if (calculatedProfitMargin >= 10) score += 20;
    else if (calculatedProfitMargin >= 0) score += 15;
    else if (calculatedProfitMargin >= -10) score += 10;
    
    // キャッシュフロー (20点)
    if (cashFlow >= 50000) score += 20;
    else if (cashFlow >= 20000) score += 15;
    else if (cashFlow >= 0) score += 10;
    
    // 効率性 (15点)
    score += efficiency * 15;
    
    // 安定性 (10点)
    score += stability / 10;
    
    return score.clamp(0.0, 100.0);
  }

  // 収益源の多様性
  double get revenueDiversity {
    final activeRevenueSources = revenueBreakdown.values.where((amount) => amount > 0).length;
    return activeRevenueSources / RevenueType.values.length;
  }

  // 支出の最適化度
  double get expenseOptimization {
    if (monthlyExpenses == 0) return 100.0;
    
    final essentialExpenses = (expenseBreakdown[ExpenseType.personnel] ?? 0.0) +
                             (expenseBreakdown[ExpenseType.office] ?? 0.0);
    final totalExpenses = monthlyExpenses;
    
    if (totalExpenses == 0) return 100.0;
    return ((essentialExpenses / totalExpenses) * 100).clamp(0.0, 100.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scoutId': scoutId,
      'scoutName': scoutName,
      'currentBalance': currentBalance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'annualIncome': annualIncome,
      'annualExpenses': annualExpenses,
      'profitMargin': profitMargin,
      'status': status.name,
      'revenueBreakdown': revenueBreakdown.map((key, value) => MapEntry(key.name, value)),
      'expenseBreakdown': expenseBreakdown.map((key, value) => MapEntry(key.name, value)),
      'transactionHistory': transactionHistory,
      'financialMetrics': financialMetrics,
      'lastUpdated': lastUpdated.toIso8601String(),
      'notes': notes,
    };
  }

  factory BusinessFinance.fromJson(Map<String, dynamic> json) {
    final revenueBreakdown = <RevenueType, double>{};
    final expenseBreakdown = <ExpenseType, double>{};
    
    final revenueMap = json['revenueBreakdown'] as Map<String, dynamic>? ?? {};
    final expenseMap = json['expenseBreakdown'] as Map<String, dynamic>? ?? {};
    
    for (final type in RevenueType.values) {
      revenueBreakdown[type] = (revenueMap[type.name] as num?)?.toDouble() ?? 0.0;
    }
    for (final type in ExpenseType.values) {
      expenseBreakdown[type] = (expenseMap[type.name] as num?)?.toDouble() ?? 0.0;
    }
    
    return BusinessFinance(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      scoutName: json['scoutName'] as String,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble() ?? 0.0,
      annualIncome: (json['annualIncome'] as num?)?.toDouble() ?? 0.0,
      annualExpenses: (json['annualExpenses'] as num?)?.toDouble() ?? 0.0,
      profitMargin: (json['profitMargin'] as num?)?.toDouble() ?? 0.0,
      status: FinancialStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FinancialStatus.healthy,
      ),
      revenueBreakdown: revenueBreakdown,
      expenseBreakdown: expenseBreakdown,
      transactionHistory: List<Map<String, dynamic>>.from(json['transactionHistory'] ?? []),
      financialMetrics: Map<String, dynamic>.from(json['financialMetrics'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusinessFinance && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BusinessFinance(id: $id, scoutName: $scoutName, balance: ¥${currentBalance.toStringAsFixed(0)}, status: ${status.label})';
  }
}
