import '../entities/loan.dart';
import '../repositories/loan_repository.dart';

class GetLoansUseCase {
  final LoanRepository _repository;
  GetLoansUseCase(this._repository);

  Future<List<Loan>> execute() async {
    final result = await _repository.getLoans();
    return result.fold((_) => [], (loans) => loans);
  }
}
