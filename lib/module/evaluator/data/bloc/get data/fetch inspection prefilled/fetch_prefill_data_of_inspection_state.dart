part of 'fetch_prefill_data_of_inspection_bloc.dart';

@immutable
sealed class EvFetchPrefillDataOfInspectionState {}

final class EvFetchPrefillDataOfInspectionInitialState
    extends EvFetchPrefillDataOfInspectionState {}

final class EvFetchPrefillDataOfInspectionLoadingState
    extends EvFetchPrefillDataOfInspectionState {}

final class EvFetchPrefillDataOfInspectionErrorState
    extends EvFetchPrefillDataOfInspectionState {}

final class EvFetchPrefillDataOfInspectionSuccessState
    extends EvFetchPrefillDataOfInspectionState {
  final List<InspectionPrefillModel> prefillInspectionDatas;

  EvFetchPrefillDataOfInspectionSuccessState({required this.prefillInspectionDatas});
}
