import '../../domain/use_cases/auth_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCase authUseCase;

  AuthCubit({required this.authUseCase}) : super(AuthInitial());

  Future<void> fetchData() async {
    emit(const AuthLoading());
    final result = await authUseCase.call();
    result.fold(
      (exception) => emit(AuthError(exception)),
      (_) => emit(const AuthLoaded()),
    );
  }
}

      