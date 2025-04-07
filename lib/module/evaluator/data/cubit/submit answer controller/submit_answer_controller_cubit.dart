import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/upload_inspection_repo.dart';

part 'submit_answer_controller_state.dart';

class EvSubmitAnswerControllerCubit
    extends Cubit<EvSubmitAnswerControllerState> {
  EvSubmitAnswerControllerCubit()
    : super(EvSubmitAnswerControllerState(questionState: []));

  Future<void> onSubmitAnswer(
    BuildContext context,
    UploadInspectionModel uploadModel,
    int questionIndex,
  ) async {
    List<SubmissionState> updatedStates = state.questionState;
    updatedStates[questionIndex] = SubmissionState.LOADING;
    // for (var i in updatedStates) {
    //   log(i.name);
    // }
    emit(state.copyWith(questionState: updatedStates));

    try {
      final response = await UploadInspectionRepo.uploadInspection(
        context,
        uploadModel,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          updatedStates[questionIndex] = SubmissionState.SUCCESS;
        } else {
          updatedStates[questionIndex] = SubmissionState.ERROR;
        }
      } else {
        updatedStates[questionIndex] = SubmissionState.ERROR;
      }
    } catch (e) {
      updatedStates[questionIndex] = SubmissionState.ERROR;
    }

    emit(state.copyWith(questionState: updatedStates));
  }

  Future<void> init(int questionLength) async {
    emit(
      EvSubmitAnswerControllerState(
        questionState: List.generate(
          questionLength,
          (index) => SubmissionState.INITIAL,
        ),
      ),
    );
  }

  Future<void> resetState(int questionIndex) async {
    final updatedStates = state.questionState;
    updatedStates[questionIndex] = SubmissionState.INITIAL;

    emit(state.copyWith(questionState: updatedStates));
  }
}
