import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app_mobile/features/home/data/datasources/home_remote_datasource.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  Object? responseBody;
  int statusCode = 200;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (responseBody == null) {
      return ResponseBody.fromString('', statusCode);
    }
    return ResponseBody.fromString(
      jsonEncode(responseBody),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _RecordingAdapter adapter;
  late HomeRemoteDatasource datasource;

  setUp(() {
    adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
      ..httpClientAdapter = adapter;
    datasource = HomeRemoteDatasource(dio, const FlutterSecureStorage());
  });

  group('HomeRemoteDatasource', () {
    test('deleteExpense calls DELETE /expenses/{id}', () async {
      adapter.statusCode = 204;

      await datasource.deleteExpense('exp-1');

      final request = adapter.requests.single;
      expect(request.method, 'DELETE');
      expect(request.uri.path, '/api/expenses/exp-1');
    });

    test('updateExpense calls PUT /expenses/{id} with the expense body', () async {
      await datasource.updateExpense(
        id: 'exp-1',
        description: 'Mercado',
        value: 150.5,
        category: 'FOOD',
        paymentMethod: 'CREDIT_CARD',
        date: DateTime(2026, 10, 5),
        cardId: 'card-1',
        installments: 3,
      );

      final request = adapter.requests.single;
      expect(request.method, 'PUT');
      expect(request.uri.path, '/api/expenses/exp-1');
      expect(request.data, {
        'description': 'Mercado',
        'value': 150.5,
        'category': 'FOOD',
        'paymentMethod': 'CREDIT_CARD',
        'date': '2026-10-05',
        'cardId': 'card-1',
        'installments': 3,
      });
    });

    test('getExpenseById calls GET /expenses/{id} and parses the expense', () async {
      adapter.responseBody = {
        'id': 'exp-1',
        'userId': 'user-1',
        'description': 'Notebook',
        'value': 3000,
        'category': 'OTHERS',
        'paymentMethod': 'CREDIT_CARD',
        'cardId': 'card-1',
        'installments': 10,
        'type': 'EXPENSE',
        'date': '2026-09-10T00:00:00.000Z',
        'createdAt': '2026-09-10T12:00:00.000Z',
        'updatedAt': '2026-09-10T12:00:00.000Z',
      };

      final model = await datasource.getExpenseById('exp-1');

      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.uri.path, '/api/expenses/exp-1');
      expect(model.value, 3000.0);
      expect(model.cardId, 'card-1');
      expect(model.installments, 10);
      expect(model.type, 'EXPENSE');
    });
  });
}
