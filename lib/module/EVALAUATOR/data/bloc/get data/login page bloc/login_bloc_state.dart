part of 'login_bloc_bloc.dart';

class EvLoginBlocState {
  bool isPasswordHide;
  EvLoginBlocState({required this.isPasswordHide});
}

class InitializeLoginBloc extends EvLoginBlocState {
  InitializeLoginBloc() : super(isPasswordHide: true);
}
