import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/my_ocb_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/repo/v_get_my_ocbs_repo.dart';

part 'my_ocb_controller_event.dart';
part 'my_ocb_controller_state.dart';

class MyOcbControllerBloc
    extends Bloc<MyOcbControllerEvent, MyOcbControllerState> {
  MyOcbControllerBloc() : super(MyOcbControllerInitialState()) {
    on<OnFetchMyOCBList>(_onFethcOCB);
  }

  Future<void> _onFethcOCB(
    OnFetchMyOCBList event,
    Emitter<MyOcbControllerState> emit,
  ) async {
    emit(MyOcbControllerLoadingState());
    final response = await VGetMyOcbsRepo.ongetMyOCB(event.context);
    if (response['error'] == true) {
      emit(MyOcbControllerErrorState(error: response['message']));
    } else {
      final list = response['data'] as List;

      emit(
        MyOncControllerSuccessState(
          myOcbList: list.map((e) => MyOcbModel.fromJson(e)).toList(),
        ),
      );
    }
  }
}
