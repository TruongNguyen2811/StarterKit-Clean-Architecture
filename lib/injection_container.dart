import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:starte_kit/injection_container.config.dart';

final getIt = GetIt.instance;
@InjectableInit(
  initializerName: 'injection_container', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.injection_container();
