import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/monthly_summary_model.dart';
import '../widgets/expense_tile.dart';
import '../widgets/expenses_header.dart';
import '../widgets/floating_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static final _fictionalSummary = MonthlySummaryModel(
    monthlyIncome: 5800.00,
    totalExpenses: 2340.50,
    totalFixedExpenses: 1250.00,
    remaining: 2209.50,
    savingsGoalMonthly: 1000.00,
    spendingLimitMonthly: 3000.00,
  );

  static final _fictionalExpenses = [
    const ExpenseModel(
      id: '1',
      description: 'Supermercado Extra',
      value: 487.90,
      category: 'Alimentação',
      paymentMethod: 'Crédito',
      date: '2026-07-21',
    ),
    const ExpenseModel(
      id: '2',
      description: 'Netflix + Spotify',
      value: 63.80,
      category: 'Assinatura',
      paymentMethod: 'Débito',
      date: '2026-07-18',
    ),
    const ExpenseModel(
      id: '3',
      description: 'Posto Ipiranga',
      value: 250.00,
      category: 'Transporte',
      paymentMethod: 'Crédito',
      date: '2026-07-17',
    ),
    const ExpenseModel(
      id: '4',
      description: 'Farmácia Drogasil',
      value: 89.90,
      category: 'Saúde',
      paymentMethod: 'Pix',
      date: '2026-07-15',
    ),
    const ExpenseModel(
      id: '5',
      description: 'iFood - Jantar',
      value: 62.50,
      category: 'Alimentação',
      paymentMethod: 'Pix',
      date: '2026-07-14',
    ),
    const ExpenseModel(
      id: '6',
      description: 'Academia SmartFit',
      value: 129.90,
      category: 'Saúde',
      paymentMethod: 'Débito',
      date: '2026-07-10',
    ),
    const ExpenseModel(
      id: '7',
      description: 'Conta de Luz',
      value: 198.50,
      category: 'Moradia',
      paymentMethod: 'Pix',
      date: '2026-07-08',
    ),
    const ExpenseModel(
      id: '8',
      description: 'Uber',
      value: 34.20,
      category: 'Transporte',
      paymentMethod: 'Crédito',
      date: '2026-07-06',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const _AppDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 26, right: 26, top: 40),
                    child: HomeHeader(
                      greeting: _getGreeting(),
                      userName: 'Lucas',
                      onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      children: [
                        SummaryCard(summary: _fictionalSummary),
                        const SizedBox(height: 36),
                        ExpensesHeader(
                          title: 'Gastos recentes',
                          count: _fictionalExpenses.length,
                          onSeeAll: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Todos os gastos serão exibidos aqui.'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._fictionalExpenses.map(
                          (expense) => ExpenseTile(expense: expense),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomNav(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.verdeEscuro,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.branco,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.home_rounded,
              label: 'Inicio',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.receipt_long_rounded,
              label: 'Gastos',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.pie_chart_rounded,
              label: 'Gráficos',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Sair',
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.verdeDestaque, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.branco,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
