import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../presentation/controllers/cards_controller.dart';

class AddCardSheet extends StatefulWidget {
  const AddCardSheet({super.key});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _finalController = TextEditingController();
  final _titularController = TextEditingController();
  final _limiteController = TextEditingController();
  String _selectedEmissora = 'OUTRO';
  String _selectedBandeira = 'OUTRA';
  int _diaVencimento = 10;
  int _diaFechamento = 5;
  String _selectedCor = '#4CAF50';
  String _selectedIcone = 'credit_card';
  bool _isLoading = false;

  static const _emissores = [
    'BANCO_DO_BRASIL', 'ITAU', 'BRADESCO', 'SANTANDER', 'CAIXA',
    'INTER', 'NUBANK', 'C6_BANK', 'MERCADO_PAGO', 'PICPAY',
    'PAGSEGURO', 'ORIGINAL', 'BTG_PACTUAL', 'WILL_BANK', 'NEON',
    'AGIBANK', 'OUTRO',
  ];

  static const _bandeiras = [
    'VISA', 'MASTERCARD', 'ELO', 'AMEX', 'HIPERCARD',
    'DINERS', 'DISCOVER', 'JCB', 'AURA', 'CABAL', 'MAESTRO', 'OUTRA',
  ];

  static const _cores = [
    '#4CAF50', '#2196F3', '#F44336', '#FF9800', '#9C27B0',
    '#00BCD4', '#FF5722', '#607D8B', '#795548', '#E91E63',
  ];

  static const _icones = [
    'credit_card', 'payments', 'account_balance_wallet', 'savings',
    'local_atm', 'card_giftcard',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _finalController.dispose();
    _titularController.dispose();
    _limiteController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'payments': return Icons.payments_rounded;
      case 'account_balance_wallet': return Icons.account_balance_wallet_rounded;
      case 'savings': return Icons.savings_rounded;
      case 'local_atm': return Icons.local_atm_rounded;
      case 'card_giftcard': return Icons.card_giftcard_rounded;
      default: return Icons.credit_card_rounded;
    }
  }

  String _formatEmissora(String emissora) {
    return emissora.split('_').map((w) => w[0] + w.substring(1).toLowerCase()).join(' ');
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final controller = GetIt.instance<CardsController>();
    final limiteText = _limiteController.text.replaceAll('.', '').replaceAll(',', '.');
    final limite = double.tryParse(limiteText) ?? 0;

    final success = await controller.createCard(
      nome: _nomeController.text.trim(),
      emissora: _selectedEmissora,
      bandeira: _selectedBandeira,
      finalNumero: _finalController.text.trim(),
      nomeTitular: _titularController.text.trim(),
      diaVencimento: _diaVencimento,
      diaFechamento: _diaFechamento,
      limiteDisponivel: limite,
      cor: _selectedCor,
      icone: _selectedIcone,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cartão cadastrado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Erro ao cadastrar cartão'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Novo Cartão',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.cinzaClaro),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Nome do cartão',
                  hintText: 'Ex: Nubank',
                  prefixIcon: Icon(Icons.label_outline, color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Nome é obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedEmissora,
                dropdownColor: AppColors.verdeEscuro,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Emissora',
                  prefixIcon: Icon(Icons.business_outlined, color: AppColors.verdeMedio),
                ),
                items: _emissores.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(_formatEmissora(e)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedEmissora = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedBandeira,
                dropdownColor: AppColors.verdeEscuro,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Bandeira',
                  prefixIcon: Icon(Icons.credit_card_outlined, color: AppColors.verdeMedio),
                ),
                items: _bandeiras.map((b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text(b[0] + b.substring(1).toLowerCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedBandeira = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _finalController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Últimos 4 dígitos',
                  hintText: '0000',
                  prefixIcon: Icon(Icons.tag, color: AppColors.verdeMedio),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Obrigatório';
                  if (value.length != 4) return 'Deve ter 4 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titularController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Nome do titular',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _limiteController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CurrencyInputFormatter(),
                ],
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Limite disponível',
                  hintText: 'R\$ 0,00',
                  prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child:                     DropdownButtonFormField<int>(
                      initialValue: _diaVencimento,
                      dropdownColor: AppColors.verdeEscuro,
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Vencimento',
                        prefixIcon: Icon(Icons.calendar_today, color: AppColors.verdeMedio),
                      ),
                      items: List.generate(31, (i) => i + 1).map((d) {
                        return DropdownMenuItem(value: d, child: Text('$d'));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _diaVencimento = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:                     DropdownButtonFormField<int>(
                      initialValue: _diaFechamento,
                      dropdownColor: AppColors.verdeEscuro,
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Fechamento',
                        prefixIcon: Icon(Icons.event, color: AppColors.verdeMedio),
                      ),
                      items: List.generate(31, (i) => i + 1).map((d) {
                        return DropdownMenuItem(value: d, child: Text('$d'));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _diaFechamento = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildColorPicker(),
              const SizedBox(height: 12),
              _buildIconPicker(),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.background,
                          ),
                        )
                      : const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cor',
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _cores.map((cor) {
            final isSelected = _selectedCor == cor;
            return GestureDetector(
              onTap: () => setState(() => _selectedCor = cor),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _hexToColor(cor),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.branco : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: AppColors.branco, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIconPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ícone',
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _icones.map((icone) {
            final isSelected = _selectedIcone == icone;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcone = icone),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.verdeDestaque.withValues(alpha: 0.3)
                      : AppColors.background.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.verdeDestaque : AppColors.cinzaEscuro,
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getIconData(icone),
                  color: isSelected ? AppColors.verdeDestaque : AppColors.cinzaClaro,
                  size: 20,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    if (next.text.isEmpty) return next;

    final digits = next.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return const TextEditingValue();

    final value = int.parse(digits);
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}