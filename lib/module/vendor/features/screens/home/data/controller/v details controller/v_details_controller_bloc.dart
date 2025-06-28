import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/repo/v_fetch_car_detail_repo.dart';

part 'v_details_controller_event.dart';
part 'v_details_controller_state.dart';

class VDetailsControllerBloc
    extends Bloc<VDetailsControllerEvent, VDetailsControllerState> {
  VDetailsControllerBloc() : super(VDetailsControllerInitialState()) {
    on<OnFetchDetails>((event, emit) async {
      emit(VDetailsControllerLoadingState());

      final response = await VFetchCarDetailRepo.onGetCarDetails(
        event.context,
        event.inspectionId,
      );

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as Map;
          emit(
            VDetailsControllerSuccessState(
              detail: VCarDetailModel.fromJson(data as Map<String, dynamic>),
            ),
          );
        } else {
          emit(VDetailsControllerErrorState(error: response['message']));
        }
      } else {
        emit(VDetailsControllerErrorState(error: "Empty response"));
      }
    });

    on<OnChangeImageIndex>((event, emit) async {
      final currentState = state;
      if (currentState is VDetailsControllerSuccessState) {
       emit( currentState.coptyWith(currentImageIndex: event.newIndex));
      }
    });
  }
}
