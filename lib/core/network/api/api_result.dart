import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starte_kit/core/error/network_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;
  const factory ApiResult.failureApi({required String error}) = FailureApi<T>;
  const factory ApiResult.failureNet({required NetworkExceptions error}) =
      FailureNet<T>;
}
