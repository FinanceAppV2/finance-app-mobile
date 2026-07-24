import 'package:fpdart/fpdart.dart';

import '../entities/card.dart';
import '../repositories/card_repository.dart';

class CreateCardUseCase {
  final CardRepository _repository;

  CreateCardUseCase(this._repository);

  Future<Either<String, CreditCard>> execute({
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
  }) {
    return _repository.createCard(
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
    );
  }
}