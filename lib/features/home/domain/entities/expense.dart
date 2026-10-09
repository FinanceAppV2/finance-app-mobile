import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String description;
  final double value;
  final String category;
  final String paymentMethod;
  final String date;
  final String? cardId;
  final int? installments;
  final String type;

  const Expense({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.paymentMethod,
    required this.date,
    this.cardId,
    this.installments,
    this.type = 'EXPENSE',
  });

  bool get isLoanInstallment => type == 'LOAN_INSTALLMENT';

  @override
  List<Object?> get props => [
        id,
        description,
        value,
        category,
        paymentMethod,
        date,
        cardId,
        installments,
        type,
      ];
}
