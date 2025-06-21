import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/upload_document_repo.dart';

part 'submit_document_state.dart';

class SubmitDocumentCubit extends Cubit<SubmitDocumentState> {
  SubmitDocumentCubit() : super(SubmitDocumentInitialState());

  Future<void> onSubmitDocument(
    BuildContext context,
    String insectionId,
    List<Map<String, dynamic>> documents,
    String numberOfOwners,
    String roadTaxPaid,
    String roadTaxValidityDate,
    String insuranceType,
    String insuranceValidityDate,
    String currentRto,
    String carLength,
    String cubicCapacity,
    String manufactureDate,
    String numberOfKeys,
    String regDate,
  ) async {
    try {
      emit(SubmitDocumentLoadingState());
      final response = await UploadDocumentRepo.uploadDocument(
        context,
        insectionId,
        documents,
        numberOfOwners,
        roadTaxPaid,
        roadTaxValidityDate,
        insuranceType,
        insuranceValidityDate,
        currentRto,
        carLength,
        cubicCapacity,
        manufactureDate,
        numberOfKeys,
        regDate,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          context.read<FetchDocumentsCubit>().onFetchDocumets(
            context,
            insectionId,
          );
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
