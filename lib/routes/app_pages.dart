import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Map<String, Widget Function(BuildContext)> get routes => {
        AppRoutes.splash: (_) => const Scaffold(body: Center(child: Text('Splash'))),
        AppRoutes.login: (_) => const Scaffold(body: Center(child: Text('Login'))),
        AppRoutes.home: (_) => const Scaffold(body: Center(child: Text('Home'))),
      };
}
