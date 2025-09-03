part of 'documents_controller_cubit.dart';

@immutable
sealed class DocumentsControllerState {}

final class DocumentsControllerInitial extends DocumentsControllerState {}

final class DocumentsControllerLoadingState extends DocumentsControllerState {}

final class DocumentsControllErrorState extends DocumentsControllerState {
  final String errorMessage;

  DocumentsControllErrorState({required this.errorMessage});
}

final class DocumentsControllerSuccessState extends DocumentsControllerState {
  List<VReceivedDocumentsModel> get documets => [];
}
