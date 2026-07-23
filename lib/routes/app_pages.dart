import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Map<String, Widget Function(BuildContext)> get routes => {
        AppRoutes.splash: (_) => const Scaffold(body: Center(child: Text('Splash'))),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.home: (_) => const HomePage(),
      };
}
