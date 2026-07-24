import 'package:flutter/material.dart';

import '../../domain/entities/card.dart';
import '../../domain/usecases/create_card_usecase.dart';
import '../../domain/usecases/get_cards_usecase.dart';

enum CardsStatus { initial, loading, success, error }

class CardsController extends ChangeNotifier {
  final GetCardsUseCase _getCardsUseCase;
  final CreateCardUseCase _createCardUseCase;

  CardsStatus _status = CardsStatus.initial;
  List<CreditCard> _cards = [];
  String? _errorMessage;

  CardsController(this._getCardsUseCase, this._createCardUseCase);

  CardsStatus get status => _status;
  List<CreditCard> get cards => _cards;
  String? get errorMessage => _errorMessage;

  Future<void> loadCards() async {
    _status = CardsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getCardsUseCase.execute();

    result.fold(
      (error) {
        _status = CardsStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (cards) {
        _cards = cards;
        _status = CardsStatus.success;
        notifyListeners();
      },
    );
  }

  Future<bool> createCard({
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
    final result = await _createCardUseCase.execute(
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

    return result.fold(
      (error) {
        _errorMessage = error;
        notifyListeners();
        return false;
      },
      (_) {
        loadCards();
        return true;
      },
    );
  }
}