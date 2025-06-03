import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/car_make_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/fetch_car_make_repo.dart';

part 'fetch_car_make_event.dart';
part 'fetch_car_make_state.dart';

class EvFetchCarMakeBloc
    extends Bloc<EvFetchCarMakeEvent, EvFetchCarMakeState> {
  List<CarMakeModel> listOfCarMake = [];
  EvFetchCarMakeBloc() : super(FetchCarMakeInitialState()) {
    on<InitalFetchCarMakeEvent>(_onFetchCarMakeRequested);
  }

  Future<void> _onFetchCarMakeRequested(
    InitalFetchCarMakeEvent event,
    Emitter<EvFetchCarMakeState> emit,
  ) async {
    try {
      emit(FetchCarMakeLoadingState());
      final data = await GetCarMakeRepo.getCarMakeList(event.context);
      if (data['error'] == true &&
          data['message'] == 'Make list fetched successfully') {
        final list = data['data'] as List;
        listOfCarMake = list.map((e) => CarMakeModel.fromJson(e)).toList();

        emit(FetchCarMakeSuccessState(listOfCarMake));
      } else if (data['error'] == true) {
        log(data['message'].toString());
        emit(FetchCarMakeErrorState(errorData: data['message']));
      } else if (data.isEmpty) {
        emit(FetchCarMakeErrorState(errorData: 'Token is Expired'));
      }
    } catch (e) {
      log('bloc - error - fetch car make => ${e.toString()}');

      emit(FetchCarMakeErrorState(errorData: e.toString()));
    }
  }
}
