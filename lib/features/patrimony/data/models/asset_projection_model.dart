import 'package:equatable/equatable.dart';

import '../../domain/entities/asset_projection.dart';

class ProjectedValueModel extends Equatable {
  final int month;
  final double value;

  const ProjectedValueModel({required this.month, required this.value});

  factory ProjectedValueModel.fromJson(Map<String, dynamic> json) {
    return ProjectedValueModel(
      month: json['month'] as int,
      value: (json['value'] as num).toDouble(),
    );
  }

  ProjectedValue toEntity() => ProjectedValue(month: month, value: value);

  @override
  List<Object?> get props => [month, value];
}

class AssetProjectionModel extends Equatable {
  final String assetId;
  final String assetName;
  final double currentValue;
  final double? rate;
  final String? rateType;
  final List<ProjectedValueModel> projectedValues;

  const AssetProjectionModel({
    required this.assetId,
    required this.assetName,
    required this.currentValue,
    this.rate,
    this.rateType,
    required this.projectedValues,
  });

  factory AssetProjectionModel.fromJson(Map<String, dynamic> json) {
    return AssetProjectionModel(
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      currentValue: (json['currentValue'] as num).toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      rateType: json['rateType'] as String?,
      projectedValues: (json['projectedValues'] as List)
          .map((e) =>
              ProjectedValueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  AssetProjection toEntity() {
    return AssetProjection(
      assetId: assetId,
      assetName: assetName,
      currentValue: currentValue,
      rate: rate,
      rateType: rateType,
      projectedValues: projectedValues.map((e) => e.toEntity()).toList(),
    );
  }

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
