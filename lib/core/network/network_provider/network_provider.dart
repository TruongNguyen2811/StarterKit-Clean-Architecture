// ignore_for_file: implementation_imports
import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/adapters/io_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:starte_kit/core/local_storage/share_preferences.dart';
import 'package:starte_kit/flavors.dart';
import 'package:starte_kit/injection_container.dart';
import 'package:starte_kit/start.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _defaultConnectTimeout = 5 * Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = 5 * Duration.millisecondsPerMinute;
const _keyContentType = 'Content-Type';
const _keyAuthorization = 'Authorization';
const _keyAcceptLanguage = 'Accept-Language';
const _keyAppVersion = 'appVersion';
const _keyDeviceType = 'deviceType';
const _keyAppName = 'appName';
const _keySystemIdentifier = 'systemIdentifier';
const _keyDeviceModel = 'deviceModel';
const _keyVersionOs = 'versionOs';

@module
abstract class NetworkProvider {
  @singleton
  Dio service() => getIt<AppNetworkClient>();
}

@LazySingleton(order: -1)
class AppNetworkClient with DioMixin implements Dio {
  final AppPreferences pref = getIt<AppPreferences>();

  AppNetworkClient() {
    options = BaseOptions(
      baseUrl: F.apiUrl,
      receiveTimeout: const Duration(milliseconds: 60 * 1000 * 2),
      connectTimeout: const Duration(milliseconds: 60 * 1000 * 2),
      contentType: 'application/json',
    )
      ..connectTimeout = const Duration(milliseconds: _defaultConnectTimeout)
      ..receiveTimeout = const Duration(milliseconds: _defaultReceiveTimeout)
      ..headers = {
        _keyContentType: 'application/json; charset=UTF-8',
        _keyAcceptLanguage: 'vi',
      };

    httpClientAdapter = IOHttpClientAdapter();
    if (F.appFlavor != Flavor.prod) {
      interceptors.add(alice.getDioInterceptor());
    }
    interceptors.add(InterceptorsWrapper(
      onRequest: _requestInterceptor,
      onResponse: _responseInterceptor,
      onError: _errorInterceptor,
    ));
    interceptors.addAll(
        [TalkerDioLogger(), CurlLoggerDioInterceptor(printOnSuccess: true)]);
  }

  Future<void> _requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final uuid = await _getId();
    // Static headers
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      this.options.headers[_keyDeviceType] = 'ANDROID';
      options.headers[_keyDeviceType] = 'ANDROID';
      this.options.headers[_keyDeviceModel] = deviceInfo.model;
      options.headers[_keyDeviceModel] = deviceInfo.model;
      this.options.headers[_keyVersionOs] = deviceInfo.version.release;
      options.headers[_keyVersionOs] = deviceInfo.version.release;
    } else if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      this.options.headers[_keyDeviceType] = 'IOS';
      options.headers[_keyDeviceType] = 'IOS';
      this.options.headers[_keyDeviceModel] = deviceInfo.model;
      options.headers[_keyDeviceModel] = deviceInfo.model;
      this.options.headers[_keyVersionOs] = deviceInfo.systemVersion;
      options.headers[_keyVersionOs] = deviceInfo.systemVersion;
    }
    if (uuid != null) {
      this.options.headers[_keySystemIdentifier] = uuid;
      options.headers[_keySystemIdentifier] = uuid;
    }
    this.options.headers[_keyAppVersion] = packageInfo.version;
    options.headers[_keyAppVersion] = packageInfo.version;
    this.options.headers[_keyAppName] = packageInfo.appName;
    options.headers[_keyAppName] = packageInfo.appName;

    ///Thêm token ở đây
    //Todo:
    return handler.next(options);
  }

  Future<void> _responseInterceptor(
      response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }

  Future<void> _errorInterceptor(
      DioException error, ErrorInterceptorHandler handler) async {
    return handler.next(error); //continue
  }

  Future<String?> _getId() async {
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo)
          .identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      // TODO: block for now
      // return await AndroidId().getId(); // unique ID on Android
    }
    return null;
  }
}
