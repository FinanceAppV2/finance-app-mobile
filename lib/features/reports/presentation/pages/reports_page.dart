import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/reports_controller.dart';
import '../widgets/ai_chat_sheet.dart';
import '../widgets/categories_card.dart';
import '../widgets/fixed_vs_variable_card.dart';
import '../widgets/highest_month_card.dart';
import '../widgets/monthly_trend_card.dart';
import '../widgets/payment_methods_card.dart';
import '../widgets/salary_cycle_history_card.dart';
import '../widgets/top_expenses_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _controller = GetIt.instance<ReportsController>();
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    _controller.loadData(year: _selectedYear);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
      _controller.loadData(year: _selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeaderRow(),
            const SizedBox(height: 12),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _changeYear(-1),
                icon: const Icon(Icons.chevron_left, color: AppColors.cinzaClaro),
              ),
              const SizedBox(width: 4),
              Text(
                '$_selectedYear',
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => _changeYear(1),
                icon: const Icon(Icons.chevron_right, color: AppColors.cinzaClaro),
              ),
            ],
          ),
          IconButton(
            onPressed: _onOpenAi,
            icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.verdeDestaque),
            tooltip: 'Assistente IA',
          ),
        ],
      ),
    );
  }

  void _onOpenAi() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiChatSheet(),
    );
  }

  Widget _buildBody() {
    if (_controller.status == ReportsStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }

    if (_controller.status == ReportsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar relatórios',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadData(year: _selectedYear),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      children: [
        if (_controller.fixedVsVariable != null)
          FixedVsVariableCard(data: _controller.fixedVsVariable!),
        const SizedBox(height: 16),
        if (_controller.monthlyTrend != null && _controller.monthlyTrend!.isNotEmpty)
          MonthlyTrendCard(data: _controller.monthlyTrend!),
        const SizedBox(height: 16),
        if (_controller.topExpenses != null && _controller.topExpenses!.isNotEmpty)
          TopExpensesCard(data: _controller.topExpenses!),
        const SizedBox(height: 16),
        if (_controller.categories != null && _controller.categories!.isNotEmpty)
          CategoriesCard(data: _controller.categories!),
        const SizedBox(height: 16),
        if (_controller.paymentMethods != null && _controller.paymentMethods!.isNotEmpty)
          PaymentMethodsCard(data: _controller.paymentMethods!),
        const SizedBox(height: 16),
        if (_controller.highestMonth != null)
          HighestMonthCard(data: _controller.highestMonth!),
        if (_controller.salaryCycleHistory != null &&
            _controller.salaryCycleHistory!.isNotEmpty) ...[
          const SizedBox(height: 16),
          SalaryCycleHistoryCard(cycles: _controller.salaryCycleHistory!),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
