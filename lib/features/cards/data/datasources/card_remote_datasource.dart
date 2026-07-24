import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/card_model.dart';

class CardRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  CardRemoteDataSource(this._dio, this._storage);

  Future<String> _getUserId() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) throw Exception('Usuário não autenticado');
    return id;
  }

  Future<List<CardModel>> getCards() async {
    final userId = await _getUserId();
    final response = await _dio.get('/users/$userId/cards');
    final list = response.data as List;
    return list.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CardModel> createCard({
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
    final userId = await _getUserId();
    final response = await _dio.post('/users/$userId/cards', data: {
      'nome': nome,
      'emissora': emissora,
      'bandeira': bandeira,
      'finalNumero': finalNumero,
      'nomeTitular': nomeTitular,
      'diaVencimento': diaVencimento,
      'diaFechamento': diaFechamento,
      'limiteDisponivel': limiteDisponivel,
      'cor': cor,
      'icone': icone,
    });
    return CardModel.fromJson(response.data as Map<String, dynamic>);
  }
}