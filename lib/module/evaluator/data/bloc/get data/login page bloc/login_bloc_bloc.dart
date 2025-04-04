import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class EvLoginBlocBloc extends Bloc<EvLoginBlocEvent, EvLoginBlocState> {
  EvLoginBlocBloc() : super(InitializeLoginBloc()) {
    on<ShowPassword>((event, emit) {
      return emit(EvLoginBlocState(isPasswordHide: true));
    });

    on<HidePassword>((event, emit) {
      return emit(EvLoginBlocState(isPasswordHide: false));
    });
  }
}
