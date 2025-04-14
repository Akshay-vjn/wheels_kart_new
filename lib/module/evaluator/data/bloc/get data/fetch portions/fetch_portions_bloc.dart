import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/portion_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_portions_repo.dart';

part 'fetch_portions_event.dart';
part 'fetch_portions_state.dart';

class FetchPortionsBloc extends Bloc<FetchPortionsEvent, FetchPortionsState> {
  FetchPortionsBloc() : super(InitialFetchPortionsState()) {
    on<OngetPostionsEvent>(_onFetchPostionsList);
  }

  Future<void> _onFetchPostionsList(
    OngetPostionsEvent event,
    Emitter<FetchPortionsState> emit,
  ) async {
    emit(LoadingFetchPortionsState());

    final snapshot = await FetchPortionsRepo.getThePrtionsForQuestion(
      event.context,
      event.inspectionId,
    );

    if (snapshot['error'] == false) {
      List data = snapshot['data'];
      emit(
        SuccessFetchPortionsState(
          listOfPortios: data.map((e) => PortionModel.fromJson(e)).toList(),
        ),
      );
    } else if (snapshot['error'] == true) {
      emit(ErrorFetchPortionsState(errorMessage: snapshot['message']));
    } else {
      emit(
        ErrorFetchPortionsState(errorMessage: 'Error while Fetching Portion'),
      );
    }
  }
}
