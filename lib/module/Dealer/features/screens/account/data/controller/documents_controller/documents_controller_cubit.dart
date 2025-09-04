import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_collected_document_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_get_documents_repo.dart';

part 'documents_controller_state.dart';

class DocumentsControllerCubit extends Cubit<DocumentsControllerState> {
  DocumentsControllerCubit() : super(DocumentsControllerInitial());

  Future<void> onGetPaymentHistory(BuildContext context) async {
    try {
      emit(DocumentsControllerLoadingState());
      final response = await VGetDocumentsRepo.onGetDocuments(context);

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          emit(
            DocumentsControllerSuccessState(
              documets:
                  data.map((e) => CollectedDocumetsModel.fromJson(e)).toList(),
            ),
          );
        } else {
          emit(DocumentsControllErrorState(errorMessage: response['message']));
        }
      }
    } catch (e) {
      emit(DocumentsControllErrorState(errorMessage: e.toString()));
    }
  }
}
