import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';

part 'v_dashboard_controlller_event.dart';
part 'v_dashboard_controlller_state.dart';

class VDashboardControlllerBloc
    extends Bloc<VDashboardControlllerEvent, VDashboardControlllerState> {
  VDashboardControlllerBloc() : super(VDashboardControlllerInitialState()) {
    on<OnFetchVendorDashboardApi>((event, emit) async {
      emit(VDashboardControlllerLoadingState());
      final response = await VDashboardRepo.getDashboardDataF(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final list=data.map((e) => VCarModel.fromJson(e)).toList();
          emit(
            VDashboardControllerSuccessState(
              listOfCars: list,
            ),
          );
        } else {
          emit(
            VDashboardControllerErrorState(errorMesage: response['message']),
          );
        }
      }
    });
  }
}
