import '../repositories/loan_repository.dart';

class DeleteLoanUseCase {
  final LoanRepository _repository;
  DeleteLoanUseCase(this._repository);

  Future<bool> execute(String id) async {
    final result = await _repository.deleteLoan(id);
    return result.fold((_) => false, (_) => true);
  }
}
