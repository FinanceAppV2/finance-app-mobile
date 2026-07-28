import 'package:equatable/equatable.dart';

class ProjectedValue extends Equatable {
  final int month;
  final double value;

  const ProjectedValue({required this.month, required this.value});

  @override
  List<Object?> get props => [month, value];
}

class AssetProjection extends Equatable {
  final String assetId;
  final String assetName;
  final double currentValue;
  final double? rate;
  final String? rateType;
  final List<ProjectedValue> projectedValues;

  const AssetProjection({
    required this.assetId,
    required this.assetName,
    required this.currentValue,
    this.rate,
    this.rateType,
    required this.projectedValues,
  });

  @override
  List<Object?> get props => [
        assetId,
        assetName,
        currentValue,
        rate,
        rateType,
        projectedValues,
      ];
}
