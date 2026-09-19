import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/formatters/currency_input_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../presentation/controllers/finance_config_controller.dart';

class FinanceConfigPage extends StatefulWidget {
  const FinanceConfigPage({super.key});

  @override
  State<FinanceConfigPage> createState() => _FinanceConfigPageState();
}

class _FinanceConfigPageState extends State<FinanceConfigPage> {
  final _controller = GetIt.instance<FinanceConfigController>();
  final _postpaidFormKey = GlobalKey<FormState>();
  final _prepaidFormKey = GlobalKey<FormState>();

  // Postpaid controllers (Page 0)
  late TextEditingController _postpaidIncomeController;
  late TextEditingController _postpaidLimitController;
  late TextEditingController _postpaidSavingsController;
  late TextEditingController _postpaidEmergencyFundController;
  late TextEditingController _postpaidSalaryDayController;
  late TextEditingController _postpaidClosingDayController;

  // Prepaid controllers (Page 1)
  late TextEditingController _prepaidIncomeController;
  late TextEditingController _prepaidLimitController;
  late TextEditingController _prepaidSavingsController;
  late TextEditingController _prepaidEmergencyFundController;
  late TextEditingController _prepaidSalaryDayController;

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _postpaidIncomeController = TextEditingController();
    _postpaidLimitController = TextEditingController();
    _postpaidSavingsController = TextEditingController();
    _postpaidEmergencyFundController = TextEditingController();
    _postpaidSalaryDayController = TextEditingController();
    _postpaidClosingDayController = TextEditingController();

    _prepaidIncomeController = TextEditingController();
    _prepaidLimitController = TextEditingController();
    _prepaidSavingsController = TextEditingController();
    _prepaidEmergencyFundController = TextEditingController();
    _prepaidSalaryDayController = TextEditingController();

    _pageController = PageController(initialPage: 0);
    _controller.addListener(_onStateChanged);
    _controller.loadConfig();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _postpaidIncomeController.dispose();
    _postpaidLimitController.dispose();
    _postpaidSavingsController.dispose();
    _postpaidEmergencyFundController.dispose();
    _postpaidSalaryDayController.dispose();
    _postpaidClosingDayController.dispose();

    _prepaidIncomeController.dispose();
    _prepaidLimitController.dispose();
    _prepaidSavingsController.dispose();
    _prepaidEmergencyFundController.dispose();
    _prepaidSalaryDayController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    if (_controller.status == FinanceConfigStatus.success &&
        _controller.config != null) {
      final config = _controller.config!;
      final income = CurrencyInputFormatter.format(config.monthlyIncome);
      final limit = CurrencyInputFormatter.format(config.spendingLimit);
      final savings = CurrencyInputFormatter.format(config.savingsGoal);
      final emergency =
          CurrencyInputFormatter.format(config.emergencyFundGoal);
      final salary = config.salaryDay?.toString() ?? '';
      final closing = config.paymentDay?.toString() ?? '';

      // Set postpaid
      if (_postpaidIncomeController.text.isEmpty) _postpaidIncomeController.text = income;
      if (_postpaidLimitController.text.isEmpty) _postpaidLimitController.text = limit;
      if (_postpaidSavingsController.text.isEmpty) _postpaidSavingsController.text = savings;
      if (_postpaidEmergencyFundController.text.isEmpty) _postpaidEmergencyFundController.text = emergency;
      if (_postpaidSalaryDayController.text.isEmpty) _postpaidSalaryDayController.text = salary;
      if (_postpaidClosingDayController.text.isEmpty) _postpaidClosingDayController.text = closing;

      // Set prepaid
      if (_prepaidIncomeController.text.isEmpty) _prepaidIncomeController.text = income;
      if (_prepaidLimitController.text.isEmpty) _prepaidLimitController.text = limit;
      if (_prepaidSavingsController.text.isEmpty) _prepaidSavingsController.text = savings;
      if (_prepaidEmergencyFundController.text.isEmpty) _prepaidEmergencyFundController.text = emergency;
      if (_prepaidSalaryDayController.text.isEmpty) _prepaidSalaryDayController.text = salary;

      final targetPage = config.type == 'PREPAID' ? 1 : 0;
      if (_currentPage != targetPage) {
        _currentPage = targetPage;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(targetPage);
        }
      }
    }
    setState(() {});
  }

  void _onPageChanged(int index) {
    setState(() {
      if (index == 0 && _currentPage == 1) {
        // Sync values from prepaid to postpaid
        _postpaidIncomeController.text = _prepaidIncomeController.text;
        _postpaidLimitController.text = _prepaidLimitController.text;
        _postpaidSavingsController.text = _prepaidSavingsController.text;
        _postpaidEmergencyFundController.text = _prepaidEmergencyFundController.text;
        _postpaidSalaryDayController.text = _prepaidSalaryDayController.text;
      } else if (index == 1 && _currentPage == 0) {
        // Sync values from postpaid to prepaid
        _prepaidIncomeController.text = _postpaidIncomeController.text;
        _prepaidLimitController.text = _postpaidLimitController.text;
        _prepaidSavingsController.text = _postpaidSavingsController.text;
        _prepaidEmergencyFundController.text = _postpaidEmergencyFundController.text;
        _prepaidSalaryDayController.text = _postpaidSalaryDayController.text;
      }
      _currentPage = index;
    });
  }

  void _selectPage(int index) {
    if (_currentPage == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Configuração Financeira')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_controller.status) {
      case FinanceConfigStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.verdeDestaque),
        );
      case FinanceConfigStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.error.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.errorMessage ?? 'Erro desconhecido',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.cinzaClaro,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _controller.loadConfig(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        );
      case FinanceConfigStatus.initial:
      case FinanceConfigStatus.success:
        return _buildContent();
    }
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildModeSelectorTabs(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe_rounded,
                  size: 14,
                  color: AppColors.cinzaClaro.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Deslize para o lado para alternar o modo',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildPostpaidCard(),
                _buildPrepaidCard(),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildModeSelectorTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.verdeEscuro.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.verdeMedio.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              title: 'Pós-pago',
              icon: Icons.credit_card_rounded,
              index: 0,
            ),
          ),
          Expanded(
            child: _buildTabItem(
              title: 'Pré-pago',
              icon: Icons.account_balance_wallet_rounded,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () => _selectPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.verdeDestaque : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.background : AppColors.cinzaClaro,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.background : AppColors.branco,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostpaidCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.verdeEscuro,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _currentPage == 0
                ? AppColors.verdeDestaque
                : AppColors.verdeMedio.withValues(alpha: 0.4),
            width: _currentPage == 0 ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.verdeDestaque.withValues(
                alpha: _currentPage == 0 ? 0.12 : 0.03,
              ),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _postpaidFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(
                icon: Icons.credit_card_rounded,
                title: 'Modo Pós-pago',
                badgeText: 'Cartão / Faturas',
                description:
                    'Acumule despesas no ciclo e controle o fechamento das contas.',
              ),
              const SizedBox(height: 16),
              Divider(
                color: AppColors.cinzaEscuro.withValues(alpha: 0.3),
                height: 1,
              ),
              const SizedBox(height: 20),
              _buildFormField(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Renda mensal',
                hint: 'Ex: 5000',
                controller: _postpaidIncomeController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.money_off_rounded,
                label: 'Limite de gastos',
                hint: 'Ex: 3000',
                controller: _postpaidLimitController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.savings_rounded,
                label: 'Meta de economia',
                hint: 'Ex: 1000',
                controller: _postpaidSavingsController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.safety_check_rounded,
                label: 'Reserva de emergência',
                hint: 'Ex: 5000',
                controller: _postpaidEmergencyFundController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildDayField(
                icon: Icons.event_available_rounded,
                label: 'Dia do recebimento de salário',
                hint: 'Dia do mês (1-31)',
                controller: _postpaidSalaryDayController,
                isRequired: false,
              ),
              const SizedBox(height: 18),
              _buildDayField(
                icon: Icons.calendar_month_rounded,
                label: 'Dia de fechamento das contas',
                hint: 'Dia do mês (1-31)',
                controller: _postpaidClosingDayController,
                isRequired: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrepaidCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.verdeEscuro,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _currentPage == 1
                ? AppColors.verdeDestaque
                : AppColors.verdeMedio.withValues(alpha: 0.4),
            width: _currentPage == 1 ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.verdeDestaque.withValues(
                alpha: _currentPage == 1 ? 0.12 : 0.03,
              ),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _prepaidFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Modo Pré-pago',
                badgeText: 'Débito / Pix / Dinheiro',
                description:
                    'Controle seus gastos com base no saldo atual disponível.',
              ),
              const SizedBox(height: 16),
              Divider(
                color: AppColors.cinzaEscuro.withValues(alpha: 0.3),
                height: 1,
              ),
              const SizedBox(height: 20),
              _buildFormField(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Renda mensal',
                hint: 'Ex: 5000',
                controller: _prepaidIncomeController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.money_off_rounded,
                label: 'Limite de gastos',
                hint: 'Ex: 3000',
                controller: _prepaidLimitController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.savings_rounded,
                label: 'Meta de economia',
                hint: 'Ex: 1000',
                controller: _prepaidSavingsController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildFormField(
                icon: Icons.safety_check_rounded,
                label: 'Reserva de emergência',
                hint: 'Ex: 5000',
                controller: _prepaidEmergencyFundController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 18),
              _buildDayField(
                icon: Icons.event_available_rounded,
                label: 'Dia do recebimento de salário',
                hint: 'Dia do mês (1-31)',
                controller: _prepaidSalaryDayController,
                isRequired: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String badgeText,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.verdeDestaque.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.verdeDestaque,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: AppColors.verdeDestaque,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.9),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required String prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.verdeDestaque, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [CurrencyInputFormatter()],
          style: const TextStyle(color: AppColors.branco, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            prefixStyle: TextStyle(
              color: AppColors.verdeDestaque.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Preencha este campo';
            }
            if (CurrencyInputFormatter.parse(value) < 0) {
              return 'Insira um valor válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDayField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.verdeDestaque, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.branco, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Preencha este campo';
            }
            if (value != null && value.trim().isNotEmpty) {
              final day = int.tryParse(value);
              if (day == null || day < 1 || day > 31) {
                return 'Dia inválido (deve ser entre 1 e 31)';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    final isPostpaid = _currentPage == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.verdeEscuro.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              _controller.status == FinanceConfigStatus.loading ? null : _save,
          child: _controller.status == FinanceConfigStatus.loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.background,
                  ),
                )
              : Text(
                  isPostpaid
                      ? 'Salvar Configuração Pós-paga'
                      : 'Salvar Configuração Pré-paga',
                ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final isPostpaid = _currentPage == 0;
    final formKey = isPostpaid ? _postpaidFormKey : _prepaidFormKey;

    if (!formKey.currentState!.validate()) return;

    final incomeText = isPostpaid
        ? _postpaidIncomeController.text
        : _prepaidIncomeController.text;
    final limitText = isPostpaid
        ? _postpaidLimitController.text
        : _prepaidLimitController.text;
    final savingsText = isPostpaid
        ? _postpaidSavingsController.text
        : _prepaidSavingsController.text;
    final emergencyText = isPostpaid
        ? _postpaidEmergencyFundController.text
        : _prepaidEmergencyFundController.text;
    final salaryText = isPostpaid
        ? _postpaidSalaryDayController.text
        : _prepaidSalaryDayController.text;
    final closingText = _postpaidClosingDayController.text;

    final income = CurrencyInputFormatter.parse(incomeText);
    final limit = CurrencyInputFormatter.parse(limitText);
    final savings = CurrencyInputFormatter.parse(savingsText);
    final emergencyFund = CurrencyInputFormatter.parse(emergencyText);
    final salaryDay = int.tryParse(salaryText);
    final paymentDay = isPostpaid ? int.tryParse(closingText) : null;
    final configType = isPostpaid ? 'POSPAID' : 'PREPAID';

    final success = await _controller.updateConfig(
      monthlyIncome: income,
      spendingLimit: limit,
      savingsGoal: savings,
      emergencyFundGoal: emergencyFund,
      type: configType,
      cashBalance: _controller.config?.cashBalance,
      salaryDay: salaryDay,
      paymentDay: paymentDay,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuração salva com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Erro ao salvar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
