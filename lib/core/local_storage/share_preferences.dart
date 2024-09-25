import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  // Không được sửa dòng Order này nếu không hiểu!
  // ignore: invalid_annotation_target
  @Order(-4)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

// Make sure this is always registered before everything else
@LazySingleton(order: -3)
class AppPreferences {
  final SharedPreferences _preference;

  AppPreferences(this._preference);
}
