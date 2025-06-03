part of 'ev_fetch_dashboard_bloc.dart';

@immutable
sealed class EvFetchDashboardState {}

final class InitialEvFetchDashboardState extends EvFetchDashboardState {}

final class LoadingEvFetchDashboardState extends EvFetchDashboardState {}

final class SuccessEvFetchDashboardState extends EvFetchDashboardState {
  String newRequest;
  String progressRequest;
  String completedRequested;
  SuccessEvFetchDashboardState(
      {required this.completedRequested,
      required this.newRequest,
      required this.progressRequest});
}

final class ErrorEvFetchDashboardState extends EvFetchDashboardState {
  String errorMessage;
  ErrorEvFetchDashboardState({required this.errorMessage});
}
