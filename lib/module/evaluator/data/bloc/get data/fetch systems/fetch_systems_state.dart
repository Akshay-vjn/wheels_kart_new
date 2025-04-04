part of 'fetch_systems_bloc.dart';

@immutable
sealed class FetchSystemsState {}

final class InitialFetchSystemsState extends FetchSystemsState {}

final class LoadingFetchSystemsState extends FetchSystemsState {}

final class SuccessFetchSystemsState extends FetchSystemsState {
  List<SystemModel> listOfSystemes;
  SuccessFetchSystemsState({required this.listOfSystemes});
}

final class ErrorFetchSystemsState extends FetchSystemsState {
  String errorMessage;
  ErrorFetchSystemsState({required this.errorMessage});
}
