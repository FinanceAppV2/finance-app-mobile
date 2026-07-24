import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_app_mobile/core/network/dio_client.dart';
import 'package:finance_app_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:finance_app_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_app_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:finance_app_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:finance_app_mobile/features/auth/presentation/controllers/register_controller.dart';
import 'package:finance_app_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:finance_app_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:finance_app_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_monthly_summary_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_recent_expenses_usecase.dart';
import 'package:finance_app_mobile/features/home/presentation/controllers/home_controller.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  final storage = const FlutterSecureStorage();
  if (!injector.isRegistered<FlutterSecureStorage>()) {
    injector.registerLazySingleton<FlutterSecureStorage>(() => storage);
  }

  final dioClient = DioClient(storage);
  if (!injector.isRegistered<DioClient>()) {
    injector.registerLazySingleton<DioClient>(() => dioClient);
  }
  if (!injector.isRegistered<Dio>()) {
    injector.registerLazySingleton<Dio>(() => dioClient.dio);
  }

  if (!injector.isRegistered<AuthRemoteDataSource>()) {
    injector.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(injector<Dio>()),
    );
  }
  if (!injector.isRegistered<AuthRepository>()) {
    injector.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(injector<AuthRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<LoginUseCase>()) {
    injector.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(injector<AuthRepository>()),
    );
  }
  if (!injector.isRegistered<RegisterUseCase>()) {
    injector.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(injector<AuthRepository>()),
    );
  }
  if (!injector.isRegistered<CheckAuthUseCase>()) {
    injector.registerLazySingleton<CheckAuthUseCase>(
      () => CheckAuthUseCase(injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<AuthController>()) {
    injector.registerLazySingleton<AuthController>(
      () => AuthController(injector<LoginUseCase>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<RegisterController>()) {
    injector.registerLazySingleton<RegisterController>(
      () => RegisterController(injector<RegisterUseCase>()),
    );
  }

  if (!injector.isRegistered<HomeRemoteDatasource>()) {
    injector.registerLazySingleton<HomeRemoteDatasource>(
      () => HomeRemoteDatasource(injector<Dio>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<HomeRepository>()) {
    injector.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(injector<HomeRemoteDatasource>()),
    );
  }
  if (!injector.isRegistered<GetMonthlySummaryUseCase>()) {
    injector.registerLazySingleton<GetMonthlySummaryUseCase>(
      () => GetMonthlySummaryUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<GetRecentExpensesUseCase>()) {
    injector.registerLazySingleton<GetRecentExpensesUseCase>(
      () => GetRecentExpensesUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<HomeController>()) {
    injector.registerLazySingleton<HomeController>(
      () => HomeController(
        injector<GetMonthlySummaryUseCase>(),
        injector<GetRecentExpensesUseCase>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
}
