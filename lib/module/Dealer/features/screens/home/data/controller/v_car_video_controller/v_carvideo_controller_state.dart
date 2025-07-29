part of 'v_carvideo_controller_cubit.dart';

@immutable
sealed class VCarvideoControllerState {}

final class VCarvideoControllerInitialState extends VCarvideoControllerState {}

final class VCarVideoControllerVideoLoadingState
    extends VCarvideoControllerState {}

final class VCarVideoControllerVideoErrorState
    extends VCarvideoControllerState {
  final String error;

  VCarVideoControllerVideoErrorState({required this.error});
}

final class VCarVideoControllerVideoSuccessState
    extends VCarvideoControllerState {
  final bool isPlaying;
  final int currentIndex;

  VCarVideoControllerVideoSuccessState({
    required this.isPlaying,
    required this.currentIndex,
  });
}
