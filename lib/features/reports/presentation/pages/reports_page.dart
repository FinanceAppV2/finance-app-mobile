import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/chart_category.dart';
import '../../domain/entities/chart_fixed_vs_variable.dart';
import '../../domain/entities/chart_highest_month.dart';
import '../../domain/entities/chart_monthly_trend.dart';
import '../../domain/entities/chart_payment_method.dart';
import '../../domain/entities/chart_top_expense.dart';
import '../controllers/reports_controller.dart';

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
            const SizedBox(height: 20),
            _buildYearSelector(),
            const SizedBox(height: 12),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _changeYear(-1),
          icon: const Icon(Icons.chevron_left, color: AppColors.cinzaClaro),
        ),
        const SizedBox(width: 8),
        Text(
          '$_selectedYear',
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _changeYear(1),
          icon: const Icon(Icons.chevron_right, color: AppColors.cinzaClaro),
        ),
      ],
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
          _FixedVsVariableCard(data: _controller.fixedVsVariable!),
        const SizedBox(height: 16),
        if (_controller.monthlyTrend != null && _controller.monthlyTrend!.isNotEmpty)
          _MonthlyTrendCard(data: _controller.monthlyTrend!),
        const SizedBox(height: 16),
        if (_controller.topExpenses != null && _controller.topExpenses!.isNotEmpty)
          _TopExpensesCard(data: _controller.topExpenses!),
        const SizedBox(height: 16),
        if (_controller.categories != null && _controller.categories!.isNotEmpty)
          _CategoriesCard(data: _controller.categories!),
        const SizedBox(height: 16),
        if (_controller.paymentMethods != null && _controller.paymentMethods!.isNotEmpty)
          _PaymentMethodsCard(data: _controller.paymentMethods!),
        const SizedBox(height: 16),
        if (_controller.highestMonth != null)
          _HighestMonthCard(data: _controller.highestMonth!),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.verdeMedio),
        color: AppColors.verdeEscuro.withValues(alpha: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.verdeDestaque,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FixedVsVariableCard extends StatelessWidget {
  final ChartFixedVsVariable data;
  const _FixedVsVariableCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Fixas vs Variáveis',
      child: Column(
        children: [
          _ProgressRow(
            label: 'Fixas',
            value: data.fixedTotal,
            percentage: data.fixedPercentage,
            color: AppColors.verdeDestaque,
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: 'Variáveis',
            value: data.variableTotal,
            percentage: data.variablePercentage,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    final pct = percentage.toStringAsFixed(0);
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.branco, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: AppColors.cinzaEscuro,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            'R\$ $formatted ($pct%)',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _MonthlyTrendCard extends StatelessWidget {
  final List<ChartMonthlyTrend> data;
  const _MonthlyTrendCard({required this.data});

  static const _monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  @override
  Widget build(BuildContext context) {
    final maxTotal = data.fold<double>(0, (max, d) => d.total > max ? d.total : max);
    final maxBar = maxTotal > 0 ? maxTotal : 1;

    return _SectionCard(
      title: 'Evolução Mensal',
      child: Column(
        children: data.map((d) {
          final fraction = d.total / maxBar;
          final formatted = d.total.toStringAsFixed(2).replaceAll('.', ',');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    _monthNames[d.month - 1],
                    style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 8,
                      backgroundColor: AppColors.cinzaEscuro,
                      valueColor: const AlwaysStoppedAnimation(AppColors.verdeMedio),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    'R\$ $formatted',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TopExpensesCard extends StatelessWidget {
  final List<ChartTopExpense> data;
  const _TopExpensesCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Maiores Despesas',
      child: Column(
        children: data.map((e) {
          final formatted = e.value.toStringAsFixed(2).replaceAll('.', ',');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.branco, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'R\$ $formatted',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoriesCard extends StatelessWidget {
  final List<ChartCategory> data;
  const _CategoriesCard({required this.data});

  static const _categoryColors = {
    'FOOD': Color(0xFFFF7043),
    'TRANSPORT': Color(0xFF42A5F5),
    'HOUSING': Color(0xFFAB47BC),
    'HEALTH': Color(0xFFEF5350),
    'EDUCATION': Color(0xFFFFA726),
    'LEISURE': Color(0xFF66BB6A),
    'CLOTHING': Color(0xFFEC407A),
    'SERVICES': Color(0xFF26C6DA),
    'TAXES': Color(0xFF8D6E63),
    'INVESTMENTS': Color(0xFF7E57C2),
    'OTHERS': Color(0xFF78909C),
  };

  @override
  Widget build(BuildContext context) {
    final maxTotal = data.fold<double>(0, (max, d) => d.total > max ? d.total : max);
    final maxBar = maxTotal > 0 ? maxTotal : 1;

    return _SectionCard(
      title: 'Gastos por Categoria',
      child: Column(
        children: data.map((c) {
          final color = _categoryColors[c.category] ?? AppColors.cinzaClaro;
          final formatted = c.total.toStringAsFixed(2).replaceAll('.', ',');
          final pct = c.percentage.toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          c.category,
                          style: const TextStyle(color: AppColors.branco, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      'R\$ $formatted ($pct%)',
                      style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: c.total / maxBar,
                    minHeight: 6,
                    backgroundColor: AppColors.cinzaEscuro,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  final List<ChartPaymentMethod> data;
  const _PaymentMethodsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Gastos por Pagamento',
      child: Column(
        children: data.map((p) {
          final formatted = p.total.toStringAsFixed(2).replaceAll('.', ',');
          final pct = p.percentage.toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.paymentMethod,
                    style: const TextStyle(color: AppColors.branco, fontSize: 13),
                  ),
                ),
                Text(
                  'R\$ $formatted',
                  style: const TextStyle(color: AppColors.cinzaClaro, fontSize: 12),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.verdeDestaque,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HighestMonthCard extends StatelessWidget {
  final ChartHighestMonth data;
  const _HighestMonthCard({required this.data});

  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    final formatted = data.total.toStringAsFixed(2).replaceAll('.', ',');
    return _SectionCard(
      title: 'Mês de Maior Gasto',
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
          const SizedBox(width: 10),
          Text(
            '${_monthNames[data.month - 1]}/${data.year}',
            style: const TextStyle(color: AppColors.branco, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            'R\$ $formatted',
            style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
