import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../cards/presentation/pages/cards_page.dart';
import '../../../expenses/presentation/widgets/add_expense_sheet.dart';
import '../../../fixed_expenses/presentation/pages/fixed_expenses_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../controllers/home_controller.dart';
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
  final _controller = GetIt.instance<HomeController>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    ).then((result) {
      if (result == true) {
        _controller.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const _AppDrawer(),
      body: Stack(
        children: [
          if (_selectedIndex == 0)
            ClipPath(
              clipper: _HeaderClipper(),
              child: Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.verdeMedio,
                      AppColors.verdeEscuro,
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          Column(
            children: [
              if (_selectedIndex == 0) ...[
                const SizedBox(height: 20),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 26, right: 26, top: 40),
                      child: HomeHeader(
                        greeting: _getGreeting(),
                        userName: _controller.userName ?? '',
                        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Expanded(
                child: _buildBody(),
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
              onAddTapped: _onAddExpense,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const CardsPage();
      case 3:
        return const FixedExpensesPage();
      case 4:
        return const ReportsPage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    if (_controller.status == HomeStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }

    if (_controller.status == HomeStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar dados',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadData(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          children: [
            if (_controller.summary != null)
              SummaryCard(summary: _controller.summary!),
            const SizedBox(height: 36),
            ExpensesHeader(
              title: 'Gastos recentes',
              count: _controller.expenses.length,
              onSeeAll: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os gastos serão exibidos aqui.'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._controller.expenses.map(
              (expense) => ExpenseTile(expense: expense),
            ),
            const SizedBox(height: 120),
          ],
        ),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
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

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}