import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loans_controller.dart';
import '../widgets/add_loan_sheet.dart';
import '../widgets/edit_loan_sheet.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final _controller = GetIt.instance<LoansController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    _controller.loadLoans();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onAdd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddLoanSheet(),
    ).then((result) {
      if (result == true) _controller.loadLoans();
    });
  }

  void _onEdit(Loan loan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditLoanSheet(loan: loan),
    ).then((result) {
      if (result == true) _controller.loadLoans();
    });
  }

  void _onToggleActive(Loan loan) async {
    final error = await _controller.updateLoan(
      id: loan.id,
      active: !loan.active,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? (loan.active ? 'Empréstimo finalizado' : 'Empréstimo reativado'),
        ),
        backgroundColor: error != null ? AppColors.error : AppColors.success,
      ),
    );
  }

  void _onDelete(Loan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.verdeEscuro,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir empréstimo',
            style: TextStyle(color: AppColors.branco)),
        content: Text(
          'Deseja excluir "${loan.description}"?',
          style: const TextStyle(color: AppColors.cinzaClaro),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.cinzaClaro)),
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
    final success = await _controller.deleteLoan(loan.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Empréstimo excluído!' : 'Erro ao excluir empréstimo',
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Empréstimos'),
        actions: [
          IconButton(
            onPressed: _onAdd,
            icon: const Icon(Icons.add_rounded, color: AppColors.verdeDestaque),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.status == LoansStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }

    if (_controller.status == LoansStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar dados',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadLoans(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_controller.loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_rounded,
                size: 64,
                color: AppColors.verdeDestaque.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'Nenhum empréstimo cadastrado',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final active = _controller.activeLoans;
    final inactive = _controller.inactiveLoans;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (active.isNotEmpty) ...[
          _SummaryCard(totalPending: _controller.totalPending),
          const SizedBox(height: 16),
          ...active.map((loan) => _LoanTile(
                loan: loan,
                onEdit: () => _onEdit(loan),
                onToggleActive: () => _onToggleActive(loan),
                onDelete: () => _onDelete(loan),
              )),
        ],
        if (inactive.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Finalizados',
            style: TextStyle(
              color: AppColors.cinzaClaro.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...inactive.map((loan) => _LoanTile(
                loan: loan,
                onEdit: () => _onEdit(loan),
                onToggleActive: () => _onToggleActive(loan),
                onDelete: () => _onDelete(loan),
              )),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double totalPending;
  const _SummaryCard({required this.totalPending});

  @override
  Widget build(BuildContext context) {
    final formatted =
        'R\$ ${totalPending.toStringAsFixed(2).replaceAll('.', ',')}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.verdeMedio, AppColors.verdeEscuro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.verdeDestaque.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: AppColors.verdeDestaque, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total pendente',
                style: TextStyle(
                  color: AppColors.branco.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatted,
                style: const TextStyle(
                  color: AppColors.verdeDestaque,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoanTile extends StatelessWidget {
  final Loan loan;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const _LoanTile({
    required this.loan,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  String _fmt(double v) =>
      'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: loan.active
                      ? AppColors.verdeMedio.withValues(alpha: 0.4)
                      : AppColors.cinzaEscuro.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: loan.active ? AppColors.verdeDestaque : AppColors.cinzaClaro,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.description,
                      style: const TextStyle(
                        color: AppColors.branco,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${loan.monthlyInterestRate.toStringAsFixed(1)}% a.m. \u2022 ${loan.totalInstallments}x',
                      style: TextStyle(
                        color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(loan.installmentValue),
                    style: const TextStyle(
                      color: AppColors.verdeDestaque,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '/parcela',
                    style: TextStyle(
                      color: AppColors.cinzaClaro.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_fmt(loan.paidAmount)} de ${_fmt(loan.totalWithInterest)}',
                          style: TextStyle(
                            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '${loan.paidInstallments}/${loan.totalInstallments}',
                          style: TextStyle(
                            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: loan.progress,
                        backgroundColor: AppColors.verdeMedio.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loan.active ? AppColors.verdeDestaque : AppColors.success,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    if (loan.active) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pendente',
                            style: TextStyle(
                              color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            _fmt(loan.remainingAmount),
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.edit_rounded,
                color: AppColors.verdeDestaque,
                onTap: onEdit,
              ),
              const SizedBox(width: 4),
              _ActionBtn(
                icon: loan.active ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: loan.active ? AppColors.warning : AppColors.success,
                onTap: onToggleActive,
              ),
              const SizedBox(width: 4),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
