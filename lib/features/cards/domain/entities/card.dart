import 'package:equatable/equatable.dart';

class CreditCard extends Equatable {
  final String id;
  final String userId;
  final String nome;
  final String emissora;
  final String bandeira;
  final String finalNumero;
  final String nomeTitular;
  final int diaVencimento;
  final int diaFechamento;
  final double limiteDisponivel;
  final String cor;
  final String icone;
  final bool ativo;

  const CreditCard({
    required this.id,
    required this.userId,
    required this.nome,
    required this.emissora,
    required this.bandeira,
    required this.finalNumero,
    required this.nomeTitular,
    required this.diaVencimento,
    required this.diaFechamento,
    required this.limiteDisponivel,
    required this.cor,
    required this.icone,
    required this.ativo,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        nome,
        emissora,
        bandeira,
        finalNumero,
        nomeTitular,
        diaVencimento,
        diaFechamento,
        limiteDisponivel,
        cor,
        icone,
        ativo,
      ];
}