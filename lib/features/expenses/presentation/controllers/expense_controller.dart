import 'package:flutter/material.dart';

import '../../domain/usecases/create_expense_usecase.dart';

enum ExpenseStatus { initial, loading, success, error }

class ExpenseController extends ChangeNotifier {
  final CreateExpenseUseCase _createExpenseUseCase;

  ExpenseStatus _status = ExpenseStatus.initial;
  String? _errorMessage;

  ExpenseController(this._createExpenseUseCase);

  ExpenseStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> createExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) async {
    _status = ExpenseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _createExpenseUseCase.execute(
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      date: date,
      cardId: cardId,
      installments: installments,
    );

    result.fold(
      (error) {
        _status = ExpenseStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (_) {
        _status = ExpenseStatus.success;
        notifyListeners();
      },
    );
  }

  void reset() {
    _status = ExpenseStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
