import 'package:equatable/equatable.dart';

class ChartCategory extends Equatable {
  final String category;
  final double total;
  final double percentage;

  const ChartCategory({
    required this.category,
    required this.total,
    required this.percentage,
  });

  @override
  List<Object?> get props => [category, total, percentage];
}
