import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/login/fetch_dashboard_data_repo.dart';

part 'ev_fetch_dashboard_event.dart';
part 'ev_fetch_dashboard_state.dart';

class EvFetchDashboardBloc
    extends Bloc<EvFetchDashboardEvent, EvFetchDashboardState> {
  EvFetchDashboardBloc() : super(InitialEvFetchDashboardState()) {
    on<OnGetDashBoadDataEvent>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
      OnGetDashBoadDataEvent event, Emitter<EvFetchDashboardState> emit) async {
    emit(LoadingEvFetchDashboardState());
    final response =
        await FetchDashboardDataRepo.getAllInspections(event.context);
    if (response.isEmpty) {
      emit(ErrorEvFetchDashboardState(errorMessage: 'Dashboard is empty! '));
    } else if (response['error'] == false) {
      final data = response['data'];
      String newRequest = data['newRequests'];
      String progressRequest = data['assignedRequests'];
      String completedRequested = data['completedRequests'];
      emit(SuccessEvFetchDashboardState(
          completedRequested: completedRequested,
          newRequest: newRequest,
          progressRequest: progressRequest));
    } else if (response['error'] == true) {
      emit(ErrorEvFetchDashboardState(errorMessage: response['message']));
    }
  }
}
