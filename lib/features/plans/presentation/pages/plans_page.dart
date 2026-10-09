import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/plan.dart';
import '../controllers/plans_controller.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late final PlansController _controller;

  @override
  void initState() {
    super.initState();
    _controller = injector<PlansController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Planos de Assinatura'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.lataoClaro,
              ),
            );
          }

          if (_controller.errorMessage != null && _controller.plans.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.marfim),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _controller.loadPlans(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final plans = _controller.plans;

          return RefreshIndicator(
            color: AppColors.lataoClaro,
            backgroundColor: AppColors.superficie,
            onRefresh: () => _controller.loadPlans(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Escolha o melhor plano para sua jornada financeira',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cinza,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final plan in plans) ...[
                    _PlanCard(
                      plan: plan,
                      isCurrentPlan: _controller.currentPlan?.id == plan.id ||
                          _controller.currentPlan?.type == plan.type,
                      isSubscribing: _controller.isSubscribing,
                      onSelect: () => _confirmPlanChange(plan),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmPlanChange(Plan plan) {
    final isCurrent = _controller.currentPlan?.id == plan.id ||
        _controller.currentPlan?.type == plan.type;

    if (isCurrent) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.superficie,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Mudar para ${plan.name}?',
          style: const TextStyle(color: AppColors.marfim, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Deseja alterar seu plano para ${plan.name} (${plan.formattedPrice})?',
          style: const TextStyle(color: AppColors.cinza),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.cinza),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lataoClaro,
              foregroundColor: AppColors.background,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _controller.subscribe(plan);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:
                        success ? AppColors.latao : AppColors.error,
                    content: Text(
                      success
                          ? 'Plano ${plan.name} ativado com sucesso!'
                          : (_controller.errorMessage ?? 'Erro ao alterar plano'),
                      style: const TextStyle(color: AppColors.marfim),
                    ),
                  ),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isCurrentPlan;
  final bool isSubscribing;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.plan,
    required this.isCurrentPlan,
    required this.isSubscribing,
    required this.onSelect,
  });

  Color get _accentColor {
    if (plan.isFree) return AppColors.cinza;
    if (plan.isPlus) return AppColors.lataoClaro;
    return AppColors.marfim;
  }

  String get _iconEmoji {
    if (plan.isFree) return '🟢';
    if (plan.isPlus) return '🔵';
    return '🟣';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlan ? _accentColor : AppColors.nevoa.withValues(alpha: 0.3),
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _accentColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _iconEmoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      color: AppColors.marfim,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accentColor, width: 1),
                  ),
                  child: Text(
                    'Plano Atual',
                    style: TextStyle(
                      color: _accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            plan.formattedPrice,
            style: TextStyle(
              color: _accentColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              plan.description!,
              style: TextStyle(
                color: AppColors.marfim.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
          if (plan.features.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(
              color: AppColors.linha.withValues(alpha: 0.3),
              height: 1,
            ),
            const SizedBox(height: 12),
            for (final feature in plan.features) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      feature.included
                          ? Icons.check_circle_rounded
                          : Icons.cancel_outlined,
                      size: 18,
                      color: feature.included
                          ? _accentColor
                          : AppColors.cinza.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: feature.included
                              ? AppColors.marfim
                              : AppColors.cinza.withValues(alpha: 0.5),
                          decoration: feature.included
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentPlan
                    ? AppColors.nevoa.withValues(alpha: 0.4)
                    : _accentColor,
                foregroundColor: isCurrentPlan
                    ? AppColors.cinza
                    : AppColors.background,
                elevation: isCurrentPlan ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isCurrentPlan || isSubscribing ? null : onSelect,
              child: Text(
                isCurrentPlan ? 'Seu Plano Atual' : 'Escolher ${plan.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
