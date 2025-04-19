part of 'fetch_document_type_bloc.dart';

@immutable
sealed class FetchDocumentTypeState {
  FetchDocumentTypeState();
}

final class FetchDocumentTypeInitialState extends FetchDocumentTypeState {}

final class FetchDocumentTypeLoadingState extends FetchDocumentTypeState {}

final class FetchDocumentTypeErrorState extends FetchDocumentTypeState {
  final String error;

  FetchDocumentTypeErrorState({required this.error});
}

final class FetchDocumentTypeSuccessState extends FetchDocumentTypeState {
  final List<DocumentTypeModel> documentTypes;
  FetchDocumentTypeSuccessState({required this.documentTypes});

  FetchDocumentTypeSuccessState copyWith({
    List<DocumentTypeModel>? documentTypes,
  }) {
    return FetchDocumentTypeSuccessState(
      documentTypes: documentTypes ?? this.documentTypes,
    );
  }
}
