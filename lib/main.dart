import 'dart:async';
import 'package:starte_kit/flavors.dart';
import 'package:starte_kit/start.dart';

FutureOr<void> main() async {
  F.appFlavor = Flavor.prod;
  await start();
}
