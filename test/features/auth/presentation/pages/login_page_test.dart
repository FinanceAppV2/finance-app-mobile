import 'package:finance_app_mobile/core/theme/app_theme.dart';
import 'package:finance_app_mobile/features/auth/domain/entities/login_result.dart';
import 'package:finance_app_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:finance_app_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:finance_app_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:finance_app_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<String, LoginResult>> login({
    required String login,
    required String password,
  }) async => const Left('Credenciais inválidas');
}

void main() {
  setUp(() {
    GetIt.instance.registerLazySingleton<AuthController>(
      () => AuthController(
        LoginUseCase(_FakeAuthRepository()),
        const FlutterSecureStorage(),
      ),
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Future<void> pumpLogin(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        routes: {'/register': (_) => const Scaffold(body: Text('Cadastro'))},
        home: const LoginPage(),
      ),
    );
  }

  testWidgets('renders the Leme login layout', (tester) async {
    await pumpLogin(tester, const Size(390, 844));

    for (final text in [
      'Leme',
      'Bem-vindo de volta',
      'Entre para ver como está o seu mês.',
      'E-mail, CPF ou telefone',
      'Senha',
      'voce@email.com',
      'Sua senha',
      'Lembrar-me',
      'Esqueci a senha',
      'Entrar',
      'Ainda não tem conta? ',
      'Criar conta',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }

    // O rodapé fica preso ao fim da tela, como no design.
    final footerBottom = tester.getBottomLeft(find.text('Criar conta')).dy;
    expect(footerBottom, greaterThan(844 - 60));
  });

  testWidgets('fits small screens by scrolling', (tester) async {
    await pumpLogin(tester, const Size(320, 568));

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Criar conta'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Criar conta'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await pumpLogin(tester, const Size(390, 844));

    EditableText passwordField() => tester.widget<EditableText>(
      find.descendant(
        of: find.byType(TextFormField).at(1),
        matching: find.byType(EditableText),
      ),
    );

    expect(passwordField().obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();
    expect(passwordField().obscureText, isFalse);
    expect(find.byTooltip('Ocultar senha'), findsOneWidget);
  });

  testWidgets('validates empty fields', (tester) async {
    await pumpLogin(tester, const Size(390, 844));

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Campo é obrigatório'), findsOneWidget);
    expect(find.text('Senha é obrigatória'), findsOneWidget);
  });

  testWidgets('shows the API error in a snackbar', (tester) async {
    await pumpLogin(tester, const Size(390, 844));

    await tester.enterText(find.byType(TextFormField).at(0), 'voce@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Credenciais inválidas'), findsOneWidget);
  });

  testWidgets('opens the sign up page', (tester) async {
    await pumpLogin(tester, const Size(390, 844));

    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastro'), findsOneWidget);
  });
}
