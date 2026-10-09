import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_type.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetCard({
    super.key,
    required this.asset,
    this.onEdit,
    this.onDelete,
  });

  IconData _typeIcon() {
    switch (asset.type) {
      case AssetType.piggyBank:
        return Icons.savings_rounded;
      case AssetType.fixedIncome:
        return Icons.account_balance_rounded;
      case AssetType.variableIncome:
        return Icons.trending_up_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = asset.profit >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isProfit
              ? AppColors.latao.withValues(alpha: 0.5)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.latao.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _typeIcon(),
                      color: AppColors.lataoClaro,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: const TextStyle(
                          color: AppColors.marfim,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (asset.ticker != null)
                        Text(
                          asset.ticker!,
                          style: TextStyle(
                            color: AppColors.cinza.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                color: AppColors.superficie,
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.marfim.withValues(alpha: 0.7),
                  size: 20,
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18, color: AppColors.marfim),
                        SizedBox(width: 8),
                        Text('Editar', style: TextStyle(color: AppColors.marfim)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  'Valor atual',
                  'R\$ ${asset.value.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  'Investido',
                  'R\$ ${asset.investedValue.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  'Lucro',
                  'R\$ ${asset.profit.abs().toStringAsFixed(2).replaceAll('.', ',')}',
                  color: isProfit ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTag(asset.type.displayName),
              const SizedBox(width: 8),
              _buildTag(asset.category),
              if (asset.institution != null) ...[
                const SizedBox(width: 8),
                _buildTag(asset.institution!),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.cinza.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppColors.marfim,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.latao.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.cinza.withValues(alpha: 0.8),
          fontSize: 11,
        ),
      ),
    );
  }
}
