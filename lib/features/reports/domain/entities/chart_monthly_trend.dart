import 'package:equatable/equatable.dart';

class ChartMonthlyTrend extends Equatable {
  final int month;
  final int year;
  final double total;

  const ChartMonthlyTrend({
    required this.month,
    required this.year,
    required this.total,
  });

  @override
  List<Object?> get props => [month, year, total];
}
