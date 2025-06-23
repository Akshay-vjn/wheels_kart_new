part of 'fetch_documents_cubit.dart';

@immutable
sealed class FetchDocumentsState {}

final class FetchDocumentsInitialState extends FetchDocumentsState {}

final class FetchDocumentsErrorState extends FetchDocumentsState {
  final String error;

  FetchDocumentsErrorState({required this.error});
}

final class FetchDocumentsSuccessState extends FetchDocumentsState {
  final VehicleLgalModel vehicleLgalModel;

  FetchDocumentsSuccessState({required this.vehicleLgalModel});

  FetchDocumentsSuccessState copyWith() {
    return FetchDocumentsSuccessState(vehicleLgalModel: vehicleLgalModel);
  }
}

final class FetchDocumentsLoadingState extends FetchDocumentsState {}
