import 'package:flutter/material.dart';

import '../../domain/entities/loan.dart';
import '../../domain/usecases/create_loan_usecase.dart';
import '../../domain/usecases/delete_loan_usecase.dart';
import '../../domain/usecases/get_loans_usecase.dart';
import '../../domain/usecases/update_loan_usecase.dart';

enum LoansStatus { initial, loading, success, error }

class LoansController extends ChangeNotifier {
  final GetLoansUseCase _getLoansUseCase;
  final CreateLoanUseCase _createLoanUseCase;
  final UpdateLoanUseCase _updateLoanUseCase;
  final DeleteLoanUseCase _deleteLoanUseCase;

  LoansStatus _status = LoansStatus.initial;
  List<Loan> _loans = [];
  String? _errorMessage;

  LoansController(
    this._getLoansUseCase,
    this._createLoanUseCase,
    this._updateLoanUseCase,
    this._deleteLoanUseCase,
  );

  LoansStatus get status => _status;
  List<Loan> get loans => _loans;
  String? get errorMessage => _errorMessage;

  List<Loan> get activeLoans => _loans.where((l) => l.active).toList();
  List<Loan> get inactiveLoans => _loans.where((l) => !l.active).toList();

  double get totalPending {
    return activeLoans.fold(0, (sum, l) => sum + l.remainingAmount);
  }

  Future<void> loadLoans() async {
    _status = LoansStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _loans = await _getLoansUseCase.execute();
    _status = LoansStatus.success;
    notifyListeners();
  }

  Future<String?> createLoan({
    required String description,
    required double totalValue,
    required int totalInstallments,
    required DateTime startDate,
    double monthlyInterestRate = 0,
  }) async {
    final loan = await _createLoanUseCase.execute(
      description: description,
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      startDate: startDate,
      monthlyInterestRate: monthlyInterestRate,
    );

    if (loan == null) {
      _errorMessage = 'Erro ao criar empréstimo';
      notifyListeners();
      return _errorMessage;
    }

    await loadLoans();
    return null;
  }

  Future<String?> updateLoan({
    required String id,
    String? description,
    double? totalValue,
    int? totalInstallments,
    double? monthlyInterestRate,
    DateTime? startDate,
    bool? active,
  }) async {
    final loan = await _updateLoanUseCase.execute(
      id: id,
      description: description,
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      monthlyInterestRate: monthlyInterestRate,
      startDate: startDate,
      active: active,
    );

    if (loan == null) {
      _errorMessage = 'Erro ao atualizar empréstimo';
      notifyListeners();
      return _errorMessage;
    }

    await loadLoans();
    return null;
  }

  Future<bool> deleteLoan(String id) async {
    final success = await _deleteLoanUseCase.execute(id);
    if (success) await loadLoans();
    return success;
  }
}
