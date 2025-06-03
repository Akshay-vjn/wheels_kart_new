part of 'fetch_car_make_bloc.dart';

sealed class EvFetchCarMakeState {}

class FetchCarMakeInitialState extends EvFetchCarMakeState {}

final class FetchCarMakeLoadingState extends EvFetchCarMakeState {}

final class FetchCarMakeSuccessState extends EvFetchCarMakeState {
  final List<CarMakeModel> carMakeData;
  FetchCarMakeSuccessState(this.carMakeData);
}

final class FetchCarMakeErrorState extends EvFetchCarMakeState {
  final String errorData;
  FetchCarMakeErrorState({required this.errorData});
}
