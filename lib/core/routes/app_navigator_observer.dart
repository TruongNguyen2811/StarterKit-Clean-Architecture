// ignore_for_file: unused_element, unused_local_variable

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:starte_kit/core/common/bases/enum/page_analytics_type.dart';
import 'package:starte_kit/core/extensions/string_ext.dart';
import 'package:starte_kit/core/logger/logger.dart';

@LazySingleton()
class AppNavigatorObserver extends NavigatorObserver {
  AppNavigatorObserver._();

  factory AppNavigatorObserver() => instance;

  static final AppNavigatorObserver instance = AppNavigatorObserver._();

  final _routeStacks = <String>[];

  List<String> get routeStacks => _routeStacks;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreen(PageAnalyticsType.open.name, route: route);
    _trackScreen(PageAnalyticsType.close.name, route: previousRoute);
    _logEvent('didPush ${route.settings.name}');
    if (route is! PopupRoute) {
      if (route.settings.name.isNotNullOrEmpty) {
        onPushRoute(route.settings.name!);
      }
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logEvent('didRemove ${route.settings.name}');
    if (route is! PopupRoute) {
      if (_routeStacks.isNotEmpty && route.settings.name.isNotNullOrEmpty) {
        onPopRoute(route.settings.name!);
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logEvent('didReplace $oldRoute with $newRoute');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackScreen(PageAnalyticsType.close.name, route: route);
    _trackScreen(PageAnalyticsType.open.name, route: previousRoute);
    if (route.settings.name != null) {
      logger.i('didPop: ${route.settings.name}');
      _routeStacks.removeLast();
    }
  }

  void onPushRoute(String routeName) {
    if (!_routeStacks.contains(routeName)) {
      _routeStacks.add(routeName);
      _logEvent('onPushRoute added $routeName');
    } else {
      _logEvent('onPushPage not add route $routeName as existed');
    }
    _logEvent('currentPage ${_routeStacks.lastOrNull} $_routeStacks');
  }

  void onPopRoute(String routeName) {
    if (_routeStacks.contains(routeName)) {
      _routeStacks.remove(routeName);
      _logEvent('onPopRoute removed $routeName');
    } else {
      _logEvent('onPopRoute cannot removed $routeName as not existed');
    }
    _logEvent('currentPage ${_routeStacks.lastOrNull} $_routeStacks');
  }

  void _logEvent(String message) =>
      logger.d('[AppNavigatorObserver] - $message');

  void _trackScreen(String type, {String? routeName, Route<dynamic>? route}) {
    //ToDo:
  }
}
