part of 'v_ocb_controller_bloc.dart';

@immutable
sealed class VOcbControllerState {}

final class VOcbControlllerInitialState extends VOcbControllerState {}

final class VOcbControlllerLoadingState extends VOcbControllerState {}

final class VOcbControllerErrorState extends VOcbControllerState {
  final String errorMesage;
  VOcbControllerErrorState({required this.errorMesage});
}

final class VOcbControllerSuccessState extends VOcbControllerState {
  final List<VCarModel> sortedAndFilterdOCBList;
  final List<VCarModel> listOfAllOCBFromServer;
  final bool loadingTheOCBButton;
  final bool enableRefreshButton;

  VOcbControllerSuccessState({
    required this.listOfAllOCBFromServer,
    required this.sortedAndFilterdOCBList,
    this.loadingTheOCBButton = false,
    required this.enableRefreshButton,
  });
  VOcbControllerSuccessState copyWith({
    List<VCarModel>? sortedAndFilterdOCBList,
    bool? loadingTheOCBButton,
    bool? enableRefreshButton,
    List<VCarModel>? listOfAllOCBFromServer,
  }) {
    return VOcbControllerSuccessState(
      listOfAllOCBFromServer:
          listOfAllOCBFromServer ?? this.listOfAllOCBFromServer,
      enableRefreshButton: enableRefreshButton ?? this.enableRefreshButton,
      loadingTheOCBButton: loadingTheOCBButton ?? this.loadingTheOCBButton,
      sortedAndFilterdOCBList:
          sortedAndFilterdOCBList ?? this.sortedAndFilterdOCBList,
    );
  }
}
