part of 'login_bloc_bloc.dart';

@immutable
abstract class EvLoginBlocEvent {}

class HidePassword extends EvLoginBlocEvent {}

class ShowPassword extends EvLoginBlocEvent {}
