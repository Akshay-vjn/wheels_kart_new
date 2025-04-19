import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/fetch_documents_repo.dart';

part 'fetch_documents_state.dart';

class FetchDocumentsCubit extends Cubit<FetchDocumentsState> {
  FetchDocumentsCubit() : super(FetchDocumentsInitialState());

  Future<void> onFetchDocumets(BuildContext context, inspectionId) async {
    final response = await FetchDocumentsRepo.fetchUploadedDocuments(
      context,
      inspectionId,
    );
  }
}
