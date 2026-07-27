import '../../domain/entities/chart_monthly_trend.dart';

class ChartMonthlyTrendModel {
  final int month;
  final int year;
  final double total;

  const ChartMonthlyTrendModel({
    required this.month,
    required this.year,
    required this.total,
  });

  factory ChartMonthlyTrendModel.fromJson(Map<String, dynamic> json) {
    return ChartMonthlyTrendModel(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      total: (json['total'] as num).toDouble(),
    );
  }

  ChartMonthlyTrend toEntity() => ChartMonthlyTrend(
        month: month,
        year: year,
        total: total,
      );
}
