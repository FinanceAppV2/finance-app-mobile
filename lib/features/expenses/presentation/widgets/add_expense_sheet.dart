import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../cards/domain/entities/card.dart';
import '../../../cards/domain/usecases/get_cards_usecase.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedCategory = 'FOOD';
  String _selectedPaymentMethod = 'PIX';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  List<CreditCard> _cards = [];
  String? _selectedCardId;
  bool _cardsLoading = false;

  static const _categories = [
    {'value': 'FOOD', 'label': 'Alimentação', 'icon': Icons.restaurant_rounded},
    {
      'value': 'TRANSPORT',
      'label': 'Transporte',
      'icon': Icons.directions_car_rounded,
    },
    {'value': 'HOUSING', 'label': 'Moradia', 'icon': Icons.home_rounded},
    {'value': 'HEALTH', 'label': 'Saúde', 'icon': Icons.favorite_rounded},
    {
      'value': 'EDUCATION',
      'label': 'Educação',
      'icon': Icons.menu_book_rounded,
    },
    {'value': 'LEISURE', 'label': 'Lazer', 'icon': Icons.movie_rounded},
    {
      'value': 'CLOTHING',
      'label': 'Vestuário',
      'icon': Icons.checkroom_rounded,
    },
    {'value': 'SERVICES', 'label': 'Serviços', 'icon': Icons.build_rounded},
    {'value': 'TAXES', 'label': 'Impostos', 'icon': Icons.receipt_rounded},
    {
      'value': 'INVESTMENTS',
      'label': 'Investimentos',
      'icon': Icons.trending_up_rounded,
    },
    {'value': 'OTHERS', 'label': 'Outros', 'icon': Icons.more_horiz_rounded},
  ];

  static const _paymentMethods = [
    {'value': 'CREDIT_CARD', 'label': 'Crédito'},
    {'value': 'DEBIT_CARD', 'label': 'Débito'},
    {'value': 'PIX', 'label': 'Pix'},
    {'value': 'MONEY', 'label': 'Dinheiro'},
    {'value': 'TRANSFER', 'label': 'Transferência'},
    {'value': 'BOLETO', 'label': 'Boleto'},
    {'value': 'OTHERS', 'label': 'Outros'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    setState(() => _cardsLoading = true);
    try {
      final useCase = GetIt.instance<GetCardsUseCase>();
      final result = await useCase.execute();
      result.fold((_) {}, (cards) {
        if (mounted) {
          setState(() {
            _cards = cards.where((c) => c.ativo).toList();
            if (_cards.isNotEmpty) {
              _selectedCardId = _cards.first.id;
            }
          });
        }
      });
    } catch (_) {}
    if (mounted) setState(() => _cardsLoading = false);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.verdeDestaque,
              surface: AppColors.verdeEscuro,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedPaymentMethod == 'CREDIT_CARD' && _selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um cartão de crédito'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final storage = GetIt.instance<FlutterSecureStorage>();
      final userId = await storage.read(key: 'user_id');
      final dio = GetIt.instance<Dio>();

      final valueText = _valueController.text
          .replaceAll('.', '')
          .replaceAll(',', '.');
      final value = double.parse(valueText);

      final data = <String, dynamic>{
        'description': _descriptionController.text.trim(),
        'value': value,
        'category': _selectedCategory,
        'paymentMethod': _selectedPaymentMethod,
        'date': _selectedDate.toIso8601String().split('T')[0],
      };

      if (_selectedPaymentMethod == 'CREDIT_CARD') {
        data['cardId'] = _selectedCardId;
      }

      await dio.post('/users/$userId/expenses', data: data);

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Despesa cadastrada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message']?.toString() ??
          'Erro ao cadastrar despesa';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                    'Nova Despesa',
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
                controller: _descriptionController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex: Supermercado',
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: AppColors.verdeMedio,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Descrição é obrigatória';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CurrencyInputFormatter(),
                ],
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'R\$ 0,00',
                  prefixIcon: Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.verdeMedio,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Valor é obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                dropdownColor: AppColors.verdeEscuro,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: AppColors.verdeMedio,
                  ),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat['value'] as String,
                    child: Row(
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 18,
                          color: AppColors.verdeMedio,
                        ),
                        const SizedBox(width: 8),
                        Text(cat['label'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedPaymentMethod,
                dropdownColor: AppColors.verdeEscuro,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Forma de pagamento',
                  prefixIcon: Icon(
                    Icons.payment_outlined,
                    color: AppColors.verdeMedio,
                  ),
                ),
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method['value'] as String,
                    child: Text(method['label'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedPaymentMethod = value);
                  }
                },
              ),
              if (_selectedPaymentMethod == 'CREDIT_CARD') ...[
                const SizedBox(height: 12),
                _buildCardSelector(),
              ],
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.verdeMedio,
                    ),
                  ),
                  child: Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    style: const TextStyle(color: AppColors.branco),
                  ),
                ),
              ),
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

  Widget _buildCardSelector() {
    if (_cardsLoading) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: 'Cartão de crédito',
          prefixIcon: Icon(
            Icons.credit_card_rounded,
            color: AppColors.verdeMedio,
          ),
        ),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.verdeMedio,
          ),
        ),
      );
    }

    if (_cards.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Cartão de crédito',
          prefixIcon: Icon(
            Icons.credit_card_rounded,
            color: AppColors.verdeMedio,
          ),
        ),
        child: Text(
          'Nenhum cartão cadastrado',
          style: TextStyle(color: AppColors.cinzaClaro.withValues(alpha: 0.7)),
        ),
      );
    }

    final validId = _cards.any((c) => c.id == _selectedCardId)
        ? _selectedCardId
        : _cards.first.id;

    return DropdownButtonFormField<String>(
      initialValue: validId,
      dropdownColor: AppColors.verdeEscuro,
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'Cartão de crédito',
        prefixIcon: Icon(
          Icons.credit_card_rounded,
          color: AppColors.verdeMedio,
        ),
      ),
      items: _cards.map((card) {
        return DropdownMenuItem(
          value: card.id,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _hexToColor(card.cor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: AppColors.branco,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${card.nome}  •••• ${card.finalNumero}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _selectedCardId = value);
      },
    );
  }

  Color _hexToColor(String hex) {
    final normalizedHex = hex.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(normalizedHex)) {
      return AppColors.verdeMedio;
    }

    return Color(int.parse('FF$normalizedHex', radix: 16));
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue next,
  ) {
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
