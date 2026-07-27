import 'package:equatable/equatable.dart';

class ChartPaymentMethod extends Equatable {
  final String paymentMethod;
  final double total;
  final double percentage;

  const ChartPaymentMethod({
    required this.paymentMethod,
    required this.total,
    required this.percentage,
  });

  @override
  List<Object?> get props => [paymentMethod, total, percentage];
}
