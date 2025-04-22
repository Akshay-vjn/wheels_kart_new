part of 'fetch_picture_angles_cubit.dart';

@immutable
sealed class FetchPictureAnglesState {}

final class FetchPictureAnglesInitialState extends FetchPictureAnglesState {}

final class FetchPictureAnglesErrorState extends FetchPictureAnglesState {
  final String error;

  FetchPictureAnglesErrorState({required this.error});
}

final class FetchPictureAnglesLoadingState extends FetchPictureAnglesState {}

final class FetchPictureAnglesSuccessState extends FetchPictureAnglesState {
  final List<PictureAngleModel> pictureAngles;

  FetchPictureAnglesSuccessState({required this.pictureAngles});
}
