import '../../domain/entities/chart_category.dart';

class ChartCategoryModel {
  final String category;
  final double total;
  final double percentage;

  const ChartCategoryModel({
    required this.category,
    required this.total,
    required this.percentage,
  });

  factory ChartCategoryModel.fromJson(Map<String, dynamic> json) {
    return ChartCategoryModel(
      category: json['category'] as String,
      total: (json['total'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  ChartCategory toEntity() => ChartCategory(
        category: category,
        total: total,
        percentage: percentage,
      );
}
