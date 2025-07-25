part of 'my_ocb_controller_bloc.dart';

@immutable
sealed class MyOcbControllerState {}

final class MyOcbControllerInitialState extends MyOcbControllerState {}

final class MyOcbControllerErrorState extends MyOcbControllerState {
  final String error;

  MyOcbControllerErrorState({required this.error});
}

final class MyOncControllerSuccessState extends MyOcbControllerState {
  final List<MyOcbModel> myOcbList;

  MyOncControllerSuccessState({required this.myOcbList});
}

final class MyOcbControllerLoadingState extends MyOcbControllerState {}
