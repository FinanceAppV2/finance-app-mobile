import 'package:flutter/material.dart';

import '../../domain/entities/fixed_expense.dart';
import '../../domain/usecases/create_fixed_expense_usecase.dart';
import '../../domain/usecases/get_fixed_expenses_usecase.dart';

enum FixedExpensesStatus { initial, loading, success, error }

class FixedExpensesController extends ChangeNotifier {
  final GetFixedExpensesUseCase _getFixedExpensesUseCase;
  final CreateFixedExpenseUseCase _createFixedExpenseUseCase;

  FixedExpensesStatus _status = FixedExpensesStatus.initial;
  List<FixedExpense> _fixedExpenses = [];
  String? _errorMessage;

  FixedExpensesController(
    this._getFixedExpensesUseCase,
    this._createFixedExpenseUseCase,
  );

  FixedExpensesStatus get status => _status;
  List<FixedExpense> get fixedExpenses => _fixedExpenses;
  String? get errorMessage => _errorMessage;

  Future<void> loadFixedExpenses() async {
    _status = FixedExpensesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getFixedExpensesUseCase.execute();

    result.fold(
      (error) {
        _status = FixedExpensesStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (fixedExpenses) {
        _fixedExpenses = fixedExpenses;
        _status = FixedExpensesStatus.success;
        notifyListeners();
      },
    );
  }

  Future<void> createFixedExpense({
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required int dueDay,
    String? cardId,
  }) async {
    _status = FixedExpensesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _createFixedExpenseUseCase.execute(
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      dueDay: dueDay,
      cardId: cardId,
    );

    result.fold(
      (error) {
        _status = FixedExpensesStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (_) {
        loadFixedExpenses();
      },
    );
  }
}
