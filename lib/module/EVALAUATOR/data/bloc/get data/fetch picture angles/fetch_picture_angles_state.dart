part of 'fetch_picture_angles_cubit.dart';

@immutable
sealed class FetchPictureAnglesState {
  final List<AngleItem>? flattenedAngles;

  FetchPictureAnglesState({this.flattenedAngles = const []});
}

final class FetchPictureAnglesInitialState extends FetchPictureAnglesState {}

final class FetchPictureAnglesErrorState extends FetchPictureAnglesState {
  final String error;

  FetchPictureAnglesErrorState({required this.error});
}

final class FetchPictureAnglesLoadingState extends FetchPictureAnglesState {}

final class FetchPictureAnglesSuccessState extends FetchPictureAnglesState {
  final Map<String, List<PictureAngleModel>> pictureAnglesByCategory;

  FetchPictureAnglesSuccessState({
    required this.pictureAnglesByCategory,
    required super.flattenedAngles,
  });
}

class AngleItem {
  final String angleId;
  final String angleName;
  final String samplePicture;
  final String category;
  final int categoryIndex;

  AngleItem({
    required this.angleId,
    required this.angleName,
    required this.samplePicture,
    required this.category,
    required this.categoryIndex,
  });
}
