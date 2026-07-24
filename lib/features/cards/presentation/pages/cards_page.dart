import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/card.dart';
import '../controllers/cards_controller.dart';
import '../widgets/add_card_sheet.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _controller = GetIt.instance<CardsController>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    _controller.loadCards();
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

  void _onAddCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCardSheet(),
    ).then((result) {
      if (result == true) {
        _controller.loadCards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meus Cartões',
                style: TextStyle(
                  color: AppColors.branco,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _onAddCard,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.verdeDestaque,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppColors.background, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Adicionar',
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_controller.status == CardsStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.verdeDestaque),
      );
    }

    if (_controller.status == CardsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage ?? 'Erro ao carregar cartões',
              style: const TextStyle(color: AppColors.cinzaClaro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.loadCards(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_controller.cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card_rounded,
              size: 64,
              color: AppColors.verdeDestaque.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum cartão cadastrado',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em "Adicionar" para cadastrar',
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _controller.cards.length,
      itemBuilder: (context, index) {
        return _CardWidget(card: _controller.cards[index]);
      },
    );
  }
}

class _CardWidget extends StatelessWidget {
  final CreditCard card;

  const _CardWidget({required this.card});

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

  @override
  Widget build(BuildContext context) {
    final cardColor = _hexToColor(card.cor);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor,
            cardColor.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getIconData(card.icone), color: AppColors.branco, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    card.nome,
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                card.bandeira[0] + card.bandeira.substring(1).toLowerCase(),
                style: TextStyle(
                  color: AppColors.branco.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '•••• •••• •••• ${card.finalNumero}',
            style: const TextStyle(
              color: AppColors.branco,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Titular',
                    style: TextStyle(
                      color: AppColors.branco.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    card.nomeTitular,
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Limite disponível',
                    style: TextStyle(
                      color: AppColors.branco.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'R\$ ${card.limiteDisponivel.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vence dia ${card.diaVencimento}',
                style: TextStyle(
                  color: AppColors.branco.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
              Text(
                'Fecha dia ${card.diaFechamento}',
                style: TextStyle(
                  color: AppColors.branco.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
              Text(
                _formatEmissora(card.emissora),
                style: TextStyle(
                  color: AppColors.branco.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}