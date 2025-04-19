import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/upload_document_repo.dart';

part 'submit_document_state.dart';

class SubmitDocumentCubit extends Cubit<SubmitDocumentState> {
  SubmitDocumentCubit() : super(SubmitDocumentInitialState());

  Future<void> onSubmitDocument(
    BuildContext context,
    String inspectionId,
    Map<String, dynamic> data,
  ) async {
    try {
      emit(SubmitDocumentLoadingState());
      final response = await UploadDocumentRepo.uploadDocument(
        context,
        inspectionId,
        data,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          emit(SubmitDocumentSuccessState());
          Navigator.of(context).pop();
        } else {
          showSnakBar(context, response['message'], isError: true);
          emit(SubmitDocumentErrorState(error: response['message']));
        }
      } else {
        showSnakBar(context, "Error :- Response is empty", isError: true);
        emit(SubmitDocumentErrorState(error: "Error :- Response is empty"));
      }
    } catch (e) {
      showSnakBar(context, "Error :- $e", isError: true);
      SubmitDocumentErrorState(error: "Error :- $e");
    }
  }

  init() {
    emit(SubmitDocumentInitialState());
  }
}
