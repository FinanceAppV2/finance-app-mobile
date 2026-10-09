import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/formatters/currency_input_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/loans_controller.dart';

class AddLoanSheet extends StatefulWidget {
  const AddLoanSheet({super.key});

  @override
  State<AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends State<AddLoanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _totalValueController = TextEditingController();
  final _installmentsController = TextEditingController();
  final _interestRateController = TextEditingController(text: '0');
  DateTime _startDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _totalValueController.dispose();
    _installmentsController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.lataoClaro,
              surface: AppColors.superficie,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final controller = GetIt.instance<LoansController>();
    final totalValue = CurrencyInputFormatter.parse(_totalValueController.text);
    final totalInstallments = int.parse(_installmentsController.text);
    final interestRate = double.tryParse(_interestRateController.text) ?? 0;

    final error = await controller.createLoan(
      description: _descriptionController.text.trim(),
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      startDate: _startDate,
      monthlyInterestRate: interestRate,
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      setState(() => _isLoading = false);
    } else {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empréstimo criado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}';

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.superficie,
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
                    'Novo Empréstimo',
                    style: TextStyle(
                      color: AppColors.marfim,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.cinza),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: AppColors.marfim),
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex: Empréstimo pessoal',
                  prefixIcon: Icon(Icons.description_outlined, color: AppColors.cinza),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [const CurrencyInputFormatter()],
                style: const TextStyle(color: AppColors.marfim),
                decoration: const InputDecoration(
                  labelText: 'Valor total',
                  hintText: 'R\$ 0,00',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.cinza),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _installmentsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      style: const TextStyle(color: AppColors.marfim),
                      decoration: const InputDecoration(
                        labelText: 'Parcelas',
                        hintText: '12',
                        prefixIcon: Icon(Icons.numbers_rounded, color: AppColors.cinza),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Obrigatório';
                        final n = int.tryParse(v);
                        return (n == null || n < 1) ? 'Inválido' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _interestRateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: const TextStyle(color: AppColors.marfim),
                      decoration: const InputDecoration(
                        labelText: 'Taxa (% a.m.)',
                        hintText: '0',
                        suffixText: '%',
                        prefixIcon: Icon(Icons.percent_rounded, color: AppColors.cinza),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de início',
                    prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.cinza),
                  ),
                  child: Text(dateFormatted, style: const TextStyle(color: AppColors.marfim)),
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
                      : const Text('Cadastrar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
