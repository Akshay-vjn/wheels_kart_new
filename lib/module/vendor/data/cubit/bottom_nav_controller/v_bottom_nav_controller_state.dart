part of 'v_bottom_nav_controller_cubit.dart';

@immutable
sealed class VBottomNavControllerState {
  final int cuurentIndex;

  const VBottomNavControllerState({this.cuurentIndex = 0});
}

final class VBottomNavControllerInitial extends VBottomNavControllerState {
  const VBottomNavControllerInitial({required int index}) : super(cuurentIndex: index);
}
