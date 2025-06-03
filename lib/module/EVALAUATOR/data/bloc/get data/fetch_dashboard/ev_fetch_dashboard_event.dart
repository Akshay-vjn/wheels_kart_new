part of 'ev_fetch_dashboard_bloc.dart';

@immutable
sealed class EvFetchDashboardEvent {}

class OnGetDashBoadDataEvent extends EvFetchDashboardEvent {
  BuildContext context;
  OnGetDashBoadDataEvent({required this.context});
}
