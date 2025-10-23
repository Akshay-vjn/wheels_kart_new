import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_collected_document_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_get_documents_repo.dart';

part 'documents_controller_state.dart';

class DocumentsControllerCubit extends Cubit<DocumentsControllerState> {
  DocumentsControllerCubit() : super(DocumentsControllerInitial());

  Future<void> onGetCollectedDocuments(BuildContext context) async {
    try {
      log('DocumentsControllerCubit: Starting to fetch documents');
      emit(DocumentsControllerLoadingState());
      final response = await VGetDocumentsRepo.onGetDocuments(context);

      log('DocumentsControllerCubit: API Response: $response');

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          log('DocumentsControllerCubit: Data length: ${data.length}');
          log('DocumentsControllerCubit: Data: $data');
          
          if (data.isNotEmpty) {
            emit(
              DocumentsControllerSuccessState(
                documets:
                    data.map((e) => CollectedDocumetsModel.fromJson(e)).toList(),
              ),
            );
          } else {
            log('DocumentsControllerCubit: No documents found');
            emit(DocumentsControllErrorState(errorMessage: 'No documents found'));
          }
        } else {
          log('DocumentsControllerCubit: API Error: ${response['message']}');
          emit(DocumentsControllErrorState(errorMessage: response['message']));
        }
      } else {
        log('DocumentsControllerCubit: Empty response from API');
        emit(DocumentsControllErrorState(errorMessage: 'Empty response from server'));
      }
    } catch (e) {
      log('DocumentsControllerCubit: Exception: $e');
      emit(DocumentsControllErrorState(errorMessage: e.toString()));
    }
  }
}
