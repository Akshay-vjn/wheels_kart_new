part of 'app_navigation_cubit.dart';

@immutable
sealed class EvAppNavigationState {}

final class AppNavigationInitialState extends EvAppNavigationState {
  int initailIndex;
  AppNavigationInitialState({required this.initailIndex});
}
