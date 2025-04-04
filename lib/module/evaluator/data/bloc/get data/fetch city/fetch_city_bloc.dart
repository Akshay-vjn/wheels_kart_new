import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/city_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/fetch_city_repo.dart';

part 'fetch_city_event.dart';
part 'fetch_city_state.dart';

class EvFetchCityBloc extends Bloc<EvFetchCityEvent, EvFetchCityState> {
  EvFetchCityBloc() : super(FetchCityInitialState()) {
    on<OnFetchCityDataEvent>(_onFetchcCities);
  }

  Future<void> _onFetchcCities(
    OnFetchCityDataEvent event,
    Emitter<EvFetchCityState> emit,
  ) async {
    emit(FetchCityLoadingState());
    final response = await FetchCitiesRepo.getCityList(event.context);

    if (response['error'] == false ||
        response['message'] == 'Make list fetched successfully') {
      List cities = response['data'];
      final listOfData = cities
          .map(
            (e) => CityModel.fromJson(e),
          )
          .toList();
      emit(FetchCitySuccessSate(listOfCities: listOfData));
    } else if (response['error'] == true) {
      emit(FetchCityErrorState(errorMessage: response['message']));
    } else if (response.isEmpty) {
      emit(FetchCityErrorState(errorMessage: 'Cities not found !'));
    } else {
      emit(FetchCityErrorState(errorMessage: 'Cities not found !'));
    }
  }
}
