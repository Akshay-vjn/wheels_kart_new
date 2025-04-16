part of 'fetch_prefill_data_of_inspection_bloc.dart';

@immutable
sealed class EvFetchPrefillDataOfInspectionEvent {}

class OnFetchTheDataForPreFill extends EvFetchPrefillDataOfInspectionEvent {
  final BuildContext context;
  final String inspectionId;
  final String systemId;
  final String portionId;

  OnFetchTheDataForPreFill({
    required this.context,
    required this.inspectionId,
    required this.systemId,
    required this.portionId,
  });
}
