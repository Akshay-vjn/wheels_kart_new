part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VDashboardControlllerEvent {}

class OnFetchVendorDashboardApi extends VDashboardControlllerEvent {
  final BuildContext context;

  OnFetchVendorDashboardApi({required this.context});
}
