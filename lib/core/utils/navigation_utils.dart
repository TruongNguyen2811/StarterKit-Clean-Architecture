import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:starte_kit/core/routes/app_routes.dart';

class NavigationUtils {
  static Future<dynamic> pushNamed(
    BuildContext context,
    AppRoutes appRoutes, {
    Object? arguments,
  }) =>
      Navigator.pushNamed(
        context,
        appRoutes.path(null),
        arguments: arguments,
      );

  static Future<dynamic> pushAndRemoveUtilPage(
    BuildContext context,
    AppRoutes appRoutes, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .pushNamedAndRemoveUntil(
      appRoutes.path(null),
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushAndRemoveUtilKeepFirstPage(
    BuildContext context,
    AppRoutes appRoutes, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .pushNamedAndRemoveUntil(
      appRoutes.path(null),
      ModalRoute.withName(Navigator.defaultRouteName),
      arguments: arguments,
    );
  }

  static void popToFirst(BuildContext context) {
    return Navigator.of(context)
        .popUntil((Route<dynamic> route) => route.isFirst);
  }

  static void popUntilPage(
    BuildContext context, {
    AppRoutes? appRoute,
    dynamic data,
  }) {
    if (appRoute == null) {
      return popToFirst(context);
    }
    return Navigator.of(context).popUntil((route) {
      if (route.settings.name == appRoute.path(null)) {
        if (route.settings.arguments is Map) {
          (route.settings.arguments as Map)['data'] = data;
        }
        return true;
      }
      return false;
    });
  }

  static void popDialog(BuildContext context) {
    Future.delayed(Duration.zero, () {
      return Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  static Future<void> popPage(
    BuildContext context, {
    dynamic result,
  }) async {
    return Future.delayed(Duration.zero, () {
      Navigator.of(context).pop(result);
    });
  }

  static Future<dynamic> rootedPushNamed(
    BuildContext context,
    AppRoutes appRoutes, {
    Object? arguments,
  }) {
    return Navigator.of(context, rootNavigator: true).pushNamed(
      appRoutes.path(null),
      arguments: arguments,
    );
  }

  static Future<dynamic> replacePage(
    BuildContext context,
    AppRoutes appRoutes, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushReplacementNamed(
      appRoutes.path(null),
      arguments: arguments,
    );
  }

  static Future<bool> navigatorPopWebView(
      InAppWebViewController? webViewController) async {
    if (webViewController != null && await webViewController.canGoBack()) {
      await webViewController.goBack();
      return false;
    }
    return true;
  }
}
