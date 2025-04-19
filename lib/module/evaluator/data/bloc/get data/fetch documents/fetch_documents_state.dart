part of 'fetch_documents_cubit.dart';

@immutable
sealed class FetchDocumentsState {}

final class FetchDocumentsInitialState extends FetchDocumentsState {}

final class FetchDocumentsErrorState extends FetchDocumentsState {}

final class FetchDocumentsSuccessState extends FetchDocumentsState {}
