import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/car_make_model.dart';

part 'search_car_make_event.dart';
part 'search_car_make_state.dart';

class EvSearchCarMakeBloc
    extends Bloc<EvSearchCarMakeEvent, EvSearchCarMakeState> {
  EvSearchCarMakeBloc() : super(SearchCarMakeInitialState()) {
    // Search Car Makes
    on<OnSearchCarMakeEvent>((event, emit) {
      try {
        if (event.query.isEmpty) {
          // log('No Quesry');

          emit(
              SearchListHasDataState(searchResult: event.initialListOfCarMake));
        } else {
          final filteredCarMakes = event.initialListOfCarMake.where((carMake) {
            return carMake.makeName
                .toLowerCase()
                .contains(event.query.toLowerCase());
          }).toList();

          if (filteredCarMakes.isEmpty) {
            emit(SearchListIsEmptyState('No Data Found'));
            // log('Empty  search Result ${filteredCarMakes.length}');
          } else {
            // log('Result search ${filteredCarMakes.length}');
            emit(SearchListHasDataState(searchResult: filteredCarMakes));
          }
        }
      } catch (e) {
        log('bloc - error - search car make => ${e.toString()}');

        debugPrint(e.toString());
      }
    });
  }
}
