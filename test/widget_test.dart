import 'package:finance_app_mobile/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:finance_app_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class FakeSecureStorage implements FlutterSecureStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      null;
}

void main() {
  setUp(() {
    GetIt.instance.registerLazySingleton<CheckAuthUseCase>(
      () => CheckAuthUseCase(FakeSecureStorage()),
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('App should render splash', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
        home: const SplashPage(),
      ),
    );
    expect(find.text('Finance App'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
