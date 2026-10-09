import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../main.dart';
import '../../../cards/presentation/pages/cards_page.dart';
import '../../../expenses/presentation/widgets/add_expense_sheet.dart';
import '../../../fixed_expenses/presentation/pages/fixed_expenses_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../domain/entities/expense.dart';
import '../controllers/home_controller.dart';
import '../widgets/edit_expense_sheet.dart';
import '../widgets/expense_tile.dart';
import '../widgets/expenses_header.dart';
import '../widgets/floating_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/daily_budget_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/salary_cycle_card.dart';
import '../widgets/summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = GetIt.instance<HomeController>();
  int _selectedIndex = 0;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String? _selectedCategory;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadData(month: _selectedMonth, year: _selectedYear);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  void didPopNext() {
    _controller.loadData(month: _selectedMonth, year: _selectedYear);
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        selectedMonth: _selectedMonth,
        selectedYear: _selectedYear,
        selectedCategory: _selectedCategory,
        selectedPaymentMethod: _selectedPaymentMethod,
      ),
    ).then((result) {
      if (result is FilterResult) {
        setState(() {
          _selectedMonth = result.month;
          _selectedYear = result.year;
          _selectedCategory = result.category;
          _selectedPaymentMethod = result.paymentMethod;
        });
        _controller.loadData(
          month: _selectedMonth,
          year: _selectedYear,
        );
      }
    });
  }

  void _onAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    ).then((result) {
      if (result == true) {
        _controller.loadData(month: _selectedMonth, year: _selectedYear);
      }
    });
  }

  void _onEditExpense(Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditExpenseSheet(expense: expense),
    ).then((result) {
      if (result == true) {
        _controller.loadData(month: _selectedMonth, year: _selectedYear);
      }
    });
  }

  Future<void> _onDeleteExpense(Expense expense) async {
    final installments = expense.installments ?? 1;
    final message = installments > 1
        ? 'Deseja excluir "${expense.description}"?\n\n'
            'Esta compra é parcelada em ${installments}x. '
            'Todas as parcelas serão excluídas.'
        : 'Deseja excluir "${expense.description}"?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.superficie,
        title: const Text('Excluir despesa', style: TextStyle(color: AppColors.marfim)),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.cinza),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.cinza)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final success = await _controller.deleteExpense(expense.id);

    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Despesa excluída com sucesso!' : 'Erro ao excluir despesa',
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );

    if (success) {
      _controller.loadData(month: _selectedMonth, year: _selectedYear);
    }
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
                      AppColors.latao,
                      AppColors.superficie,
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
                        onReload: () => _controller.loadData(
                          month: _selectedMonth,
                          year: _selectedYear,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
      return const ShimmerLoading(child: SkeletonScreen());
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
              style: const TextStyle(color: AppColors.cinza),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _controller.loadData(month: _selectedMonth, year: _selectedYear),
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
            if (_controller.salaryCycle != null) ...[
              const SizedBox(height: 14),
              SalaryCycleCard(cycle: _controller.salaryCycle!),
              const SizedBox(height: 14),
              DailyBudgetCard(cycle: _controller.salaryCycle!),
            ],
            const SizedBox(height: 36),
            ExpensesHeader(
              title: 'Gastos do mês',
              count: _filteredExpenses.length,
              onFilter: _openFilterSheet,
            ),
            const SizedBox(height: 8),
            ..._filteredExpenses.map(
              (expense) {
                final isFixed = expense.id.startsWith('fixed_');
                final isEditable = !isFixed && !expense.isLoanInstallment;
                return ExpenseTile(
                  expense: expense,
                  isFixed: isFixed,
                  onEdit: isEditable ? () => _onEditExpense(expense) : null,
                  onDelete: isEditable ? () => _onDeleteExpense(expense) : null,
                );
              },
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  List<Expense> get _filteredExpenses {
    var expenses = _controller.expenses;
    if (_selectedCategory != null) {
      expenses = expenses
          .where((e) => e.category == _selectedCategory)
          .toList();
    }
    if (_selectedPaymentMethod != null) {
      expenses = expenses
          .where((e) => e.paymentMethod == _selectedPaymentMethod)
          .toList();
    }
    return expenses;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}

class _AppDrawer extends StatefulWidget {
  const _AppDrawer();

  @override
  State<_AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<_AppDrawer> with SingleTickerProviderStateMixin {
  String _name = '';
  String _email = '';
  String _lastName = '';
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _loadUser();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    const storage = FlutterSecureStorage();
    final name = await storage.read(key: 'user_name') ?? '';
    final lastName = await storage.read(key: 'user_lastName') ?? '';
    final email = await storage.read(key: 'user_email') ?? '';
    if (mounted) setState(() { _name = name; _lastName = lastName; _email = email; });
  }

  String get _initial {
    if (_name.isEmpty) return '?';
    return _name[0].toUpperCase();
  }

  String get _displayName {
    if (_name.isEmpty) return 'Usuário';
    if (_lastName.isEmpty) return _name;
    return '$_name $_lastName';
  }

  Future<bool> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.elevado,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sair', style: TextStyle(color: AppColors.marfim)),
        content: const Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: AppColors.marfim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.cinza),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _navigateTo(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.latao,
              AppColors.superficie,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                ClipPath(
                  clipper: _DrawerHeaderClipper(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.latao,
                          AppColors.latao,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.marfim, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.superficie.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.background.withValues(alpha: 0.35),
                            child: Text(
                              _initial,
                              style: const TextStyle(
                                color: AppColors.marfim,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _displayName,
                          style: const TextStyle(
                            color: AppColors.marfim,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: const TextStyle(
                            color: AppColors.marfim,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      children: [
                        _DrawerItem(
                          icon: Icons.home_rounded,
                          label: 'Início',
                          onTap: () => Navigator.pop(context),
                        ),
                        _DrawerItem(
                          icon: Icons.account_balance_rounded,
                          label: 'Patrimônios',
                          onTap: () => _navigateTo('/patrimony'),
                        ),
                        _DrawerItem(
                          icon: Icons.handshake_rounded,
                          label: 'Empréstimos',
                          onTap: () => _navigateTo('/loans'),
                        ),
                        const Spacer(),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: AppColors.marfim.withValues(alpha: 0.08),
                        ),
                        _DrawerItem(
                          icon: Icons.settings_rounded,
                          label: 'Configurações',
                          onTap: () => _navigateTo('/settings'),
                        ),
                        _DrawerItem(
                          icon: Icons.logout_rounded,
                          label: 'Sair',
                          iconColor: AppColors.error,
                          labelColor: AppColors.error,
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            final confirm = await _confirmLogout();
                            if (confirm && mounted) {
                              const FlutterSecureStorage().deleteAll();
                              navigator.pushReplacementNamed('/login');
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? AppColors.lataoClaro;
    final tc = labelColor ?? AppColors.marfim;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ic.withValues(alpha: 0.15), width: 0.5),
            ),
            child: Row(
              children: [
                Icon(icon, color: ic, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: tc,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: ic.withValues(alpha: 0.4), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 28)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height,
        size.width * 0.5,
        size.height - 12,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height - 24,
        size.width,
        size.height - 8,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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