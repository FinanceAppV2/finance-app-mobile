import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_app_mobile/core/network/dio_client.dart';
import 'package:finance_app_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:finance_app_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_app_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:finance_app_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:finance_app_mobile/features/auth/presentation/controllers/register_controller.dart';
import 'package:finance_app_mobile/features/cards/data/datasources/card_remote_datasource.dart';
import 'package:finance_app_mobile/features/cards/data/repositories/card_repository_impl.dart';
import 'package:finance_app_mobile/features/cards/domain/repositories/card_repository.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/create_card_usecase.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/delete_card_usecase.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/get_cards_usecase.dart';
import 'package:finance_app_mobile/features/cards/domain/usecases/update_card_usecase.dart';
import 'package:finance_app_mobile/features/cards/presentation/controllers/cards_controller.dart';
import 'package:finance_app_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:finance_app_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:finance_app_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_monthly_summary_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_recent_expenses_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_current_salary_cycle_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/get_expense_by_id_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/delete_expense_usecase.dart';
import 'package:finance_app_mobile/features/home/domain/usecases/update_expense_usecase.dart';
import 'package:finance_app_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:finance_app_mobile/features/finance_config/data/datasources/finance_config_remote_datasource.dart';
import 'package:finance_app_mobile/features/finance_config/data/repositories/finance_config_repository_impl.dart';
import 'package:finance_app_mobile/features/finance_config/domain/repositories/finance_config_repository.dart';
import 'package:finance_app_mobile/features/finance_config/domain/usecases/get_finance_config_usecase.dart';
import 'package:finance_app_mobile/features/finance_config/domain/usecases/update_finance_config_usecase.dart';
import 'package:finance_app_mobile/features/finance_config/presentation/controllers/finance_config_controller.dart';
import 'package:finance_app_mobile/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:finance_app_mobile/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:finance_app_mobile/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:finance_app_mobile/features/expenses/domain/usecases/create_expense_usecase.dart';
import 'package:finance_app_mobile/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:finance_app_mobile/features/fixed_expenses/data/datasources/fixed_expense_remote_datasource.dart';
import 'package:finance_app_mobile/features/fixed_expenses/data/repositories/fixed_expenses_repository_impl.dart';
import 'package:finance_app_mobile/features/fixed_expenses/domain/repositories/fixed_expenses_repository.dart';
import 'package:finance_app_mobile/features/fixed_expenses/domain/usecases/get_fixed_expenses_usecase.dart';
import 'package:finance_app_mobile/features/fixed_expenses/domain/usecases/create_fixed_expense_usecase.dart';
import 'package:finance_app_mobile/features/fixed_expenses/presentation/controllers/fixed_expenses_controller.dart';
import 'package:finance_app_mobile/features/patrimony/data/datasources/asset_remote_datasource.dart';
import 'package:finance_app_mobile/features/patrimony/data/repositories/asset_repository_impl.dart';
import 'package:finance_app_mobile/features/patrimony/domain/repositories/asset_repository.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/create_asset_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/delete_asset_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/get_asset_projection_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/get_asset_summary_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/get_assets_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/update_asset_prices_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/domain/usecases/update_asset_usecase.dart';
import 'package:finance_app_mobile/features/patrimony/presentation/controllers/asset_controller.dart';
import 'package:finance_app_mobile/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:finance_app_mobile/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:finance_app_mobile/features/reports/domain/repositories/reports_repository.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/generate_ai_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_categories_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_fixed_vs_variable_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_highest_month_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_monthly_trend_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_payment_methods_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_chart_top_expenses_usecase.dart';
import 'package:finance_app_mobile/features/reports/domain/usecases/get_salary_cycle_history_usecase.dart';
import 'package:finance_app_mobile/features/reports/presentation/controllers/reports_controller.dart';
import 'package:finance_app_mobile/features/loans/data/datasources/loan_remote_datasource.dart';
import 'package:finance_app_mobile/features/loans/data/repositories/loan_repository_impl.dart';
import 'package:finance_app_mobile/features/loans/domain/repositories/loan_repository.dart';
import 'package:finance_app_mobile/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:finance_app_mobile/features/loans/domain/usecases/delete_loan_usecase.dart';
import 'package:finance_app_mobile/features/loans/domain/usecases/get_loans_usecase.dart';
import 'package:finance_app_mobile/features/loans/domain/usecases/update_loan_usecase.dart';
import 'package:finance_app_mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:finance_app_mobile/features/plans/data/datasources/plan_remote_datasource.dart';
import 'package:finance_app_mobile/features/plans/data/repositories/plan_repository_impl.dart';
import 'package:finance_app_mobile/features/plans/domain/repositories/plan_repository.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/get_plans_usecase.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/get_user_plan_usecase.dart';
import 'package:finance_app_mobile/features/plans/domain/usecases/subscribe_plan_usecase.dart';
import 'package:finance_app_mobile/features/plans/presentation/controllers/plans_controller.dart';
import 'package:finance_app_mobile/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:finance_app_mobile/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:finance_app_mobile/features/notifications/domain/repositories/notification_repository.dart';
import 'package:finance_app_mobile/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:finance_app_mobile/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:finance_app_mobile/features/home/domain/controllers/notification_badge_controller.dart';

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
  if (!injector.isRegistered<UpdateProfileUseCase>()) {
    injector.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(injector<AuthRepository>()),
    );
  }
  if (!injector.isRegistered<ChangePasswordUseCase>()) {
    injector.registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(injector<AuthRepository>()),
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
  if (!injector.isRegistered<GetExpenseByIdUseCase>()) {
    injector.registerLazySingleton<GetExpenseByIdUseCase>(
      () => GetExpenseByIdUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<DeleteExpenseUseCase>()) {
    injector.registerLazySingleton<DeleteExpenseUseCase>(
      () => DeleteExpenseUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<UpdateExpenseUseCase>()) {
    injector.registerLazySingleton<UpdateExpenseUseCase>(
      () => UpdateExpenseUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<GetCurrentSalaryCycleUseCase>()) {
    injector.registerLazySingleton<GetCurrentSalaryCycleUseCase>(
      () => GetCurrentSalaryCycleUseCase(injector<HomeRepository>()),
    );
  }
  if (!injector.isRegistered<HomeController>()) {
    injector.registerLazySingleton<HomeController>(
      () => HomeController(
        injector<GetMonthlySummaryUseCase>(),
        injector<GetRecentExpensesUseCase>(),
        injector<GetFixedExpensesUseCase>(),
        injector<GetExpenseByIdUseCase>(),
        injector<DeleteExpenseUseCase>(),
        injector<UpdateExpenseUseCase>(),
        injector<GetCurrentSalaryCycleUseCase>(),
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
  if (!injector.isRegistered<UpdateCardUseCase>()) {
    injector.registerLazySingleton<UpdateCardUseCase>(
      () => UpdateCardUseCase(injector<CardRepository>()),
    );
  }
  if (!injector.isRegistered<DeleteCardUseCase>()) {
    injector.registerLazySingleton<DeleteCardUseCase>(
      () => DeleteCardUseCase(injector<CardRepository>()),
    );
  }
  if (!injector.isRegistered<CardsController>()) {
    injector.registerLazySingleton<CardsController>(
      () => CardsController(
        injector<GetCardsUseCase>(),
        injector<CreateCardUseCase>(),
        injector<UpdateCardUseCase>(),
        injector<DeleteCardUseCase>(),
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

  if (!injector.isRegistered<ExpenseRemoteDataSource>()) {
    injector.registerLazySingleton<ExpenseRemoteDataSource>(
      () => ExpenseRemoteDataSource(
        injector<Dio>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
  if (!injector.isRegistered<ExpensesRepository>()) {
    injector.registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(injector<ExpenseRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<CreateExpenseUseCase>()) {
    injector.registerLazySingleton<CreateExpenseUseCase>(
      () => CreateExpenseUseCase(injector<ExpensesRepository>()),
    );
  }
  if (!injector.isRegistered<ExpenseController>()) {
    injector.registerLazySingleton<ExpenseController>(
      () => ExpenseController(injector<CreateExpenseUseCase>()),
    );
  }

  if (!injector.isRegistered<FixedExpenseRemoteDataSource>()) {
    injector.registerLazySingleton<FixedExpenseRemoteDataSource>(
      () => FixedExpenseRemoteDataSource(
        injector<Dio>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
  if (!injector.isRegistered<FixedExpensesRepository>()) {
    injector.registerLazySingleton<FixedExpensesRepository>(
      () => FixedExpensesRepositoryImpl(
        injector<FixedExpenseRemoteDataSource>(),
      ),
    );
  }
  if (!injector.isRegistered<GetFixedExpensesUseCase>()) {
    injector.registerLazySingleton<GetFixedExpensesUseCase>(
      () => GetFixedExpensesUseCase(injector<FixedExpensesRepository>()),
    );
  }
  if (!injector.isRegistered<CreateFixedExpenseUseCase>()) {
    injector.registerLazySingleton<CreateFixedExpenseUseCase>(
      () => CreateFixedExpenseUseCase(injector<FixedExpensesRepository>()),
    );
  }
  if (!injector.isRegistered<FixedExpensesController>()) {
    injector.registerLazySingleton<FixedExpensesController>(
      () => FixedExpensesController(
        injector<GetFixedExpensesUseCase>(),
        injector<CreateFixedExpenseUseCase>(),
      ),
    );
  }

  if (!injector.isRegistered<AssetRemoteDataSource>()) {
    injector.registerLazySingleton<AssetRemoteDataSource>(
      () => AssetRemoteDataSource(
        injector<Dio>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
  if (!injector.isRegistered<AssetRepository>()) {
    injector.registerLazySingleton<AssetRepository>(
      () => AssetRepositoryImpl(injector<AssetRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<GetAssetsUseCase>()) {
    injector.registerLazySingleton<GetAssetsUseCase>(
      () => GetAssetsUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<GetAssetSummaryUseCase>()) {
    injector.registerLazySingleton<GetAssetSummaryUseCase>(
      () => GetAssetSummaryUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<CreateAssetUseCase>()) {
    injector.registerLazySingleton<CreateAssetUseCase>(
      () => CreateAssetUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<UpdateAssetUseCase>()) {
    injector.registerLazySingleton<UpdateAssetUseCase>(
      () => UpdateAssetUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<DeleteAssetUseCase>()) {
    injector.registerLazySingleton<DeleteAssetUseCase>(
      () => DeleteAssetUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<UpdateAssetPricesUseCase>()) {
    injector.registerLazySingleton<UpdateAssetPricesUseCase>(
      () => UpdateAssetPricesUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<GetAssetProjectionUseCase>()) {
    injector.registerLazySingleton<GetAssetProjectionUseCase>(
      () => GetAssetProjectionUseCase(injector<AssetRepository>()),
    );
  }
  if (!injector.isRegistered<AssetController>()) {
    injector.registerLazySingleton<AssetController>(
      () => AssetController(
        injector<GetAssetsUseCase>(),
        injector<GetAssetSummaryUseCase>(),
        injector<CreateAssetUseCase>(),
        injector<UpdateAssetUseCase>(),
        injector<DeleteAssetUseCase>(),
        injector<UpdateAssetPricesUseCase>(),
        injector<GetAssetProjectionUseCase>(),
      ),
    );
  }

  if (!injector.isRegistered<ReportsRemoteDataSource>()) {
    injector.registerLazySingleton<ReportsRemoteDataSource>(
      () => ReportsRemoteDataSource(
        injector<Dio>(),
        injector<FlutterSecureStorage>(),
      ),
    );
  }
  if (!injector.isRegistered<ReportsRepository>()) {
    injector.registerLazySingleton<ReportsRepository>(
      () => ReportsRepositoryImpl(injector<ReportsRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<GetChartPaymentMethodsUseCase>()) {
    injector.registerLazySingleton<GetChartPaymentMethodsUseCase>(
      () => GetChartPaymentMethodsUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetChartCategoriesUseCase>()) {
    injector.registerLazySingleton<GetChartCategoriesUseCase>(
      () => GetChartCategoriesUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetChartHighestMonthUseCase>()) {
    injector.registerLazySingleton<GetChartHighestMonthUseCase>(
      () => GetChartHighestMonthUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetChartMonthlyTrendUseCase>()) {
    injector.registerLazySingleton<GetChartMonthlyTrendUseCase>(
      () => GetChartMonthlyTrendUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetChartFixedVsVariableUseCase>()) {
    injector.registerLazySingleton<GetChartFixedVsVariableUseCase>(
      () => GetChartFixedVsVariableUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetChartTopExpensesUseCase>()) {
    injector.registerLazySingleton<GetChartTopExpensesUseCase>(
      () => GetChartTopExpensesUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GetSalaryCycleHistoryUseCase>()) {
    injector.registerLazySingleton<GetSalaryCycleHistoryUseCase>(
      () => GetSalaryCycleHistoryUseCase(injector<ReportsRepository>()),
    );
  }
  if (!injector.isRegistered<GenerateAiUseCase>()) {
    injector.registerLazySingleton<GenerateAiUseCase>(
      () => GenerateAiUseCase(injector<ReportsRepository>()),
    );
  }
  if (injector.isRegistered<ReportsController>()) {
    await injector.unregister<ReportsController>(
      disposingFunction: (controller) => controller.dispose(),
    );
  }
  injector.registerLazySingleton<ReportsController>(
    () => ReportsController(
      injector<GetChartPaymentMethodsUseCase>(),
      injector<GetChartCategoriesUseCase>(),
      injector<GetChartHighestMonthUseCase>(),
      injector<GetChartMonthlyTrendUseCase>(),
      injector<GetChartFixedVsVariableUseCase>(),
      injector<GetChartTopExpensesUseCase>(),
      injector<GetSalaryCycleHistoryUseCase>(),
      injector<GenerateAiUseCase>(),
      injector<ReportsRepository>(),
    ),
  );

  if (!injector.isRegistered<LoanRemoteDataSource>()) {
    injector.registerLazySingleton<LoanRemoteDataSource>(
      () => LoanRemoteDataSource(injector<Dio>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<LoanRepository>()) {
    injector.registerLazySingleton<LoanRepository>(
      () => LoanRepositoryImpl(injector<LoanRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<GetLoansUseCase>()) {
    injector.registerLazySingleton<GetLoansUseCase>(
      () => GetLoansUseCase(injector<LoanRepository>()),
    );
  }
  if (!injector.isRegistered<CreateLoanUseCase>()) {
    injector.registerLazySingleton<CreateLoanUseCase>(
      () => CreateLoanUseCase(injector<LoanRepository>()),
    );
  }
  if (!injector.isRegistered<UpdateLoanUseCase>()) {
    injector.registerLazySingleton<UpdateLoanUseCase>(
      () => UpdateLoanUseCase(injector<LoanRepository>()),
    );
  }
  if (!injector.isRegistered<DeleteLoanUseCase>()) {
    injector.registerLazySingleton<DeleteLoanUseCase>(
      () => DeleteLoanUseCase(injector<LoanRepository>()),
    );
  }
  if (!injector.isRegistered<LoansController>()) {
    injector.registerLazySingleton<LoansController>(
      () => LoansController(
        injector<GetLoansUseCase>(),
        injector<CreateLoanUseCase>(),
        injector<UpdateLoanUseCase>(),
        injector<DeleteLoanUseCase>(),
      ),
    );
  }

  // Plan Dependencies
  if (!injector.isRegistered<PlanRemoteDataSource>()) {
    injector.registerLazySingleton<PlanRemoteDataSource>(
      () => PlanRemoteDataSource(injector<Dio>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<PlanRepository>()) {
    injector.registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(injector<PlanRemoteDataSource>()),
    );
  }
  if (!injector.isRegistered<GetPlansUseCase>()) {
    injector.registerLazySingleton<GetPlansUseCase>(
      () => GetPlansUseCase(injector<PlanRepository>()),
    );
  }
  if (!injector.isRegistered<GetUserPlanUseCase>()) {
    injector.registerLazySingleton<GetUserPlanUseCase>(
      () => GetUserPlanUseCase(injector<PlanRepository>()),
    );
  }
  if (!injector.isRegistered<SubscribePlanUseCase>()) {
    injector.registerLazySingleton<SubscribePlanUseCase>(
      () => SubscribePlanUseCase(injector<PlanRepository>()),
    );
  }
  if (!injector.isRegistered<PlansController>()) {
    injector.registerLazySingleton<PlansController>(
      () => PlansController(
        injector<GetPlansUseCase>(),
        injector<GetUserPlanUseCase>(),
        injector<SubscribePlanUseCase>(),
      ),
    );
  }

  // Notification Dependencies
  if (!injector.isRegistered<NotificationRemoteDatasource>()) {
    injector.registerLazySingleton<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasource(injector<Dio>(), injector<FlutterSecureStorage>()),
    );
  }
  if (!injector.isRegistered<NotificationRepository>()) {
    injector.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(injector<NotificationRemoteDatasource>()),
    );
  }
  if (!injector.isRegistered<GetAllNotificationsUseCase>()) {
    injector.registerLazySingleton<GetAllNotificationsUseCase>(
      () => GetAllNotificationsUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<GetUnreadNotificationsUseCase>()) {
    injector.registerLazySingleton<GetUnreadNotificationsUseCase>(
      () => GetUnreadNotificationsUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<CountUnreadNotificationsUseCase>()) {
    injector.registerLazySingleton<CountUnreadNotificationsUseCase>(
      () => CountUnreadNotificationsUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<MarkAsReadUseCase>()) {
    injector.registerLazySingleton<MarkAsReadUseCase>(
      () => MarkAsReadUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<MarkAllAsReadUseCase>()) {
    injector.registerLazySingleton<MarkAllAsReadUseCase>(
      () => MarkAllAsReadUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<CreateNotificationUseCase>()) {
    injector.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<DeleteNotificationUseCase>()) {
    injector.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(injector<NotificationRepository>()),
    );
  }
  if (!injector.isRegistered<NotificationController>()) {
    injector.registerLazySingleton<NotificationController>(
      () => NotificationController(
        injector<GetAllNotificationsUseCase>(),
        injector<GetUnreadNotificationsUseCase>(),
        injector<CountUnreadNotificationsUseCase>(),
        injector<MarkAsReadUseCase>(),
        injector<MarkAllAsReadUseCase>(),
        injector<DeleteNotificationUseCase>(),
      ),
    );
  }
  if (!injector.isRegistered<NotificationBadgeController>()) {
    injector.registerLazySingleton<NotificationBadgeController>(
      () => NotificationBadgeController(
        injector<CountUnreadNotificationsUseCase>(),
      ),
    );
  }
}
