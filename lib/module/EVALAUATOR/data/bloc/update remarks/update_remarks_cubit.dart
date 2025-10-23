import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/update_remarks_repo.dart';

part 'update_remarks_state.dart';

class UpdateRemarksCubit extends Cubit<UpdateRemarksState> {
  UpdateRemarksCubit() : super(UpdateRemarksInitialState());

  Future<void> updateRemarks(
    BuildContext context,
    String inspectionId,
    String remarks,
  ) async {
    try {
      emit(UpdateRemarksLoadingState());
      
      final response = await UpdateRemarksRepo.updateRemarks(
        context,
        inspectionId,
        remarks,
      );
      
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          emit(UpdateRemarksSuccessState());
          showSnakBar(context, response['message'], isError: false);
        } else {
          showSnakBar(context, response['message'], isError: true);
          emit(UpdateRemarksErrorState(error: response['message']));
        }
      } else {
        showSnakBar(context, "Update Failed! Try again.", isError: true);
        emit(UpdateRemarksErrorState(error: "Error: Response is empty"));
      }
    } catch (e) {
      showSnakBar(context, "Update Failed! $e", isError: true);
      emit(UpdateRemarksErrorState(error: "Error: $e"));
    }
  }

  void init() {
    emit(UpdateRemarksInitialState());
  }
}
