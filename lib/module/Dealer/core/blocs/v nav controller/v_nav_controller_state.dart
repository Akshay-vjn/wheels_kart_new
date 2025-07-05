part of 'v_nav_controller_cubit.dart';

@immutable
sealed class VNavControllerState {
  final int currentIndex;

  VNavControllerState({required this.currentIndex});
}

final class VNavControllerInitial extends VNavControllerState {
  VNavControllerInitial({required super.currentIndex});
}
