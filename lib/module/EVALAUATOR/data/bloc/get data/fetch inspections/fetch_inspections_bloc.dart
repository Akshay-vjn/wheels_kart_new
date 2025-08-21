import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/fetch_live_inspections.dart';

part 'fetch_inspections_event.dart';
part 'fetch_inspections_state.dart';

class FetchInspectionsBloc
    extends Bloc<FetchInspectionsEvent, FetchInspectionsState> {
  FetchInspectionsBloc() : super(InitialFetchInspectionsState()) {
    on<OnGetInspectionList>(_onGetInspectionData);
  }
  List<InspectionModel> listOfLiveInspection = [];
  Future<void> _onGetInspectionData(
    OnGetInspectionList event,
    Emitter<FetchInspectionsState> emit,
  ) async {
    listOfLiveInspection = [];
    emit(LoadingFetchInspectionsState());
    final snapshot = await FetchInspectionRepo.getInspections(
      event.context,
      event.inspetionListType,
    );

    if (snapshot['error'] == false) {
      List data = snapshot['data'];
      String message = snapshot['message'];
      listOfLiveInspection =
          data.map((e) => InspectionModel.fromJson(e)).toList();
      emit(
        SuccessFetchInspectionsState(
          message: message,
          listOfInspection: listOfLiveInspection,
        ),
      );
    } else if (snapshot['error'] == true) {
      emit(ErrorFetchInspectionsState(errormessage: snapshot['error']));
    } else {
      emit(ErrorFetchInspectionsState(errormessage: 'Inspection has error'));
    }
  }
}
