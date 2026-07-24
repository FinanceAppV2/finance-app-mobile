import 'package:fpdart/fpdart.dart';

import '../entities/card.dart';

abstract class CardRepository {
  Future<Either<String, List<CreditCard>>> getCards();
  Future<Either<String, CreditCard>> createCard({
    required String nome,
    required String emissora,
    required String bandeira,
    required String finalNumero,
    required String nomeTitular,
    required int diaVencimento,
    required int diaFechamento,
    required double limiteDisponivel,
    required String cor,
    required String icone,
  });
}