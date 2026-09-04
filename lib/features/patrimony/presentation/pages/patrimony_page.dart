import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/asset_projection.dart';
import '../controllers/asset_controller.dart';
import '../widgets/add_asset_sheet.dart';
import '../widgets/asset_card.dart';
import '../widgets/edit_asset_sheet.dart';

class PatrimonyPage extends StatefulWidget {
  const PatrimonyPage({super.key});

  @override
  State<PatrimonyPage> createState() => _PatrimonyPageState();
}

class _PatrimonyPageState extends State<PatrimonyPage> {
  final _controller = GetIt.instance<AssetController>();
  bool _isLoadingProjection = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    _controller.loadAssets();
    _controller.loadSummary();
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

  void _onAddAsset() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddAssetSheet(),
    ).then((result) {
      if (result == true) {
        _controller.loadAssets();
        _controller.loadSummary();
      }
    });
  }

  Future<void> _onUpdatePrices() async {
    final messenger = ScaffoldMessenger.of(context);
    final success = await _controller.updatePrices();
    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Preços atualizados com sucesso!'
              : _controller.errorMessage ?? 'Erro ao atualizar preços',
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  Future<void> _onShowProjection(Asset asset) async {
    if (_isLoadingProjection) return;
    _isLoadingProjection = true;
    setState(() {});

    await _controller.loadProjection(id: asset.id);

    _isLoadingProjection = false;
    if (!mounted) return;
    setState(() {});

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectionSheet(asset: asset),
    );
  }

  void _onEditAsset(Asset asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditAssetSheet(asset: asset),
    ).then((result) {
      if (result == true) {
        _controller.loadAssets();
        _controller.loadSummary();
      }
    });
  }

  Future<void> _onDeleteAsset(Asset asset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.verdeEscuro,
        title: const Text(
          'Excluir ativo',
          style: TextStyle(color: AppColors.branco),
        ),
        content: Text(
          'Deseja excluir o ativo "${asset.name}"?',
          style: const TextStyle(color: AppColors.cinzaClaro),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.cinzaClaro),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final success = await _controller.deleteAsset(id: asset.id);
    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Ativo excluído com sucesso!'
              : 'Erro ao excluir ativo',
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
        title: const Text('Patrimônios'),
        actions: [
          IconButton(
            onPressed: _onUpdatePrices,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.verdeDestaque),
            tooltip: 'Atualizar preços',
          ),
          IconButton(
            onPressed: _onAddAsset,
            icon: const Icon(Icons.add_rounded, color: AppColors.verdeDestaque),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(),
          if (_isLoadingProjection) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.background.withValues(alpha: 0.6),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.verdeDestaque,
              strokeWidth: 3,
            ),
            SizedBox(height: 12),
            Text(
              'Carregando projeção...',
              style: TextStyle(color: AppColors.cinzaClaro, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.status == AssetStatus.loading &&
        _controller.assets.isEmpty) {
      return const ShimmerLoading(child: _SkeletonPatrimonyPage());
    }

    if (_controller.status == AssetStatus.error &&
        _controller.assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar ativos',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _controller.loadAssets();
                _controller.loadSummary();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.verdeDestaque,
      onRefresh: () async {
        await _controller.loadAssets();
        await _controller.loadSummary();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const Text(
            'Meus Ativos',
            style: TextStyle(
              color: AppColors.branco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_controller.assets.isEmpty)
            _buildEmptyState()
          else
            ..._controller.assets.map(
              (asset) => GestureDetector(
                onTap: _isLoadingProjection ? null : () => _onShowProjection(asset),
                child: AssetCard(
                  asset: asset,
                  onEdit: () => _onEditAsset(asset),
                  onDelete: () => _onDeleteAsset(asset),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final summary = _controller.summary;
    if (summary == null) return const SizedBox.shrink();

    final isProfit = summary.totalProfit >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.verdeEscuro,
            AppColors.verdeEscuro.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isProfit
              ? AppColors.verdeMedio.withValues(alpha: 0.5)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total investido',
                  'R\$ ${summary.totalInvested.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  'Valor atual',
                  'R\$ ${summary.totalCurrentValue.toStringAsFixed(2).replaceAll('.', ',')}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isProfit
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lucro/Prejuízo',
                  style: TextStyle(
                    color: isProfit ? AppColors.success : AppColors.error,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${isProfit ? '+' : '-'}R\$ ${summary.totalProfit.abs().toStringAsFixed(2).replaceAll('.', ',')} (${summary.profitPercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: isProfit ? AppColors.success : AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_rounded,
              size: 64,
              color: AppColors.verdeDestaque.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum ativo cadastrado',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em + para adicionar',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectionSheet extends StatelessWidget {
  final Asset asset;

  static const _monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  const _ProjectionSheet({required this.asset});

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.instance<AssetController>();
    final projection = controller.projection;
    final projectedValues =
        projection?.projectedValues ?? const <ProjectedValue>[];
    final minValue = projectedValues.isEmpty
        ? 0.0
        : projectedValues.map((e) => e.value).reduce(min);
    final maxValue = projectedValues.isEmpty
        ? 0.0
        : projectedValues.map((e) => e.value).reduce(max);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.72,
      ),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.verdeEscuro,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Projeção - ${asset.name}',
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.cinzaClaro),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (projection == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.verdeDestaque,
                        ),
                      ),
                    )
                  else ...[
                    _buildProjectionInfo(projection),
                    const SizedBox(height: 16),
                    const Text(
                      'Projeção para 12 meses:',
                      style: TextStyle(
                        color: AppColors.cinzaClaro,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...projection.projectedValues.map(
                      (pv) => _ProjectionBarItem(
                        monthName: _monthNames[(pv.month - 1) % 12],
                        value: pv.value,
                        minValue: minValue,
                        maxValue: maxValue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectionInfo(AssetProjection projection) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Valor atual',
                style: TextStyle(color: AppColors.cinzaClaro, fontSize: 12),
              ),
              Text(
                'R\$ ${projection.currentValue.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  color: AppColors.branco,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (projection.rate != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Taxa',
                  style: TextStyle(color: AppColors.cinzaClaro, fontSize: 12),
                ),
                Text(
                  '${projection.rate!.toStringAsFixed(2)}% ${projection.rateType ?? ''}',
                  style: const TextStyle(color: AppColors.verdeDestaque),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectionBarItem extends StatelessWidget {
  final String monthName;
  final double value;
  final double minValue;
  final double maxValue;

  const _ProjectionBarItem({
    required this.monthName,
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final range = maxValue - minValue;
    final factor = range <= 0
        ? 1.0
        : 0.12 + ((value - minValue) / range) * 0.88;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                padding: const EdgeInsets.symmetric(vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.verdeMedio.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  monthName,
                  style: const TextStyle(
                    color: AppColors.branco,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  color: AppColors.branco,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: factor,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.verdeMedio, AppColors.verdeDestaque],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPatrimonyPage extends StatelessWidget {
  const _SkeletonPatrimonyPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      children: [
        const SkeletonBox(width: double.infinity, height: 140, borderRadius: 20),
        const SizedBox(height: 24),
        const SkeletonBox(width: 120, height: 18),
        const SizedBox(height: 12),
        ...List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonBox(width: double.infinity, height: 120, borderRadius: 16),
          ),
        ),
      ],
    );
  }
}
