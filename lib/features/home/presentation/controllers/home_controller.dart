import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/entities/salary_cycle.dart';
import '../../domain/usecases/get_monthly_summary_usecase.dart';
import '../../domain/usecases/get_recent_expenses_usecase.dart';
import '../../domain/usecases/get_expense_by_id_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import '../../domain/usecases/get_current_salary_cycle_usecase.dart';
import '../../../fixed_expenses/domain/usecases/get_fixed_expenses_usecase.dart';

enum HomeStatus { initial, loading, success, error }

class HomeController extends ChangeNotifier {
  final GetMonthlySummaryUseCase _getMonthlySummaryUseCase;
  final GetRecentExpensesUseCase _getRecentExpensesUseCase;
  final GetFixedExpensesUseCase _getFixedExpensesUseCase;
  final GetExpenseByIdUseCase _getExpenseByIdUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final GetCurrentSalaryCycleUseCase _getCurrentSalaryCycleUseCase;
  final FlutterSecureStorage _storage;

  HomeStatus _status = HomeStatus.initial;
  MonthlySummary? _summary;
  SalaryCycle? _salaryCycle;
  List<Expense> _expenses = [];
  String? _userName;
  String? _errorMessage;

  HomeController(
    this._getMonthlySummaryUseCase,
    this._getRecentExpensesUseCase,
    this._getFixedExpensesUseCase,
    this._getExpenseByIdUseCase,
    this._deleteExpenseUseCase,
    this._updateExpenseUseCase,
    this._getCurrentSalaryCycleUseCase,
    this._storage,
  );

  HomeStatus get status => _status;
  MonthlySummary? get summary => _summary;
  SalaryCycle? get salaryCycle => _salaryCycle;
  List<Expense> get expenses => _expenses;
  String? get userName => _userName;
  String? get errorMessage => _errorMessage;

  Future<void> loadData({int? month, int? year}) async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _userName = await _storage.read(key: 'user_name');

    final now = DateTime.now();
    final m = month ?? now.month;
    final y = year ?? now.year;

    final summaryResult = await _getMonthlySummaryUseCase.execute(month: m, year: y);
    final expensesResult = await _getRecentExpensesUseCase.execute(month: m, year: y);
    final fixedResult = await _getFixedExpensesUseCase.execute();
    final cycleResult = await _getCurrentSalaryCycleUseCase.execute();

    cycleResult.fold((_) => null, (cycle) => _salaryCycle = cycle);

    summaryResult.fold(
      (error) {
        _status = HomeStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (summary) {
        _summary = summary;
        expensesResult.fold(
          (error) {
            _status = HomeStatus.error;
            _errorMessage = error;
            notifyListeners();
          },
          (expenses) {
            final fixedExpenses = fixedResult.fold(
              (_) => <Expense>[],
              (fixed) => fixed
                  .where((f) => f.active)
                  .map((f) => _fixedToExpense(f, m, y))
                  .toList(),
            );
            final all = [...fixedExpenses, ...expenses];
            all.sort((a, b) => b.date.compareTo(a.date));
            _expenses = all;
            _status = HomeStatus.success;
            notifyListeners();
          },
        );
      },
    );
  }

  Future<Expense?> getExpenseById(String id) async {
    final result = await _getExpenseByIdUseCase.execute(id);
    return result.fold(
      (_) => null,
      (expense) => expense,
    );
  }

  Future<bool> deleteExpense(String id) async {
    final result = await _deleteExpenseUseCase.execute(id);
    return result.fold(
      (_) => false,
      (_) => true,
    );
  }

  Future<bool> updateExpense({
    required String id,
    required String description,
    required double value,
    required String category,
    required String paymentMethod,
    required DateTime date,
    String? cardId,
    int? installments,
  }) async {
    final result = await _updateExpenseUseCase.execute(
      id: id,
      description: description,
      value: value,
      category: category,
      paymentMethod: paymentMethod,
      date: date,
      cardId: cardId,
      installments: installments,
    );
    return result.fold(
      (_) => false,
      (_) => true,
    );
  }

  Expense _fixedToExpense(
    dynamic fixed,
    int month,
    int year,
  ) {
    final day = fixed.dueDay > 28 ? 28 : fixed.dueDay;
    final date = DateTime(year, month, day);
    return Expense(
      id: 'fixed_${fixed.id}',
      description: fixed.description,
      value: fixed.value,
      category: fixed.category,
      paymentMethod: fixed.paymentMethod,
      date: date.toIso8601String().split('T')[0],
    );
  }
}