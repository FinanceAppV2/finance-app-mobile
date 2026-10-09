import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/salary_cycle.dart';
import '../../domain/entities/chart_category.dart';
import '../../domain/entities/chart_fixed_vs_variable.dart';
import '../../domain/entities/chart_highest_month.dart';
import '../../domain/entities/chart_monthly_trend.dart';
import '../../domain/entities/chart_payment_method.dart';
import '../../domain/entities/chart_top_expense.dart';
import '../../domain/usecases/generate_ai_usecase.dart';
import '../../domain/usecases/get_chart_categories_usecase.dart';
import '../../domain/usecases/get_chart_fixed_vs_variable_usecase.dart';
import '../../domain/usecases/get_chart_highest_month_usecase.dart';
import '../../domain/usecases/get_chart_monthly_trend_usecase.dart';
import '../../domain/usecases/get_chart_payment_methods_usecase.dart';
import '../../domain/usecases/get_chart_top_expenses_usecase.dart';
import '../../domain/usecases/get_salary_cycle_history_usecase.dart';
import '../../domain/repositories/reports_repository.dart';

enum ReportsStatus { initial, loading, success, error }

class ReportsController extends ChangeNotifier {
  final GetChartPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final GetChartCategoriesUseCase _getCategoriesUseCase;
  final GetChartHighestMonthUseCase _getHighestMonthUseCase;
  final GetChartMonthlyTrendUseCase _getMonthlyTrendUseCase;
  final GetChartFixedVsVariableUseCase _getFixedVsVariableUseCase;
  final GetChartTopExpensesUseCase _getTopExpensesUseCase;
  final GetSalaryCycleHistoryUseCase _getSalaryCycleHistoryUseCase;
  final GenerateAiUseCase _generateAiUseCase;
  final ReportsRepository _repository;

  ReportsStatus _status = ReportsStatus.initial;
  bool _isGeneratingAi = false;
  String? _errorMessage;

  List<ChartPaymentMethod>? _paymentMethods;
  List<ChartCategory>? _categories;
  ChartHighestMonth? _highestMonth;
  List<ChartMonthlyTrend>? _monthlyTrend;
  ChartFixedVsVariable? _fixedVsVariable;
  List<ChartTopExpense>? _topExpenses;
  List<SalaryCycle>? _salaryCycleHistory;

  ReportsController(
    this._getPaymentMethodsUseCase,
    this._getCategoriesUseCase,
    this._getHighestMonthUseCase,
    this._getMonthlyTrendUseCase,
    this._getFixedVsVariableUseCase,
    this._getTopExpensesUseCase,
    this._getSalaryCycleHistoryUseCase,
    this._generateAiUseCase,
    this._repository,
  );

  ReportsStatus get status => _status;
  bool get isGeneratingAi => _isGeneratingAi;
  String? get errorMessage => _errorMessage;
  List<ChartPaymentMethod>? get paymentMethods => _paymentMethods;
  List<ChartCategory>? get categories => _categories;
  ChartHighestMonth? get highestMonth => _highestMonth;
  List<ChartMonthlyTrend>? get monthlyTrend => _monthlyTrend;
  ChartFixedVsVariable? get fixedVsVariable => _fixedVsVariable;
  List<ChartTopExpense>? get topExpenses => _topExpenses;
  List<SalaryCycle>? get salaryCycleHistory => _salaryCycleHistory;

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
    final salaryCycleHistoryResult = _getSalaryCycleHistoryUseCase.execute(limit: 6);

    final results = await Future.wait([
      paymentMethodsResult,
      categoriesResult,
      highestMonthResult,
      monthlyTrendResult,
      fixedVsVariableResult,
      topExpensesResult,
    ]);

    final cycleHistory = await salaryCycleHistoryResult;
    cycleHistory.fold((_) => null, (history) => _salaryCycleHistory = history);

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

  void _appendSummary(Map<String, double> summary, StringBuffer buffer) {
    buffer.writeln('- Renda mensal: R\$ ${summary['monthlyIncome']!.toStringAsFixed(2)}');
    buffer.writeln('- Total despesas: R\$ ${summary['totalExpenses']!.toStringAsFixed(2)}');
    buffer.writeln('- Despesas fixas: R\$ ${summary['totalFixedExpenses']!.toStringAsFixed(2)}');
    buffer.writeln('- Restante: R\$ ${summary['remaining']!.toStringAsFixed(2)}');
    buffer.writeln('- Meta de poupança: R\$ ${summary['savingsGoalMonthly']!.toStringAsFixed(2)}');
    buffer.writeln('- Limite de gastos: R\$ ${summary['spendingLimitMonthly']!.toStringAsFixed(2)}');
  }

  String _buildContextPrompt() {
    final buffer = StringBuffer('### Dados financeiros do usuário:\n');
    if (_fixedVsVariable != null) {
      buffer.writeln(
        '- Despesas fixas: R\$ ${_fixedVsVariable!.fixedTotal.toStringAsFixed(2)}, '
        'Variáveis: R\$ ${_fixedVsVariable!.variableTotal.toStringAsFixed(2)}',
      );
    }
    if (_monthlyTrend != null && _monthlyTrend!.isNotEmpty) {
      buffer.writeln('- Tendência mensal: ${_monthlyTrend!.map((m) => 'Mês ${m.month}: R\$ ${m.total.toStringAsFixed(2)}').join(', ')}');
    }
    if (_topExpenses != null && _topExpenses!.isNotEmpty) {
      buffer.writeln('- Maiores despesas: ${_topExpenses!.map((e) => '${e.description} (R\$ ${e.value.toStringAsFixed(2)})').join(', ')}');
    }
    if (_categories != null && _categories!.isNotEmpty) {
      buffer.writeln('- Gastos por categoria: ${_categories!.map((c) => '${c.category}: R\$ ${c.total.toStringAsFixed(2)}').join(', ')}');
    }
    if (_paymentMethods != null && _paymentMethods!.isNotEmpty) {
      buffer.writeln('- Gastos por pagamento: ${_paymentMethods!.map((p) => '${p.paymentMethod}: R\$ ${p.total.toStringAsFixed(2)}').join(', ')}');
    }
    if (_highestMonth != null) {
      buffer.writeln('- Mês com maior gasto: ${_highestMonth!.month}/${_highestMonth!.year} (R\$ ${_highestMonth!.total.toStringAsFixed(2)})');
    }
    if (_salaryCycleHistory != null && _salaryCycleHistory!.isNotEmpty) {
      buffer.writeln('### Ciclos salariais recentes:');
      for (final cycle in _salaryCycleHistory!) {
        buffer.writeln(
          '- ${cycle.label}: Renda R\$ ${cycle.monthlyIncome.toStringAsFixed(2)}, '
          'Comprometido: R\$ ${cycle.committed.toStringAsFixed(2)}, '
          'Disponível: R\$ ${cycle.available.toStringAsFixed(2)}, '
          'Status: ${cycle.status.name.toUpperCase()}',
        );
      }
    }
    return buffer.toString();
  }

  Future<String?> generateAi({
    required String message,
    required bool includeReportsData,
  }) async {
    _isGeneratingAi = true;
    notifyListeners();

    final prompt = StringBuffer();
    if (includeReportsData) {
      prompt.writeln(_buildContextPrompt());
      prompt.writeln();

      final summaryResult = await _repository.getMonthlySummary();
      summaryResult.fold(
        (_) {},
        (summary) {
          prompt.writeln('### Resumo financeiro do mês:');
          _appendSummary(summary, prompt);
          prompt.writeln();
        },
      );
    }
    prompt.writeln('### Pergunta do usuário:');
    prompt.write(message);

    final result = await _generateAiUseCase.execute(prompt: prompt.toString());

    _isGeneratingAi = false;
    notifyListeners();

    return result.fold(
      (error) {
        _errorMessage = error;
        return null;
      },
      (response) => response,
    );
  }
}
