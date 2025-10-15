part of 'rsd_controller_cubit.dart';

/// Base state for RSD Controller
sealed class RsdControllerState {}

/// Initial state when RSD controller is created
final class RsdControllerInitialState extends RsdControllerState {}

/// Loading state when fetching RSD data
final class RsdControllerLoadingState extends RsdControllerState {}

/// Success state with RSD list data
final class RsdControllerSuccessState extends RsdControllerState {
  final List<RsdModel> rsdList;

  RsdControllerSuccessState({required this.rsdList});
}

/// Error state with error message
final class RsdControllerErrorState extends RsdControllerState {
  final String errorMessage;

  RsdControllerErrorState({required this.errorMessage});
}



