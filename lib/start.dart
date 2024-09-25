
import 'package:alice/alice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starte_kit/app.dart';
import 'package:starte_kit/core/localizations/localizations.dart';
import 'package:starte_kit/flavors.dart';
import 'package:starte_kit/injection_container.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Alice alice = Alice(
  showNotification: false,
  showInspectorOnShake: F.appFlavor != Flavor.prod,
);

Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage
      .call(_firebaseMessagingBackgroundHandler);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    Bloc.observer = SimpleBlocObserver();
    runApp(
      EasyLocalization(
        supportedLocales: SUPPORTED_LOCALES,
        path: 'assets/translations',
        fallbackLocale: DEFAULT_LOCALE,
        startLocale: DEFAULT_LOCALE,
        child: const App(),
      ),
    );
  });
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
  }
}
