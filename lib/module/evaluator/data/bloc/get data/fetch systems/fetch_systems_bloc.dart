import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/system_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_systems_repo.dart';

part 'fetch_systems_event.dart';
part 'fetch_systems_state.dart';

class FetchSystemsBloc extends Bloc<FetchSystemsEvent, FetchSystemsState> {
  FetchSystemsBloc() : super(InitialFetchSystemsState()) {
    on<OnFetchSystemsOfPortions>(_onGetFetchSystemApi);
  }

  Future<void> _onGetFetchSystemApi(
      OnFetchSystemsOfPortions event, Emitter<FetchSystemsState> emit) async {
    emit(LoadingFetchSystemsState());
    final snapshot = await FetchSystemsRepo.getTheSystemsOfPortionForQuestion(
        event.context, event.portionId);

    if (snapshot['error'] == false) {
      List data = snapshot['data'];
      emit(SuccessFetchSystemsState(
          listOfSystemes: data.map((e) => SystemModel.fromJson(e)).toList()));
    } else if (snapshot['error'] == true) {
      emit(ErrorFetchSystemsState(errorMessage: snapshot['message']));
    } else {
      emit(
          ErrorFetchSystemsState(errorMessage: 'Error while fetching portion'));
    }
  }
}
