import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:wheels_kart/module/evaluator/data/model/question_model_data.dart';
import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_questions_repo.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/upload_inspection_repo.dart';

part 'fetch_questions_event.dart';
part 'fetch_questions_state.dart';

class FetchQuestionsBloc
    extends Bloc<FetchQuestionsEvent, FetchQuestionsState> {
  FetchQuestionsBloc() : super(InitialFetchQuestionsState()) {
    on<OnCallQuestinApiRepoEvent>(_callTheQuestionApi);
    on<OnAnswerTheQuestion>(_onAnswerTheQuestion);
    // on<OnPressNextButtonEvent>(onNextButtonPressed);
    // on<OnPressPreviousButtonEvent>(onBackButtonpressed);
    // on<OnPressTheDropDownItem>(onPressDropDownButtonItem);
  }

  Future<void> _callTheQuestionApi(
    OnCallQuestinApiRepoEvent event,
    Emitter<FetchQuestionsState> emit,
  ) async {
    try {
      emit(LoadingFetchQuestionsState());

      final snapshot = await FetchQuestionsRepo.getQuestions(
        event.context,
        event.portionId,
        event.systemId,
      );

      if (snapshot['error'] == false) {
        final datas = snapshot['data'];
        List data = [];
        if (datas != null) {
          data = datas as List;
          List<QuestionModelData> questionsList =
              data.map((e) => QuestionModelData.fromJson(e)).toList();
          emit(
            SuccessFetchQuestionsState(
              listOfQuestions: questionsList,
              listOfUploads: List.generate(
                questionsList.length,
                (index) => UploadInspectionModel(
                  inspectionId: event.inspectionId,
                  questionId: questionsList[index].questionId,
                  subQuestionAnswer:
                      questionsList[index].subQuestionOptions.isNotEmpty
                          ? questionsList[index].subQuestionOptions.first
                          : null,
                ),
              ),
            ),
          );
        } else {
          emit(ErrorFetchQuestionsState(errorMessage: "Data not found"));
        }
      } else if (snapshot['error'] == true) {
        emit(ErrorFetchQuestionsState(errorMessage: snapshot['message']));
      } else {
        emit(
          ErrorFetchQuestionsState(
            errorMessage: 'Error while fetching questions',
          ),
        );
      }
    } catch (e) {
      emit(ErrorFetchQuestionsState(errorMessage: e.toString()));
    }
  }

  Future<void> _onAnswerTheQuestion(
    OnAnswerTheQuestion event,
    Emitter<FetchQuestionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SuccessFetchQuestionsState) {
      log(event.listOfUploads[event.index].toJson().toString());
      // for (var i in event.listOfUploads) {
      //   log(i.toJson().toString());
      // }
      emit(currentState.copyWith(listOfUploads: event.listOfUploads));
    }
  }

  // Future<void> onSubmitAnswer(
  //     OnSubmitAnswer event, Emitter<FetchQuestionsState> emit) async {
  //   final respnse = await UploadInspectionRepo.uploadInspection(
  //       event.context, event.uploadDataModel);
  // }

  // void onNextButtonPressed(
  //     OnPressNextButtonEvent event, Emitter<FetchQuestionsState> emit) {
  //   if (questionsList.length != event.nextQuestionIndex) {
  //     emit(SuccessFetchQuestionsState(
  //         listOfQuestions: questionsList,
  //         currentIndexOfQuestion: event.nextQuestionIndex));
  //   } else if (questionsList.length == event.nextQuestionIndex) {
  //     showCustomMessageDialog(event.context, 'This Session is Completed',
  //         messageType: MessageCategory.SUCCESS);
  //     Future.delayed(Duration(seconds: 3)).then((e) {
  //       Navigator.of(event.context).pushAndRemoveUntil(
  //           AppRoutes.createRoute(EvDashboardScreen()), (context) => false);
  //     });
  //   }
  // }

  // void onBackButtonpressed(
  //     OnPressPreviousButtonEvent event, Emitter<FetchQuestionsState> emit) {
  //   if (!(event.previouseQuestionIndex < 0)) {
  //     emit(SuccessFetchQuestionsState(
  //         listOfQuestions: questionsList,
  //         currentIndexOfQuestion: event.previouseQuestionIndex));
  //   }
  // }

  // void onPressDropDownButtonItem(
  //     OnPressTheDropDownItem event, Emitter<FetchQuestionsState> emit) {
  //   emit(SuccessFetchQuestionsState(
  //       listOfQuestions: questionsList,
  //       currentIndexOfQuestion: event.pressedQuestionIndex));
  // }
}
