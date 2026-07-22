import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_app_mobile/core/network/dio_client.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  final storage = const FlutterSecureStorage();
  injector.registerLazySingleton<FlutterSecureStorage>(() => storage);

  final dioClient = DioClient(storage);
  injector.registerLazySingleton<DioClient>(() => dioClient);
  injector.registerLazySingleton<Dio>(() => dioClient.dio);
}
