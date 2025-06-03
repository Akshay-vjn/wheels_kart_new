part of 'submit_document_cubit.dart';

@immutable
sealed class SubmitDocumentState {}

final class SubmitDocumentInitialState extends SubmitDocumentState {}

final class SubmitDocumentLoadingState extends SubmitDocumentState {}

final class SubmitDocumentErrorState extends SubmitDocumentState {
final String error;

  SubmitDocumentErrorState({required this.error});

}

final class SubmitDocumentSuccessState extends SubmitDocumentState {}
