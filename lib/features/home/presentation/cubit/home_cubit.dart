import '../../domain/use_cases/home_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;

  HomeCubit({required this.homeUseCase}) : super(HomeInitial());

  Future<void> fetchData() async {
    emit(const HomeLoading());
    final result = await homeUseCase.call();
    result.fold(
      (exception) => emit(HomeError(exception)),
      (_) => emit(const HomeLoaded()),
    );
  }
}

      