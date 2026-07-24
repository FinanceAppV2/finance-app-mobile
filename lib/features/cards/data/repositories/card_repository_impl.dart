import 'package:fpdart/fpdart.dart';

import '../../domain/entities/card.dart';
import '../../domain/repositories/card_repository.dart';
import '../datasources/card_remote_datasource.dart';

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource _remoteDataSource;

  CardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<CreditCard>>> getCards() async {
    try {
      final models = await _remoteDataSource.getCards();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao carregar cartões: $e');
    }
  }

  @override
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
  }) async {
    try {
      final model = await _remoteDataSource.createCard(
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
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao cadastrar cartão: $e');
    }
  }
}