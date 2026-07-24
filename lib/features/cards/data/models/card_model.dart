import 'package:equatable/equatable.dart';

import '../../domain/entities/card.dart';

class CardModel extends Equatable {
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

  const CardModel({
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

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      nome: json['nome'] as String,
      emissora: json['emissora'] as String,
      bandeira: json['bandeira'] as String,
      finalNumero: json['finalNumero'] as String,
      nomeTitular: json['nomeTitular'] as String,
      diaVencimento: json['diaVencimento'] as int,
      diaFechamento: json['diaFechamento'] as int,
      limiteDisponivel: (json['limiteDisponivel'] as num).toDouble(),
      cor: json['cor'] as String,
      icone: json['icone'] as String,
      ativo: json['ativo'] as bool,
    );
  }

  CreditCard toEntity() {
    return CreditCard(
      id: id,
      userId: userId,
      nome: nome,
      emissora: emissora,
      bandeira: bandeira,
      finalNumero: finalNumero,
      nomeTitular: nomeTitular,
      diaVencimento: diaVencimento,
      diaFechamento: diaFechamento,
      limiteDisponivel: limiteDisponivel,
      cor: cor,
      icone: icone,
      ativo: ativo,
    );
  }

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