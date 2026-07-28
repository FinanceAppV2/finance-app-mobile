import 'package:equatable/equatable.dart';

import 'asset_type.dart';

class ByTypeSummary extends Equatable {
  final AssetType type;
  final double investedValue;
  final double currentValue;
  final int count;

  const ByTypeSummary({
    required this.type,
    required this.investedValue,
    required this.currentValue,
    required this.count,
  });

  @override
  List<Object?> get props => [type, investedValue, currentValue, count];
}

class PortfolioSummary extends Equatable {
  final double totalInvested;
  final double totalCurrentValue;
  final double totalProfit;
  final double profitPercentage;
  final List<ByTypeSummary> byType;

  const PortfolioSummary({
    required this.totalInvested,
    required this.totalCurrentValue,
    required this.totalProfit,
    required this.profitPercentage,
    required this.byType,
  });

  @override
  List<Object?> get props => [
        totalInvested,
        totalCurrentValue,
        totalProfit,
        profitPercentage,
        byType,
      ];
}
