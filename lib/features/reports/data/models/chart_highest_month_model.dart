import '../../domain/entities/chart_highest_month.dart';

class ChartHighestMonthModel {
  final int month;
  final int year;
  final double total;

  const ChartHighestMonthModel({
    required this.month,
    required this.year,
    required this.total,
  });

  factory ChartHighestMonthModel.fromJson(Map<String, dynamic> json) {
    return ChartHighestMonthModel(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      total: (json['total'] as num).toDouble(),
    );
  }

  ChartHighestMonth toEntity() => ChartHighestMonth(
        month: month,
        year: year,
        total: total,
      );
}
