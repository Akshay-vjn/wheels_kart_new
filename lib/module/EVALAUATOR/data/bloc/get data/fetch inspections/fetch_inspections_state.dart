part of 'fetch_inspections_bloc.dart';

@immutable
sealed class FetchInspectionsState {}

final class InitialFetchInspectionsState extends FetchInspectionsState {}

final class LoadingFetchInspectionsState extends FetchInspectionsState {}

final class SuccessFetchInspectionsState extends FetchInspectionsState {
  List<InspectionModel> listOfInspection;
  String message;
  SuccessFetchInspectionsState({required this.listOfInspection,required this.message});
}

final class ErrorFetchInspectionsState extends FetchInspectionsState {
  String errormessage;
  ErrorFetchInspectionsState({required this.errormessage});
}
