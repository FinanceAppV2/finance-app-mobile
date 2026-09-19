import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MonthlyIncomeBottomSheet extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double>? onChanged;

  const MonthlyIncomeBottomSheet({
    super.key,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<MonthlyIncomeBottomSheet> createState() =>
      _MonthlyIncomeBottomSheetState();
}

class _MonthlyIncomeBottomSheetState extends State<MonthlyIncomeBottomSheet> {
  late String _digits;
  bool _isFirstInput = true;

  @override
  void initState() {
    super.initState();
    final cents = (widget.initialValue * 100).round();
    _digits = cents > 0 ? cents.toString() : '0';
  }

  double get _currentValue {
    final cents = int.tryParse(_digits) ?? 0;
    return cents / 100;
  }

  void _notifyChange() {
    widget.onChanged?.call(_currentValue);
  }

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isFirstInput) {
        _isFirstInput = false;
        if (digit == '0' || digit == '00') {
          _digits = '0';
        } else {
          _digits = digit;
        }
      } else {
        if (_digits == '0') {
          if (digit == '0' || digit == '00') return;
          _digits = digit;
        } else {
          if (_digits.length >= 11) return;
          _digits += digit;
        }
      }
    });
    _notifyChange();
  }

  void _onBackspace() {
    setState(() {
      _isFirstInput = false;
      if (_digits.length > 1) {
        _digits = _digits.substring(0, _digits.length - 1);
      } else {
        _digits = '0';
      }
    });
    _notifyChange();
  }

  void _onClear() {
    setState(() {
      _isFirstInput = false;
      _digits = '0';
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.verdeMedio, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cinzaEscuro.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Renda Mensal',
                    style: TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.cinzaClaro),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Custom Keypad
              _buildKeypad(),
              const SizedBox(height: 16),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _currentValue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verdeDestaque,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Confirmar Renda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          children: [
            _buildKeypadButton('1'),
            const SizedBox(width: 10),
            _buildKeypadButton('2'),
            const SizedBox(width: 10),
            _buildKeypadButton('3'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildKeypadButton('4'),
            const SizedBox(width: 10),
            _buildKeypadButton('5'),
            const SizedBox(width: 10),
            _buildKeypadButton('6'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildKeypadButton('7'),
            const SizedBox(width: 10),
            _buildKeypadButton('8'),
            const SizedBox(width: 10),
            _buildKeypadButton('9'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildActionKey(
              label: 'C',
              onTap: _onClear,
              isClear: true,
            ),
            const SizedBox(width: 10),
            _buildKeypadButton('0'),
            const SizedBox(width: 10),
            _buildActionKey(
              icon: Icons.backspace_outlined,
              onTap: _onBackspace,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String text) {
    return Expanded(
      child: Material(
        color: AppColors.verdeEscuro.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _onDigitPressed(text),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.branco,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    String? label,
    IconData? icon,
    required VoidCallback onTap,
    bool isClear = false,
  }) {
    return Expanded(
      child: Material(
        color: AppColors.verdeEscuro.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: label != null
                ? Text(
                    label,
                    style: TextStyle(
                      color: isClear ? AppColors.warning : AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.cinzaClaro,
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }
}
