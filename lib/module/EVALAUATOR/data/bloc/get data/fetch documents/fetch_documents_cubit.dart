import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/document_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/delete_document_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/fetch_documents_repo.dart';

part 'fetch_documents_state.dart';

class FetchDocumentsCubit extends Cubit<FetchDocumentsState> {
  FetchDocumentsCubit() : super(FetchDocumentsInitialState());

  Future<void> onFetchDocumets(BuildContext context, inspectionId) async {
    try {
      emit(FetchDocumentsLoadingState());
      final response = await FetchDocumentsRepo.fetchUploadedDocuments(
        context,
        inspectionId,
      );

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;

          emit(
            FetchDocumentsSuccessState(
              documets: data.map((e) => DocumentDataModel.fromJson(e)).toList(),
            ),
          );
        } else {
          emit(FetchDocumentsErrorState(error: response['message']));
        }
      } else {
        emit(FetchDocumentsErrorState(error: 'Error - Empty response'));
      }
    } catch (e) {
      emit(FetchDocumentsErrorState(error: 'Error - $e'));
    }
  }

  String? responseMessage;
  bool? isError;
  Future<void> deleteDocument(
    BuildContext context,
    String inspectionId,
    String inspectionDocumentId,
  ) async {
    try {
      // emit(FetchDocumentsLoadingState());

      final response = await DeleteDocumentRepo.deleteDocument(
        context,
        inspectionId,
        inspectionDocumentId,
      );
      if (response.isNotEmpty) {
        responseMessage = response['message'];
      } else {
        responseMessage = 'Error - Empty response';
      }
    } catch (e) {
      responseMessage = 'Error - $e';
    } finally {
      await onFetchDocumets(context, inspectionId);
    }
  }
}
