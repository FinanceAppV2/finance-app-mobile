import '../entities/loan.dart';
import '../repositories/loan_repository.dart';

class GetActiveLoansUseCase {
  final LoanRepository _repository;
  GetActiveLoansUseCase(this._repository);

  Future<List<Loan>> execute({required int month, required int year}) async {
    final result = await _repository.getActiveLoans(month: month, year: year);
    return result.fold((_) => [], (loans) => loans);
  }
}
