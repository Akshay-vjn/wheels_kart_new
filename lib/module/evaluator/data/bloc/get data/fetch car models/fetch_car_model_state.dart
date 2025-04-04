part of 'fetch_car_model_bloc.dart';

sealed class EvFetchCarModelState {}

final class FetchCarModelInitialState extends EvFetchCarModelState {}

final class FetchCarModelLoadingState extends EvFetchCarModelState {}

final class FetchCarModelErrorState extends EvFetchCarModelState {
  String errorMessage;
  FetchCarModelErrorState({required this.errorMessage});
}

final class FetchCarModelSuccessState extends EvFetchCarModelState {
  List<CarModeModel> listOfCarModel;
  FetchCarModelSuccessState({required this.listOfCarModel});
}

final class SearchCarModelEmtyDataState extends EvFetchCarModelState {
  final String emptyMessage;
  SearchCarModelEmtyDataState({required this.emptyMessage});
}

final class SearchCarModelHasDataState extends EvFetchCarModelState {
  List<CarModeModel> searchResult;
  SearchCarModelHasDataState({required this.searchResult});
}
