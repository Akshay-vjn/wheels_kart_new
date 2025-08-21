part of 'fetch_inspections_bloc.dart';

@immutable
sealed class FetchInspectionsEvent {}

class OnGetInspectionList extends FetchInspectionsEvent {
  BuildContext context;
  String inspetionListType;
  OnGetInspectionList({
    required this.context,
    required this.inspetionListType,
  });
}

