import '../../domain/entities/chart_fixed_vs_variable.dart';

class ChartFixedVsVariableModel {
  final double fixedTotal;
  final double variableTotal;
  final double fixedPercentage;
  final double variablePercentage;

  const ChartFixedVsVariableModel({
    required this.fixedTotal,
    required this.variableTotal,
    required this.fixedPercentage,
    required this.variablePercentage,
  });

  factory ChartFixedVsVariableModel.fromJson(Map<String, dynamic> json) {
    return ChartFixedVsVariableModel(
      fixedTotal: (json['fixedTotal'] as num).toDouble(),
      variableTotal: (json['variableTotal'] as num).toDouble(),
      fixedPercentage: (json['fixedPercentage'] as num).toDouble(),
      variablePercentage: (json['variablePercentage'] as num).toDouble(),
    );
  }

  ChartFixedVsVariable toEntity() => ChartFixedVsVariable(
        fixedTotal: fixedTotal,
        variableTotal: variableTotal,
        fixedPercentage: fixedPercentage,
        variablePercentage: variablePercentage,
      );
}
