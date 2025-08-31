import 'dart:math';
import '../../../core/domain/entities/information_share.dart';
import '../../../core/domain/entities/scouting_report.dart';

class ValueCalculator {
  // 情報の価値計算
  static double calculateInformationValue(InformationShare information) {
    double baseValue = information.valueScore;
    
    // 品質による調整
    final qualityMultiplier = _getQualityMultiplier(information.quality);
    baseValue *= qualityMultiplier;
    
    // 新鮮度による調整
    final freshnessMultiplier = information.freshnessScore;
    baseValue *= freshnessMultiplier;
    
    // 共有数による調整
    final shareMultiplier = 1.0 + (information.shareCount * 0.1);
    baseValue *= shareMultiplier;
    
    // タイプによる調整
    final typeMultiplier = _getTypeMultiplier(information.type);
    baseValue *= typeMultiplier;
    
    // 権限による調整
    final permissionMultiplier = _getPermissionMultiplier(information.permission);
    baseValue *= permissionMultiplier;
    
    return baseValue.clamp(0.0, 100.0);
  }

  // レポートの価値計算
  static double calculateReportValue(ScoutingReport report) {
    double baseValue = 50.0;
    
    // 品質スコアによる調整
    final qualityMultiplier = report.qualityScore / 100.0;
    baseValue *= qualityMultiplier;
    
    // 信頼度による調整
    final confidenceMultiplier = _getConfidenceMultiplier(report.confidence);
    baseValue *= confidenceMultiplier;
    
    // 新鮮度による調整
    final freshnessMultiplier = report.freshnessScore;
    baseValue *= freshnessMultiplier;
    
    // 完全性による調整
    if (report.isReportComplete) {
      baseValue *= 1.2;
    }
    
    // 公開状態による調整
    if (report.isPublic) {
      baseValue *= 0.8; // 公開されていると価値が下がる
    }
    
    return baseValue.clamp(0.0, 100.0);
  }

  // 市場価値の計算
  static double calculateMarketValue(InformationShare information, Map<String, dynamic> marketData) {
    double baseValue = calculateInformationValue(information);
    
    // 市場需要による調整
    final demandMultiplier = _getDemandMultiplier(information.type, marketData);
    baseValue *= demandMultiplier;
    
    // 競合状況による調整
    final competitionMultiplier = _getCompetitionMultiplier(information.type, marketData);
    baseValue *= competitionMultiplier;
    
    // 季節性による調整
    final seasonalMultiplier = _getSeasonalMultiplier(information.creationDate);
    baseValue *= seasonalMultiplier;
    
    return baseValue.clamp(0.0, 100.0);
  }

  // 情報の交換価値計算
  static double calculateExchangeValue(InformationShare information1, InformationShare information2) {
    final value1 = calculateInformationValue(information1);
    final value2 = calculateInformationValue(information2);
    
    // 価値の差による調整
    final valueDifference = (value1 - value2).abs();
    final adjustmentFactor = 1.0 - (valueDifference / 100.0) * 0.3;
    
    return (value1 + value2) / 2 * adjustmentFactor;
  }

  // 情報の時限価値計算
  static double calculateTimeValue(InformationShare information, DateTime targetDate) {
    final baseValue = calculateInformationValue(information);
    
    // 時間経過による減価
    final daysSinceCreation = targetDate.difference(information.creationDate).inDays;
    final timeDecay = _calculateTimeDecay(daysSinceCreation, information.type);
    
    // 有効期限による調整
    if (information.expirationDate != null) {
      final daysUntilExpiration = information.expirationDate!.difference(targetDate).inDays;
      if (daysUntilExpiration < 0) {
        return 0.0; // 期限切れ
      }
      final expirationFactor = _calculateExpirationFactor(daysUntilExpiration);
      return baseValue * timeDecay * expirationFactor;
    }
    
    return baseValue * timeDecay;
  }

  // 情報の希少性価値計算
  static double calculateRarityValue(InformationShare information, List<InformationShare> similarInformation) {
    final baseValue = calculateInformationValue(information);
    
    // 類似情報の数による調整
    double rarityFactor = _calculateRarityFactor(similarInformation.length);
    
    // 独占性による調整
    if (information.permission == SharePermission.exclusive) {
      rarityFactor *= 1.5;
    }
    
    return baseValue * rarityFactor;
  }

  // 情報の信頼性価値計算
  static double calculateReliabilityValue(InformationShare information, Map<String, dynamic> reliabilityData) {
    final baseValue = calculateInformationValue(information);
    
    // 所有者の信頼度による調整
    final ownerReliability = reliabilityData['ownerReliability'] as double? ?? 0.5;
    final reliabilityMultiplier = 0.5 + (ownerReliability * 0.5);
    
    // 情報の検証状況による調整
    final verificationStatus = reliabilityData['verificationStatus'] as bool? ?? false;
    final verificationMultiplier = verificationStatus ? 1.2 : 1.0;
    
    // 情報源の信頼性による調整
    final sourceReliability = reliabilityData['sourceReliability'] as double? ?? 0.5;
    final sourceMultiplier = 0.5 + (sourceReliability * 0.5);
    
    return baseValue * reliabilityMultiplier * verificationMultiplier * sourceMultiplier;
  }

  // 情報の戦略的価値計算
  static double calculateStrategicValue(InformationShare information, Map<String, dynamic> strategicContext) {
    final baseValue = calculateInformationValue(information);
    
    // 戦略的重要性による調整
    final strategicImportance = strategicContext['strategicImportance'] as double? ?? 0.5;
    final importanceMultiplier = 0.5 + (strategicImportance * 0.5);
    
    // 競合優位性による調整
    final competitiveAdvantage = strategicContext['competitiveAdvantage'] as double? ?? 0.5;
    final advantageMultiplier = 0.5 + (competitiveAdvantage * 0.5);
    
    // 市場機会による調整
    final marketOpportunity = strategicContext['marketOpportunity'] as double? ?? 0.5;
    final opportunityMultiplier = 0.5 + (marketOpportunity * 0.5);
    
    return baseValue * importanceMultiplier * advantageMultiplier * opportunityMultiplier;
  }

  // ヘルパーメソッド
  static double _getQualityMultiplier(InformationQuality quality) {
    switch (quality) {
      case InformationQuality.poor:
        return 0.5;
      case InformationQuality.fair:
        return 0.7;
      case InformationQuality.good:
        return 1.0;
      case InformationQuality.excellent:
        return 1.3;
      case InformationQuality.exceptional:
        return 1.6;
    }
  }

  static double _getTypeMultiplier(InformationType type) {
    switch (type) {
      case InformationType.playerReport:
        return 1.2;
      case InformationType.scoutingData:
        return 1.0;
      case InformationType.teamAnalysis:
        return 1.1;
      case InformationType.tournamentInfo:
        return 0.9;
      case InformationType.marketTrends:
        return 1.3;
      case InformationType.insiderInfo:
        return 1.5;
    }
  }

  static double _getPermissionMultiplier(SharePermission permission) {
    switch (permission) {
      case SharePermission.private:
        return 1.0;
      case SharePermission.shared:
        return 0.9;
      case SharePermission.exclusive:
        return 1.4;
      case SharePermission.public:
        return 0.7;
    }
  }

  static double _getConfidenceMultiplier(ReportConfidence confidence) {
    switch (confidence) {
      case ReportConfidence.low:
        return 0.6;
      case ReportConfidence.medium:
        return 0.8;
      case ReportConfidence.high:
        return 1.0;
      case ReportConfidence.veryHigh:
        return 1.2;
    }
  }

  static double _getDemandMultiplier(InformationType type, Map<String, dynamic> marketData) {
    final demandData = marketData['demand'] as Map<String, dynamic>? ?? {};
    final typeDemand = demandData[type.name] as double? ?? 0.5;
    return 0.5 + (typeDemand * 0.5);
  }

  static double _getCompetitionMultiplier(InformationType type, Map<String, dynamic> marketData) {
    final competitionData = marketData['competition'] as Map<String, dynamic>? ?? {};
    final typeCompetition = competitionData[type.name] as double? ?? 0.5;
    
    // 競合が少ないほど価値が高い
    return 1.5 - (typeCompetition * 0.5);
  }

  static double _getSeasonalMultiplier(DateTime creationDate) {
    final month = creationDate.month;
    
    // 野球シーズン中の情報は価値が高い
    if (month >= 3 && month <= 11) {
      return 1.2;
    } else {
      return 0.8;
    }
  }

  static double _calculateTimeDecay(int daysSinceCreation, InformationType type) {
    // 情報タイプによる減価速度の違い
    double decayRate;
    switch (type) {
      case InformationType.playerReport:
        decayRate = 0.02; // 選手情報は比較的長持ち
        break;
      case InformationType.scoutingData:
        decayRate = 0.03; // スカウトデータは中程度
        break;
      case InformationType.teamAnalysis:
        decayRate = 0.025; // チーム分析は中程度
        break;
      case InformationType.tournamentInfo:
        decayRate = 0.05; // 大会情報は早く古くなる
        break;
      case InformationType.marketTrends:
        decayRate = 0.04; // 市場動向は中程度
        break;
      case InformationType.insiderInfo:
        decayRate = 0.06; // 内部情報は最も早く古くなる
        break;
    }
    
    return exp(-decayRate * daysSinceCreation).clamp(0.1, 1.0);
  }

  static double _calculateExpirationFactor(int daysUntilExpiration) {
    if (daysUntilExpiration <= 0) return 0.0;
    if (daysUntilExpiration <= 7) return 0.3;
    if (daysUntilExpiration <= 30) return 0.6;
    if (daysUntilExpiration <= 90) return 0.8;
    return 1.0;
  }

  static double _calculateRarityFactor(int similarCount) {
    if (similarCount == 0) return 2.0; // 唯一無二
    if (similarCount <= 3) return 1.5; // 非常に希少
    if (similarCount <= 10) return 1.2; // 希少
    if (similarCount <= 30) return 1.0; // 普通
    return 0.8; // 一般的
  }

  // 価値の正規化
  static double normalizeValue(double value, double minValue, double maxValue) {
    if (maxValue == minValue) return 0.5;
    return (value - minValue) / (maxValue - minValue);
  }

  // 価値の比較
  static int compareValues(double value1, double value2) {
    if (value1 < value2) return -1;
    if (value1 > value2) return 1;
    return 0;
  }

  // 価値の集約
  static double aggregateValues(List<double> values, String method) {
    if (values.isEmpty) return 0.0;
    
    switch (method) {
      case 'average':
        return values.reduce((a, b) => a + b) / values.length;
      case 'max':
        return values.reduce((a, b) => a > b ? a : b);
      case 'min':
        return values.reduce((a, b) => a < b ? a : b);
      case 'median':
        values.sort();
        final mid = values.length ~/ 2;
        if (values.length.isOdd) {
          return values[mid];
        } else {
          return (values[mid - 1] + values[mid]) / 2;
        }
      default:
        return values.reduce((a, b) => a + b) / values.length;
    }
  }
}
