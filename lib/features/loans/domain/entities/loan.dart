import 'package:equatable/equatable.dart';

class Loan extends Equatable {
  final String id;
  final String userId;
  final String description;
  final double totalValue;
  final int totalInstallments;
  final double installmentValue;
  final double monthlyInterestRate;
  final double totalWithInterest;
  final DateTime startDate;
  final bool active;
  final int? currentInstallment;
  final DateTime? nextInstallmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Loan({
    required this.id,
    required this.userId,
    required this.description,
    required this.totalValue,
    required this.totalInstallments,
    required this.installmentValue,
    required this.monthlyInterestRate,
    required this.totalWithInterest,
    required this.startDate,
    required this.active,
    this.currentInstallment,
    this.nextInstallmentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int get paidInstallments => currentInstallment ?? 0;
  double get paidAmount => paidInstallments * installmentValue;
  double get remainingAmount => totalWithInterest - paidAmount;
  double get progress =>
      totalInstallments > 0 ? paidInstallments / totalInstallments : 0;

  @override
  List<Object?> get props => [
        id,
        userId,
        description,
        totalValue,
        totalInstallments,
        installmentValue,
        monthlyInterestRate,
        totalWithInterest,
        startDate,
        active,
        currentInstallment,
        nextInstallmentDate,
        createdAt,
        updatedAt,
      ];
}
