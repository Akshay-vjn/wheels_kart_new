part of 'v_details_controller_bloc.dart';

@immutable
sealed class VDetailsControllerState {}

final class VDetailsControllerInitialState extends VDetailsControllerState {}

final class VDetailsControllerErrorState extends VDetailsControllerState {
  final String error;

  VDetailsControllerErrorState({required this.error});
}

final class VDetailsControllerLoadingState extends VDetailsControllerState {}

final class VDetailsControllerSuccessState extends VDetailsControllerState {
  final VCarDetailModel detail;
  final int currentImageIndex;
  final List<bool> enables;
  final int currentImageTabIndex;
  final List<Map<String, dynamic>> currentTabImages;
  final String endTime;

  VDetailsControllerSuccessState({
    required this.detail,
    this.currentImageIndex = 0,
    required this.enables,
    this.currentImageTabIndex = 0,
    this.currentTabImages = const [],
    this.endTime = "00:00:00",
  });

  VDetailsControllerSuccessState coptyWith({
    VCarDetailModel? detail,
    int? currentImageIndex,
    List<bool>? enables,
    int? currentImageTabIndex,
    List<Map<String, dynamic>>? currentTabImages,
    String? endTime,
  }) {
    return VDetailsControllerSuccessState(
      enables: enables ?? this.enables,
      detail: detail ?? this.detail,
      currentTabImages: currentTabImages ?? this.currentTabImages,
      currentImageTabIndex: currentImageTabIndex ?? this.currentImageTabIndex,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      endTime:endTime??this.endTime
    );
  }
}
