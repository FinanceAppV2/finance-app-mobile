import '../entities/loan.dart';
import '../repositories/loan_repository.dart';

class UpdateLoanUseCase {
  final LoanRepository _repository;
  UpdateLoanUseCase(this._repository);

  Future<Loan?> execute({
    required String id,
    String? description,
    double? totalValue,
    int? totalInstallments,
    double? monthlyInterestRate,
    DateTime? startDate,
    bool? active,
  }) async {
    final result = await _repository.updateLoan(
      id: id,
      description: description,
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      monthlyInterestRate: monthlyInterestRate,
      startDate: startDate,
      active: active,
    );
    return result.fold((_) => null, (loan) => loan);
  }
}
