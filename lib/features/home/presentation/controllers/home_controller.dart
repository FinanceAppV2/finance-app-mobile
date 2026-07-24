import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/usecases/get_monthly_summary_usecase.dart';
import '../../domain/usecases/get_recent_expenses_usecase.dart';

enum HomeStatus { initial, loading, success, error }

class HomeController extends ChangeNotifier {
  final GetMonthlySummaryUseCase _getMonthlySummaryUseCase;
  final GetRecentExpensesUseCase _getRecentExpensesUseCase;
  final FlutterSecureStorage _storage;

  HomeStatus _status = HomeStatus.initial;
  MonthlySummary? _summary;
  List<Expense> _expenses = [];
  String? _userName;
  String? _errorMessage;

  HomeController(
    this._getMonthlySummaryUseCase,
    this._getRecentExpensesUseCase,
    this._storage,
  );

  HomeStatus get status => _status;
  MonthlySummary? get summary => _summary;
  List<Expense> get expenses => _expenses;
  String? get userName => _userName;
  String? get errorMessage => _errorMessage;

  Future<void> loadData({int? month, int? year}) async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _userName = await _storage.read(key: 'user_name');

    final summaryResult = await _getMonthlySummaryUseCase.execute(month: month, year: year);
    final expensesResult = await _getRecentExpensesUseCase.execute(month: month, year: year);

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
            _expenses = expenses;
            _status = HomeStatus.success;
            notifyListeners();
          },
        );
      },
    );
  }
}