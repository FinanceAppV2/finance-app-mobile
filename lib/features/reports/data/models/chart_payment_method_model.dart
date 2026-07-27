import '../../domain/entities/chart_payment_method.dart';

class ChartPaymentMethodModel {
  final String paymentMethod;
  final double total;
  final double percentage;

  const ChartPaymentMethodModel({
    required this.paymentMethod,
    required this.total,
    required this.percentage,
  });

  factory ChartPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return ChartPaymentMethodModel(
      paymentMethod: json['paymentMethod'] as String,
      total: (json['total'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  ChartPaymentMethod toEntity() => ChartPaymentMethod(
        paymentMethod: paymentMethod,
        total: total,
        percentage: percentage,
      );
}
