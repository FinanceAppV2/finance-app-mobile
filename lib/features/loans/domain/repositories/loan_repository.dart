import 'package:fpdart/fpdart.dart';

import '../entities/loan.dart';

abstract class LoanRepository {
  Future<Either<String, List<Loan>>> getLoans();
  Future<Either<String, Loan>> getLoanById(String id);
  Future<Either<String, Loan>> createLoan({
    required String description,
    required double totalValue,
    required int totalInstallments,
    required DateTime startDate,
    double monthlyInterestRate,
  });
  Future<Either<String, Loan>> updateLoan({
    required String id,
    String? description,
    double? totalValue,
    int? totalInstallments,
    double? monthlyInterestRate,
    DateTime? startDate,
    bool? active,
  });
  Future<Either<String, void>> deleteLoan(String id);
  Future<Either<String, List<Loan>>> getActiveLoans({
    required int month,
    required int year,
  });
}
