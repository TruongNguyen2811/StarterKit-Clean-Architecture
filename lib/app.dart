import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:starte_kit/core/routes/app_navigator_observer.dart';
import 'package:starte_kit/core/routes/routes.dart';
import 'package:starte_kit/injection_container.dart';
import 'package:starte_kit/start.dart';

import 'flavors.dart';

NavigatorState get navigator => alice.getNavigatorKey()!.currentState!;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.setLocale(const Locale('vi'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: ScreenUtilInit(
        designSize: const Size(340, 712),
        builder: (context, child) => RefreshConfiguration(
          headerBuilder: () => const MaterialClassicHeader(
            backgroundColor: Colors.blue,
            color: Colors.white,
          ),
          footerBuilder: () => const ClassicFooter(),
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            navigatorKey: alice.getNavigatorKey(),
            navigatorObservers: [
              getIt<AppNavigatorObserver>(),
            ],
            title: F.title,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(backgroundColor: Colors.white)),
            builder: (context, widget) {
              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1)),
                  child: widget!);
            },
            home: child,
          ),
        ),
        child: Container(),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
