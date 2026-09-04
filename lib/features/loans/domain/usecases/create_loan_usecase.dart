import '../entities/loan.dart';
import '../repositories/loan_repository.dart';

class CreateLoanUseCase {
  final LoanRepository _repository;
  CreateLoanUseCase(this._repository);

  Future<Loan?> execute({
    required String description,
    required double totalValue,
    required int totalInstallments,
    required DateTime startDate,
    double monthlyInterestRate = 0,
  }) async {
    final result = await _repository.createLoan(
      description: description,
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      startDate: startDate,
      monthlyInterestRate: monthlyInterestRate,
    );
    return result.fold((_) => null, (loan) => loan);
  }
}
