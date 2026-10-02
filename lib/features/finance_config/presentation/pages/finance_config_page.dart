import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/formatters/currency_input_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/index.dart';
import '../../presentation/controllers/finance_config_controller.dart';
import '../widgets/monthly_income_bottom_sheet.dart';

class FinanceConfigPage extends StatefulWidget {
  const FinanceConfigPage({super.key});

  @override
  State<FinanceConfigPage> createState() => _FinanceConfigPageState();
}

class _FinanceConfigPageState extends State<FinanceConfigPage> {
  final _controller = GetIt.instance<FinanceConfigController>();
  final _postpaidFormKey = GlobalKey<FormState>();
  final _prepaidFormKey = GlobalKey<FormState>();

  // Shared monthly income controller
  late TextEditingController _monthlyIncomeController;

  // Postpaid controllers (Page 0)

  late TextEditingController _postpaidLimitController;
  late TextEditingController _postpaidSavingsController;
  late TextEditingController _postpaidEmergencyFundController;
  late TextEditingController _postpaidSalaryDayController;
  late TextEditingController _postpaidClosingDayController;

  // Prepaid controllers (Page 1)
  late TextEditingController _prepaidCashBalanceController;
  late TextEditingController _prepaidLimitController;
  late TextEditingController _prepaidSavingsController;
  late TextEditingController _prepaidEmergencyFundController;
  late TextEditingController _prepaidSalaryDayController;

  int _currentPage = 0;
  bool _initialLoaded = false;

  @override
  void initState() {
    super.initState();
    _monthlyIncomeController = TextEditingController();

    _postpaidLimitController = TextEditingController();
    _postpaidSavingsController = TextEditingController();
    _postpaidEmergencyFundController = TextEditingController();
    _postpaidSalaryDayController = TextEditingController();
    _postpaidClosingDayController = TextEditingController();

    _prepaidCashBalanceController = TextEditingController();
    _prepaidLimitController = TextEditingController();
    _prepaidSavingsController = TextEditingController();
    _prepaidEmergencyFundController = TextEditingController();
    _prepaidSalaryDayController = TextEditingController();

    _controller.addListener(_onStateChanged);
    _controller.loadConfig();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _monthlyIncomeController.dispose();

    _postpaidLimitController.dispose();
    _postpaidSavingsController.dispose();
    _postpaidEmergencyFundController.dispose();
    _postpaidSalaryDayController.dispose();
    _postpaidClosingDayController.dispose();

    _prepaidCashBalanceController.dispose();
    _prepaidLimitController.dispose();
    _prepaidSavingsController.dispose();
    _prepaidEmergencyFundController.dispose();
    _prepaidSalaryDayController.dispose();

    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    if (_controller.status == FinanceConfigStatus.success &&
        (_controller.configs.isNotEmpty || _controller.config != null)) {
      _initialLoaded = true;

      String fmt(double v) => CurrencyInputFormatter.format(v);

      final postpaid = _controller.postpaidConfig;
      final prepaid = _controller.prepaidConfig;

      if (_monthlyIncomeController.text.isEmpty) {
        final income = (postpaid?.monthlyIncome ?? 0) > 0
            ? postpaid!.monthlyIncome
            : (prepaid?.monthlyIncome ?? 0) > 0
                ? prepaid!.monthlyIncome
                : (_controller.config?.monthlyIncome ?? 0);
        if (income > 0) {
          _monthlyIncomeController.text = fmt(income);
        }
      }

      if (postpaid != null) {
        if (_postpaidLimitController.text.isEmpty) {
          _postpaidLimitController.text = fmt(postpaid.spendingLimit);
        }
        if (_postpaidSavingsController.text.isEmpty) {
          _postpaidSavingsController.text = fmt(postpaid.savingsGoal);
        }
        if (_postpaidEmergencyFundController.text.isEmpty) {
          _postpaidEmergencyFundController.text = fmt(postpaid.emergencyFundGoal);
        }
        if (_postpaidSalaryDayController.text.isEmpty) {
          _postpaidSalaryDayController.text =
              postpaid.salaryDay?.toString() ?? '';
        }
        if (_postpaidClosingDayController.text.isEmpty) {
          _postpaidClosingDayController.text =
              postpaid.paymentDay?.toString() ?? '';
        }
      }

      if (prepaid != null) {
        if (_prepaidCashBalanceController.text.isEmpty) {
          _prepaidCashBalanceController.text = fmt(prepaid.cashBalance ?? 0.0);
        }
        if (_prepaidLimitController.text.isEmpty) {
          _prepaidLimitController.text = fmt(prepaid.spendingLimit);
        }
        if (_prepaidSavingsController.text.isEmpty) {
          _prepaidSavingsController.text = fmt(prepaid.savingsGoal);
        }
        if (_prepaidEmergencyFundController.text.isEmpty) {
          _prepaidEmergencyFundController.text = fmt(prepaid.emergencyFundGoal);
        }
        if (_prepaidSalaryDayController.text.isEmpty) {
          _prepaidSalaryDayController.text =
              prepaid.salaryDay?.toString() ?? '';
        }
      }

      if (postpaid == null && prepaid == null && _controller.config != null) {
        final config = _controller.config!;
        if (config.type.toUpperCase() == 'PREPAID') {
          if (_prepaidCashBalanceController.text.isEmpty) {
            _prepaidCashBalanceController.text = fmt(config.cashBalance ?? 0.0);
          }
          if (_prepaidLimitController.text.isEmpty) {
            _prepaidLimitController.text = fmt(config.spendingLimit);
          }
          if (_prepaidSavingsController.text.isEmpty) {
            _prepaidSavingsController.text = fmt(config.savingsGoal);
          }
          if (_prepaidEmergencyFundController.text.isEmpty) {
            _prepaidEmergencyFundController.text = fmt(config.emergencyFundGoal);
          }
          if (_prepaidSalaryDayController.text.isEmpty) {
            _prepaidSalaryDayController.text = config.salaryDay?.toString() ?? '';
          }
        } else {
          if (_postpaidLimitController.text.isEmpty) {
            _postpaidLimitController.text = fmt(config.spendingLimit);
          }
          if (_postpaidSavingsController.text.isEmpty) {
            _postpaidSavingsController.text = fmt(config.savingsGoal);
          }
          if (_postpaidEmergencyFundController.text.isEmpty) {
            _postpaidEmergencyFundController.text = fmt(config.emergencyFundGoal);
          }
          if (_postpaidSalaryDayController.text.isEmpty) {
            _postpaidSalaryDayController.text = config.salaryDay?.toString() ?? '';
          }
          if (_postpaidClosingDayController.text.isEmpty) {
            _postpaidClosingDayController.text =
                config.paymentDay?.toString() ?? '';
          }
        }
      }

      if (_controller.configs.isNotEmpty) {
        final firstConfig = _controller.configs.first;
        final targetPage = firstConfig.type.toUpperCase() == 'PREPAID' ? 1 : 0;
        if (_currentPage != targetPage) {
          _currentPage = targetPage;
        }
      } else if (_controller.config != null) {
        final targetPage = _controller.config!.type.toUpperCase() == 'PREPAID' ? 1 : 0;
        if (_currentPage != targetPage) {
          _currentPage = targetPage;
        }
      }
    }
    setState(() {});
  }

  void _selectPage(int index) {
    if (_currentPage == index) return;
    setState(() => _currentPage = index);
  }

  Future<void> _openMonthlyIncomeBottomSheet() async {
    final originalValue = CurrencyInputFormatter.parse(
      _monthlyIncomeController.text,
    );
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => MonthlyIncomeBottomSheet(
        initialValue: originalValue,
        onChanged: (newValue) {
          _monthlyIncomeController.text = CurrencyInputFormatter.format(
            newValue,
          );
        },
      ),
    );

    if (result != null && mounted) {
      _monthlyIncomeController.text = CurrencyInputFormatter.format(result);
    } else if (mounted) {
      _monthlyIncomeController.text = CurrencyInputFormatter.format(
        originalValue,
      );
    }
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
    if (!_initialLoaded && _controller.status == FinanceConfigStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }
    if (_controller.status == FinanceConfigStatus.error && !_initialLoaded) {
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
    }
    return _buildContent();
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildMonthlyIncomeField(),
          const SizedBox(height: 16),
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
          const SizedBox(height: 10),
          Expanded(
            child: IndexedStack(
              index: _currentPage,
              children: [_buildPostpaidCard(), _buildPrepaidCard()],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildMonthlyIncomeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: _openMonthlyIncomeBottomSheet,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Renda mensal',
                  style: TextStyle(
                    color: AppColors.cinzaClaro.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_rounded,
                  size: 13,
                  color: AppColors.verdeDestaque.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _monthlyIncomeController,
              builder: (context, value, _) {
                final formattedIncome = value.text.isEmpty
                    ? '0,00'
                    : value.text;

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'R\$ ',
                        style: TextStyle(
                          color: AppColors.verdeDestaque,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedIncome,
                        style: const TextStyle(
                          color: AppColors.branco,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
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
        border: Border.all(color: AppColors.verdeMedio.withValues(alpha: 0.3)),
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
    return Form(
      key: _postpaidFormKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.verdeEscuro,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.verdeDestaque, width: 1.5),
            ),
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
                const SizedBox(height: 20),
                MoneyInputField(
                  label: 'Limite de gastos',
                  controller: _postpaidLimitController,
                ),
                const SizedBox(height: 16),
                MoneyInputField(
                  label: 'Meta de economia',
                  controller: _postpaidSavingsController,
                ),
                const SizedBox(height: 16),
                MoneyInputField(
                  label: 'Reserva de emergência',
                  controller: _postpaidEmergencyFundController,
                ),
                const SizedBox(height: 16),
                DayInputField(
                  label: 'Dia do recebimento de salário',
                  controller: _postpaidSalaryDayController,
                ),
                const SizedBox(height: 16),
                DayInputField(
                  label: 'Dia de fechamento das contas',
                  controller: _postpaidClosingDayController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrepaidCard() {
    return Form(
      key: _prepaidFormKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.verdeEscuro,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.verdeDestaque, width: 1.5),
            ),
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
                const SizedBox(height: 20),
                MoneyInputField(
                  label: 'Caixa',
                  controller: _prepaidCashBalanceController,
                ),
                const SizedBox(height: 16),
                MoneyInputField(
                  label: 'Limite de gastos',
                  controller: _prepaidLimitController,
                ),
                const SizedBox(height: 16),
                MoneyInputField(
                  label: 'Meta de economia',
                  controller: _prepaidSavingsController,
                ),
                const SizedBox(height: 16),
                MoneyInputField(
                  label: 'Reserva de emergência',
                  controller: _prepaidEmergencyFundController,
                ),
                const SizedBox(height: 16),
                DayInputField(
                  label: 'Dia do recebimento de salário',
                  controller: _prepaidSalaryDayController,
                ),
              ],
            ),
          ),
        ],
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
              child: Icon(icon, color: AppColors.verdeDestaque, size: 22),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
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

  Widget _buildBottomAction() {
    final isPostpaid = _currentPage == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.verdeEscuro.withValues(alpha: 0.5)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _controller.status == FinanceConfigStatus.loading
              ? null
              : _save,
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

  double _parseField(String text) {
    return CurrencyInputFormatter.parse(text);
  }

  Future<void> _save() async {
    final isPostpaid = _currentPage == 0;
    final formKey = isPostpaid ? _postpaidFormKey : _prepaidFormKey;

    if (!formKey.currentState!.validate()) return;

    final incomeText = _monthlyIncomeController.text;
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
    final limit = _parseField(limitText);
    final savings = _parseField(savingsText);
    final emergencyFund = _parseField(emergencyText);
    final cashBalance = isPostpaid
        ? _controller.config?.cashBalance
        : _parseField(_prepaidCashBalanceController.text);
    final salaryDay = int.tryParse(salaryText);
    final paymentDay = isPostpaid ? int.tryParse(closingText) : null;
    final configType = isPostpaid ? 'POSPAID' : 'PREPAID';

    final success = await _controller.updateConfig(
      monthlyIncome: income,
      spendingLimit: limit,
      savingsGoal: savings,
      emergencyFundGoal: emergencyFund,
      type: configType,
      cashBalance: cashBalance,
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
