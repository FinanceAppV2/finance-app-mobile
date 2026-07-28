import 'package:equatable/equatable.dart';

import '../../domain/entities/asset_type.dart';
import '../../domain/entities/portfolio_summary.dart';

class ByTypeSummaryModel extends Equatable {
  final String type;
  final double investedValue;
  final double currentValue;
  final int count;

  const ByTypeSummaryModel({
    required this.type,
    required this.investedValue,
    required this.currentValue,
    required this.count,
  });

  factory ByTypeSummaryModel.fromJson(Map<String, dynamic> json) {
    return ByTypeSummaryModel(
      type: json['type'] as String,
      investedValue: (json['investedValue'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  ByTypeSummary toEntity() {
    return ByTypeSummary(
      type: AssetType.fromJson(type),
      investedValue: investedValue,
      currentValue: currentValue,
      count: count,
    );
  }

  @override
  List<Object?> get props => [type, investedValue, currentValue, count];
}

class PortfolioSummaryModel extends Equatable {
  final double totalInvested;
  final double totalCurrentValue;
  final double totalProfit;
  final double profitPercentage;
  final List<ByTypeSummaryModel> byType;

  const PortfolioSummaryModel({
    required this.totalInvested,
    required this.totalCurrentValue,
    required this.totalProfit,
    required this.profitPercentage,
    required this.byType,
  });

  factory PortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
    return PortfolioSummaryModel(
      totalInvested: (json['totalInvested'] as num).toDouble(),
      totalCurrentValue: (json['totalCurrentValue'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      profitPercentage: (json['profitPercentage'] as num).toDouble(),
      byType: (json['byType'] as List)
          .map((e) =>
              ByTypeSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  PortfolioSummary toEntity() {
    return PortfolioSummary(
      totalInvested: totalInvested,
      totalCurrentValue: totalCurrentValue,
      totalProfit: totalProfit,
      profitPercentage: profitPercentage,
      byType: byType.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        totalInvested,
        totalCurrentValue,
        totalProfit,
        profitPercentage,
        byType,
      ];
}
