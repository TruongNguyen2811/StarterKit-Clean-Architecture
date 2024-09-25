import 'package:flutter/material.dart';
import 'package:starte_kit/core/logger/logger.dart';
import 'package:starte_kit/core/routes/app_routes.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final appRoute = AppRoutes.fromPath(
      settings.name ?? '',
    );
    try {
      switch (appRoute) {
        default:
          logger.w(
              'Tried to navigate to a Page not mapped in our Routers ${settings.name}');
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Text('Page Not Found'),
            ),
          );
      }
    } catch (e, s) {
      logger.e('[Routes] - Cannot generate route', error: e, stackTrace: s);
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Text(
            'Page Not Found, make sure you pass the correct arguments',
          ),
        ),
      );
    }
  }
}
