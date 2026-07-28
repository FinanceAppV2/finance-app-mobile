import 'package:equatable/equatable.dart';

import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_type.dart';

class AssetModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String type;
  final String category;
  final double value;
  final double investedValue;
  final double? rate;
  final String? rateType;
  final String? institution;
  final String? dueDate;
  final String? ticker;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.category,
    required this.value,
    required this.investedValue,
    this.rate,
    this.rateType,
    this.institution,
    this.dueDate,
    this.ticker,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      value: (json['value'] as num).toDouble(),
      investedValue: (json['investedValue'] as num).toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      rateType: json['rateType'] as String?,
      institution: json['institution'] as String?,
      dueDate: json['dueDate'] as String?,
      ticker: json['ticker'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Asset toEntity() {
    return Asset(
      id: id,
      userId: userId,
      name: name,
      type: AssetType.fromJson(type),
      category: category,
      value: value,
      investedValue: investedValue,
      rate: rate,
      rateType: rateType,
      institution: institution,
      dueDate: dueDate,
      ticker: ticker,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        category,
        value,
        investedValue,
        rate,
        rateType,
        institution,
        dueDate,
        ticker,
        notes,
        createdAt,
        updatedAt,
      ];
}
