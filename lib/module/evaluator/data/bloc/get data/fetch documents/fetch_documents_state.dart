part of 'fetch_documents_cubit.dart';

@immutable
sealed class FetchDocumentsState {}

final class FetchDocumentsInitialState extends FetchDocumentsState {}

final class FetchDocumentsErrorState extends FetchDocumentsState {
  final String error;

  FetchDocumentsErrorState({required this.error});
}

final class FetchDocumentsSuccessState extends FetchDocumentsState {
  final List<DocumentDataModel> documets;

  FetchDocumentsSuccessState({required this.documets});

  FetchDocumentsSuccessState copyWith() {
    return FetchDocumentsSuccessState(documets: documets);
  }
}

final class FetchDocumentsLoadingState extends FetchDocumentsState {}
