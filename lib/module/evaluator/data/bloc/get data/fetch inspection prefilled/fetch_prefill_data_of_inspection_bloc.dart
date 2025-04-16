import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_prefill_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/fetch_inspection_prefilled_datas_repo.dart';

part 'fetch_prefill_data_of_inspection_event.dart';
part 'fetch_prefill_data_of_inspection_state.dart';

class EvFetchPrefillDataOfInspectionBloc
    extends
        Bloc<
          EvFetchPrefillDataOfInspectionEvent,
          EvFetchPrefillDataOfInspectionState
        > {
  EvFetchPrefillDataOfInspectionBloc()
    : super(EvFetchPrefillDataOfInspectionInitialState()) {
    on<OnFetchTheDataForPreFill>((event, emit) async {
      try {
        emit(EvFetchPrefillDataOfInspectionLoadingState());
        log("Loading the pefill");
        final response =
            await FetchInspectionPrefilledDataRepo.fetchInspectionPrefilledData(
              event.context,
              event.inspectionId,
              event.systemId,
              event.portionId,
            );
        if (response.isNotEmpty) {
          
          if (response['error'] == false) {
            
            final data = response['data'] as List;
          
            emit(
              EvFetchPrefillDataOfInspectionSuccessState(
                prefillInspectionDatas:
                    data
                        .map((e) => InspectionPrefillModel.fromJson(e))
                        .toList(),
              ),
            );
          } else {
            emit(EvFetchPrefillDataOfInspectionErrorState());
          }
        } else {
          emit(EvFetchPrefillDataOfInspectionErrorState());
        }
      } catch (e) {
        emit(EvFetchPrefillDataOfInspectionErrorState());
      }
    });
  }
}
