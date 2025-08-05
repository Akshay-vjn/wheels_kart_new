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
            SearchListHasDataState(
              searchResult: event.initialListOfCarMake,
              selectedCarMakeId: null,
            ),
          );
        } else {
          final filteredCarMakes =
              event.initialListOfCarMake.where((carMake) {
                return carMake.makeName.toLowerCase().contains(
                  event.query.toLowerCase(),
                );
              }).toList();

          if (filteredCarMakes.isEmpty) {
            emit(SearchListIsEmptyState('No Data Found'));
            // log('Empty  search Result ${filteredCarMakes.length}');
          } else {
            // log('Result search ${filteredCarMakes.length}');
            emit(
              SearchListHasDataState(
                searchResult: filteredCarMakes,
                selectedCarMakeId: null,
              ),
            );
          }
        }
      } catch (e) {
        log('bloc - error - search car make => ${e.toString()}');

        debugPrint(e.toString());
      }
    });

    on<OnSelectCarMake>((event, emit) {
      log("ggdgdgd");
      final currentState = state;
      if (currentState is SearchListHasDataState) {
        log("done");
        emit(currentState.copyWith(selectedCarMakeId: event.selectedMakeId));
      } 
    });
  }
}
