part of 'fetch_portions_bloc.dart';

@immutable
sealed class FetchPortionsState {}

final class InitialFetchPortionsState extends FetchPortionsState {}

final class LoadingFetchPortionsState extends FetchPortionsState {}

final class SuccessFetchPortionsState extends FetchPortionsState {
  List<PortionModel> listOfPortios;
  SuccessFetchPortionsState({required this.listOfPortios});
}

final class ErrorFetchPortionsState extends FetchPortionsState {
  String errorMessage;
  ErrorFetchPortionsState({required this.errorMessage});
}
