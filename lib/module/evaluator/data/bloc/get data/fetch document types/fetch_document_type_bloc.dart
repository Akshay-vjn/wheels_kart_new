import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:wheels_kart/module/evaluator/data/model/document_type_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_document_types.dart';

part 'fetch_document_type_event.dart';
part 'fetch_document_type_state.dart';

class FetchDocumentTypeBloc
    extends Bloc<FetchDocumentTypeEvent, FetchDocumentTypeState> {
  FetchDocumentTypeBloc() : super(FetchDocumentTypeInitialState()) {
    on<OnFetchDocumentTypeEvent>((event, emit) async {
      try {
        emit(FetchDocumentTypeLoadingState());
        final response = await FetchDocumentTypesRepo.getFetchDocumentTypes(
          event.context,
        );
        if (response.isNotEmpty) {
          if (response['error'] == false) {
            final data = response['data'] as List;
            emit(
              FetchDocumentTypeSuccessState(
            
                documentTypes:
                    data.map((e) => DocumentTypeModel.fromJson(e)).toList(),
              ),
            );
          } else {
            emit(FetchDocumentTypeErrorState(error: response['message']));
          }
        } else {
          emit(
            FetchDocumentTypeErrorState(error: "Error :- Response is empty"),
          );
        }
      } catch (e) {
        FetchDocumentTypeErrorState(error: "Error :- $e");
      }
    });
   
  }
}
