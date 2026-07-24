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
import 'package:finance_app_mobile/features/cards/data/datasources/card_remote_datasource.dart';
import 'package:finance_app_mobile/features/cards/data/repositories/card_repository_impl.dart';
import 'package:finance_app_mobile/features/cards/domain/repositories/card_repository.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/create_card_usecase.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/get_cards_usecase.dart';
import 'package:finance_app_mobile/features/cards/presentation/controllers/cards_controller.dart';
import 'package:finance_app_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:finance_app_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:finance_app_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_monthly_summary_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_recent_expenses_usecase.dart';
import 'package:finance_app_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:finance_app_mobile/features/finance_config/data/datasources/finance_config_remote_datasource.dart';
import 'package:finance_app_mobile/features/finance_config/data/repositories/finance_config_repository_impl.dart';
import 'package:finance_app_mobile/features/finance_config/domain/repositories/finance_config_repository.dart';
import 'package:finance_app_mobile/features/finance_config/domain/usecases/get_finance_config_usecase.dart';
import 'package:finance_app_mobile/features/finance_config/domain/usecases/update_finance_config_usecase.dart';
import 'package:finance_app_mobile/features/finance_config/presentation/controllers/finance_config_controller.dart';

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

  if (!injector.isRegistered<CardRemoteDataSource>()) {
    injector.registerLazySingleton<CardRemoteDataSource>(
      () => CardRemoteDataSource(injector<Dio>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<CardRepository>()) {
    injector.registerLazySingleton<CardRepository>(
      () => CardRepositoryImpl(injector<CardRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<GetCardsUseCase>()) {
    injector.registerLazySingleton<GetCardsUseCase>(
      () => GetCardsUseCase(injector<CardRepository>()),
    );
  }
  if (!injector.isRegistered<CreateCardUseCase>()) {
    injector.registerLazySingleton<CreateCardUseCase>(
      () => CreateCardUseCase(injector<CardRepository>()),
    );
  }
  if (!injector.isRegistered<CardsController>()) {
    injector.registerLazySingleton<CardsController>(
      () => CardsController(
        injector<GetCardsUseCase>(),
        injector<CreateCardUseCase>(),
      ),
    );
  }

  if (!injector.isRegistered<FinanceConfigRemoteDatasource>()) {
    injector.registerLazySingleton<FinanceConfigRemoteDatasource>(
      () => FinanceConfigRemoteDatasource(
        injector<Dio>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
  if (!injector.isRegistered<FinanceConfigRepository>()) {
    injector.registerLazySingleton<FinanceConfigRepository>(
      () => FinanceConfigRepositoryImpl(
        injector<FinanceConfigRemoteDatasource>(),
      ),
    );
  }
  if (!injector.isRegistered<GetFinanceConfigUseCase>()) {
    injector.registerLazySingleton<GetFinanceConfigUseCase>(
      () => GetFinanceConfigUseCase(injector<FinanceConfigRepository>()),
    );
  }
  if (!injector.isRegistered<UpdateFinanceConfigUseCase>()) {
    injector.registerLazySingleton<UpdateFinanceConfigUseCase>(
      () => UpdateFinanceConfigUseCase(injector<FinanceConfigRepository>()),
    );
  }
  if (!injector.isRegistered<FinanceConfigController>()) {
    injector.registerLazySingleton<FinanceConfigController>(
      () => FinanceConfigController(
        injector<GetFinanceConfigUseCase>(),
        injector<UpdateFinanceConfigUseCase>(),
      ),
    );
  }
}
