import 'package:equatable/equatable.dart';

class ChartFixedVsVariable extends Equatable {
  final double fixedTotal;
  final double variableTotal;
  final double fixedPercentage;
  final double variablePercentage;

  const ChartFixedVsVariable({
    required this.fixedTotal,
    required this.variableTotal,
    required this.fixedPercentage,
    required this.variablePercentage,
  });

  @override
  List<Object?> get props => [fixedTotal, variableTotal, fixedPercentage, variablePercentage];
}
