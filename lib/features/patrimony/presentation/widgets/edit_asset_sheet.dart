import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/formatters/currency_input_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_type.dart';
import '../controllers/asset_controller.dart';

class EditAssetSheet extends StatefulWidget {
  final Asset asset;

  const EditAssetSheet({super.key, required this.asset});

  @override
  State<EditAssetSheet> createState() => _EditAssetSheetState();
}

class _EditAssetSheetState extends State<EditAssetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _investedController = TextEditingController();
  final _categoryController = TextEditingController();
  final _institutionController = TextEditingController();
  final _tickerController = TextEditingController();
  final _rateController = TextEditingController();
  final _notesController = TextEditingController();
  late String _selectedType;
  late String _selectedRateType;
  bool _isLoading = false;

  static const _rateTypes = [
    'CDI',
    'CDB',
    'PRÉ-FIXADO',
    'IPCA+',
    'POUPANÇA',
    'SELIC',
    'IGPM+',
    'OUTRO',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.asset;
    _nameController.text = a.name;
    _valueController.text = CurrencyInputFormatter.format(a.value);
    _investedController.text = CurrencyInputFormatter.format(a.investedValue);
    _categoryController.text = a.category;
    _institutionController.text = a.institution ?? '';
    _tickerController.text = a.ticker ?? '';
    _rateController.text =
        a.rate != null ? a.rate!.toStringAsFixed(2).replaceAll('.', ',') : '';
    _notesController.text = a.notes ?? '';
    _selectedType = a.type.jsonValue;
    _selectedRateType = a.rateType ?? 'CDI';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _investedController.dispose();
    _categoryController.dispose();
    _institutionController.dispose();
    _tickerController.dispose();
    _rateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final controller = GetIt.instance<AssetController>();
    final value = CurrencyInputFormatter.parse(_valueController.text);
    final invested = CurrencyInputFormatter.parse(_investedController.text);
    final rateText = _rateController.text.trim();
    final rate = rateText.isNotEmpty
        ? double.tryParse(rateText.replaceAll(',', '.'))
        : null;

    final success = await controller.updateAsset(
      id: widget.asset.id,
      name: _nameController.text.trim(),
      type: _selectedType,
      category: _categoryController.text.trim(),
      value: value,
      investedValue: invested,
      rate: rate,
      rateType: rate != null ? _selectedRateType : null,
      institution: _institutionController.text.trim().isEmpty
          ? null
          : _institutionController.text.trim(),
      ticker: _tickerController.text.trim().isEmpty
          ? null
          : _tickerController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ativo atualizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(controller.errorMessage ?? 'Erro ao atualizar ativo'),
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
                    'Editar Ativo',
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
                controller: _nameController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Nome do ativo',
                  hintText: 'Ex: Tesouro Selic',
                  prefixIcon:
                      Icon(Icons.label_outline, color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                dropdownColor: AppColors.verdeEscuro,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  prefixIcon: Icon(Icons.category_outlined,
                      color: AppColors.verdeMedio),
                ),
                items: AssetType.values.map((t) {
                  return DropdownMenuItem(
                    value: t.jsonValue,
                    child: Text(t.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedType = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  hintText: 'Ex: Renda Fixa',
                  prefixIcon: Icon(Icons.folder_outlined,
                      color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Categoria é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                inputFormatters: [const CurrencyInputFormatter()],
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Valor atual',
                  hintText: 'R\$ 0,00',
                  prefixIcon: Icon(Icons.attach_money_rounded,
                      color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _investedController,
                keyboardType: TextInputType.number,
                inputFormatters: [const CurrencyInputFormatter()],
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Valor investido',
                  hintText: 'R\$ 0,00',
                  prefixIcon: Icon(Icons.trending_down_rounded,
                      color: AppColors.verdeMedio),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor investido é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _institutionController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Instituição',
                  hintText: 'Ex: Banco do Brasil',
                  prefixIcon: Icon(Icons.business_outlined,
                      color: AppColors.verdeMedio),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tickerController,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Ticker',
                  hintText: 'Ex: ITSA4',
                  prefixIcon:
                      Icon(Icons.code, color: AppColors.verdeMedio),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Taxa (%)',
                        hintText: '0,00',
                        prefixIcon: Icon(Icons.percent_rounded,
                            color: AppColors.verdeMedio),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedRateType,
                      dropdownColor: AppColors.verdeEscuro,
                      style: const TextStyle(color: AppColors.branco),
                      decoration: const InputDecoration(
                        labelText: 'Tipo taxa',
                        prefixIcon: Icon(Icons.trending_up_rounded,
                            color: AppColors.verdeMedio),
                      ),
                      items: _rateTypes.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedRateType = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.branco),
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Observações sobre o ativo',
                  prefixIcon: Icon(Icons.notes_rounded,
                      color: AppColors.verdeMedio),
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
                          'Salvar',
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
}
