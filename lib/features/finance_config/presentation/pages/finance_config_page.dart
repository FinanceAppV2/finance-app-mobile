import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../presentation/controllers/finance_config_controller.dart';

class FinanceConfigPage extends StatefulWidget {
  const FinanceConfigPage({super.key});

  @override
  State<FinanceConfigPage> createState() => _FinanceConfigPageState();
}

class _FinanceConfigPageState extends State<FinanceConfigPage> {
  final _controller = GetIt.instance<FinanceConfigController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _incomeController;
  late TextEditingController _limitController;
  late TextEditingController _savingsController;

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController();
    _limitController = TextEditingController();
    _savingsController = TextEditingController();
    _controller.addListener(_onStateChanged);
    _controller.loadConfig();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _incomeController.dispose();
    _limitController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    if (_controller.status == FinanceConfigStatus.success &&
        _controller.config != null) {
      final config = _controller.config!;
      if (_incomeController.text.isEmpty) {
        _incomeController.text = _formatValue(config.monthlyIncome);
      }
      if (_limitController.text.isEmpty) {
        _limitController.text = _formatValue(config.spendingLimit);
      }
      if (_savingsController.text.isEmpty) {
        _savingsController.text = _formatValue(config.savingsGoal);
      }
    }
    setState(() {});
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble() && value < 100000) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configuração Financeira'),
      ),
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
        return _buildForm();
    }
  }

  Widget _buildForm() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure seus limites e metas financeiras',
                style: TextStyle(
                  color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _buildFieldSection(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Renda mensal',
                hint: 'Ex: 5000',
                controller: _incomeController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 20),
              _buildFieldSection(
                icon: Icons.money_off_rounded,
                label: 'Limite de gastos',
                hint: 'Ex: 3000',
                controller: _limitController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 20),
              _buildFieldSection(
                icon: Icons.savings_rounded,
                label: 'Meta de economia',
                hint: 'Ex: 1000',
                controller: _savingsController,
                prefix: 'R\$ ',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _controller.status == FinanceConfigStatus.loading
                          ? null
                          : _save,
                  child:
                      _controller.status == FinanceConfigStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.background,
                              ),
                            )
                          : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldSection({
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
            Icon(icon, color: AppColors.verdeDestaque, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 15,
          ),
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
            final parsed = double.tryParse(
              value.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), ''),
            );
            if (parsed == null || parsed < 0) {
              return 'Insira um valor válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final income = double.parse(
      _incomeController.text.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), ''),
    );
    final limit = double.parse(
      _limitController.text.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), ''),
    );
    final savings = double.parse(
      _savingsController.text.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), ''),
    );

    final success = await _controller.updateConfig(
      monthlyIncome: income,
      spendingLimit: limit,
      savingsGoal: savings,
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
