import 'package:equatable/equatable.dart';

import 'asset_type.dart';

class Asset extends Equatable {
  final String id;
  final String userId;
  final String name;
  final AssetType type;
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

  const Asset({
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

  double get profit => value - investedValue;

  double get profitPercentage {
    if (investedValue == 0) return 0;
    return ((value - investedValue) / investedValue) * 100;
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
