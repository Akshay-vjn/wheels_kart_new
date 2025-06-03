import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/car_models_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/fetch_car_model_repo.dart';

part 'fetch_car_model_event.dart';
part 'fetch_car_model_state.dart';

class EvFetchCarModelBloc
    extends Bloc<EvFetchCarModelEvent, EvFetchCarModelState> {
  EvFetchCarModelBloc() : super(FetchCarModelInitialState()) {
    on<InitialFetchCarModelEvent>(_onFechCarMakeModel);
    on<OnSearchCarModelEvent>(_onSeachCarModel);
  }

  Future<void> _onFechCarMakeModel(InitialFetchCarModelEvent event,
      Emitter<EvFetchCarModelState> emit) async {
    emit(FetchCarModelLoadingState());
    try {
      final snapshot = await FetchCarModelRepo.fetchCarModel(
          event.context, event.makeId, event.makeYear);

      if (snapshot['error'] == false ||
          snapshot['message'] == 'Models list fetched successfully') {
        List data = snapshot['data'];

        emit(FetchCarModelSuccessState(
            listOfCarModel:
                data.map((e) => CarModeModel.fromJson(e)).toList()));
      } else if (snapshot['error'] == true) {
        emit(FetchCarModelErrorState(errorMessage: snapshot['message']));
      } else if (snapshot.isEmpty) {
        emit(FetchCarModelErrorState(errorMessage: 'Car model fetcing failed'));
      }
    } catch (e) {
      emit(FetchCarModelErrorState(errorMessage: e.toString()));
      log('bloc - error - fetch car mode => ${e.toString()}');
    }
  }

  Future<void> _onSeachCarModel(
      OnSearchCarModelEvent event, Emitter<EvFetchCarModelState> emit) async {
    log(event.query);
    try {
      if (event.query.isEmpty) {
        emit(FetchCarModelSuccessState(
            listOfCarModel: event.initialListOfCarModels));
      } else {
        final filteredCarMakes = event.initialListOfCarModels.where((carModel) {
          return carModel.modelName
              .toLowerCase()
              .contains(event.query.toLowerCase());
        }).toList();

        if (filteredCarMakes.isEmpty) {
          if (event.query.isEmpty) {
            emit(FetchCarModelSuccessState(
                listOfCarModel: event.initialListOfCarModels));
          } else {
            emit(SearchCarModelEmtyDataState(emptyMessage: 'No Data Found ! '));
          }
          // log('Empty  search Result ${filteredCarMakes.length}');
        } else {
          // log('Result search ${filteredCarMakes.length}');
          emit(SearchCarModelHasDataState(searchResult: filteredCarMakes));
        }
      }
    } catch (e) {
      log('bloc - error - search car make => ${e.toString()}');
    }
  }
}
