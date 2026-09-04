import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/formatters/currency_input_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loans_controller.dart';

class EditLoanSheet extends StatefulWidget {
  final Loan loan;
  const EditLoanSheet({super.key, required this.loan});

  @override
  State<EditLoanSheet> createState() => _EditLoanSheetState();
}

class _EditLoanSheetState extends State<EditLoanSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _totalValueController;
  late final TextEditingController _installmentsController;
  late final TextEditingController _interestRateController;
  late DateTime _startDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.loan.description);
    _totalValueController = TextEditingController(
      text: widget.loan.totalValue.toStringAsFixed(2).replaceAll('.', ','),
    );
    _installmentsController = TextEditingController(
      text: widget.loan.totalInstallments.toString(),
    );
    _interestRateController = TextEditingController(
      text: widget.loan.monthlyInterestRate.toStringAsFixed(2),
    );
    _startDate = widget.loan.startDate;
  }

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
              primary: AppColors.verdeDestaque,
              surface: AppColors.verdeEscuro,
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

    final error = await controller.updateLoan(
      id: widget.loan.id,
      description: _descriptionController.text.trim(),
      totalValue: totalValue,
      totalInstallments: totalInstallments,
      monthlyInterestRate: interestRate,
      startDate: _startDate,
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
          content: Text('Empréstimo atualizado com sucesso!'),
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
                    'Editar Empréstimo',
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
                  prefixIcon: Icon(Icons.description_outlined, color: AppColors.verdeMedio),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalValueController,
                keyboardType: TextInputType.number,
                inputFormatters: [const CurrencyInputFormatter()],
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Valor total',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.verdeMedio),
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
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Parcelas',
                        prefixIcon: Icon(Icons.numbers_rounded, color: AppColors.verdeMedio),
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
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Taxa (% a.m.)',
                        suffixText: '%',
                        prefixIcon: Icon(Icons.percent_rounded, color: AppColors.verdeMedio),
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
                    prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.verdeMedio),
                  ),
                  child: Text(dateFormatted, style: const TextStyle(color: AppColors.branco)),
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
                      : const Text('Salvar',
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
