import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/chart_category.dart';
import '../../domain/entities/chart_fixed_vs_variable.dart';
import '../../domain/entities/chart_highest_month.dart';
import '../../domain/entities/chart_monthly_trend.dart';
import '../../domain/entities/chart_payment_method.dart';
import '../../domain/entities/chart_top_expense.dart';
import '../../domain/usecases/get_chart_categories_usecase.dart';
import '../../domain/usecases/get_chart_fixed_vs_variable_usecase.dart';
import '../../domain/usecases/get_chart_highest_month_usecase.dart';
import '../../domain/usecases/get_chart_monthly_trend_usecase.dart';
import '../../domain/usecases/get_chart_payment_methods_usecase.dart';
import '../../domain/usecases/get_chart_top_expenses_usecase.dart';

enum ReportsStatus { initial, loading, success, error }

class ReportsController extends ChangeNotifier {
  final GetChartPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final GetChartCategoriesUseCase _getCategoriesUseCase;
  final GetChartHighestMonthUseCase _getHighestMonthUseCase;
  final GetChartMonthlyTrendUseCase _getMonthlyTrendUseCase;
  final GetChartFixedVsVariableUseCase _getFixedVsVariableUseCase;
  final GetChartTopExpensesUseCase _getTopExpensesUseCase;

  ReportsStatus _status = ReportsStatus.initial;
  String? _errorMessage;

  List<ChartPaymentMethod>? _paymentMethods;
  List<ChartCategory>? _categories;
  ChartHighestMonth? _highestMonth;
  List<ChartMonthlyTrend>? _monthlyTrend;
  ChartFixedVsVariable? _fixedVsVariable;
  List<ChartTopExpense>? _topExpenses;

  ReportsController(
    this._getPaymentMethodsUseCase,
    this._getCategoriesUseCase,
    this._getHighestMonthUseCase,
    this._getMonthlyTrendUseCase,
    this._getFixedVsVariableUseCase,
    this._getTopExpensesUseCase,
  );

  ReportsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<ChartPaymentMethod>? get paymentMethods => _paymentMethods;
  List<ChartCategory>? get categories => _categories;
  ChartHighestMonth? get highestMonth => _highestMonth;
  List<ChartMonthlyTrend>? get monthlyTrend => _monthlyTrend;
  ChartFixedVsVariable? get fixedVsVariable => _fixedVsVariable;
  List<ChartTopExpense>? get topExpenses => _topExpenses;

  Future<void> loadData({int? year}) async {
    _status = ReportsStatus.loading;
    notifyListeners();

    final currentMonth = DateTime.now().month;

    final paymentMethodsResult = _getPaymentMethodsUseCase.execute(year: year, month: currentMonth);
    final categoriesResult = _getCategoriesUseCase.execute(year: year, month: currentMonth);
    final highestMonthResult = _getHighestMonthUseCase.execute(year: year);
    final monthlyTrendResult = _getMonthlyTrendUseCase.execute(year: year);
    final fixedVsVariableResult = _getFixedVsVariableUseCase.execute(year: year, month: currentMonth);
    final topExpensesResult = _getTopExpensesUseCase.execute(year: year, month: currentMonth);

    final results = await Future.wait([
      paymentMethodsResult,
      categoriesResult,
      highestMonthResult,
      monthlyTrendResult,
      fixedVsVariableResult,
      topExpensesResult,
    ]);

    final errors = results.where((r) => r.isLeft()).toList();
    if (errors.isNotEmpty) {
      _status = ReportsStatus.error;
      _errorMessage = errors.first.fold((e) => e, (_) => null);
      notifyListeners();
      return;
    }

    (results[0] as Either<String, List<ChartPaymentMethod>>)
        .fold((_) {}, (r) => _paymentMethods = r);
    (results[1] as Either<String, List<ChartCategory>>)
        .fold((_) {}, (r) => _categories = r);
    (results[2] as Either<String, ChartHighestMonth>)
        .fold((_) {}, (r) => _highestMonth = r);
    (results[3] as Either<String, List<ChartMonthlyTrend>>)
        .fold((_) {}, (r) => _monthlyTrend = r);
    (results[4] as Either<String, ChartFixedVsVariable>)
        .fold((_) {}, (r) => _fixedVsVariable = r);
    (results[5] as Either<String, List<ChartTopExpense>>)
        .fold((_) {}, (r) => _topExpenses = r);

    _status = ReportsStatus.success;
    notifyListeners();
  }
}
