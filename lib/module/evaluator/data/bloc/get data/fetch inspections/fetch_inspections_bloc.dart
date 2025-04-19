import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/fetch_inspections.dart';

part 'fetch_inspections_event.dart';
part 'fetch_inspections_state.dart';

class FetchInspectionsBloc
    extends Bloc<FetchInspectionsEvent, FetchInspectionsState> {
  FetchInspectionsBloc() : super(InitialFetchInspectionsState()) {
    on<OnGetInspectionList>(_onGetInspectionData);
  }
  List<InspectionModel> listOfInspection = [];
  Future<void> _onGetInspectionData(
    OnGetInspectionList event,
    Emitter<FetchInspectionsState> emit,
  ) async {
    listOfInspection = [];
    emit(LoadingFetchInspectionsState());
    final snapshot = await FetchInspectionRepo.getInspectionByStatus(
      event.context,
      event.inspetionListType,
    );

    if (snapshot['error'] == false) {
      List data = snapshot['data'];
      String message = snapshot['message'];
      listOfInspection = data.map((e) => InspectionModel.fromJson(e)).toList();
      emit(
        SuccessFetchInspectionsState(
          message: message,
          listOfInspection: listOfInspection,
        ),
      );
    } else if (snapshot['error'] == true) {
      emit(ErrorFetchInspectionsState(errormessage: snapshot['error']));
    } else {
      emit(ErrorFetchInspectionsState(errormessage: 'Inspection has error'));
    }
  }
}
