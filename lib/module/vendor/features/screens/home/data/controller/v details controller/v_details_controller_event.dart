part of 'v_details_controller_bloc.dart';

@immutable
sealed class VDetailsControllerEvent {}

class OnFetchDetails extends VDetailsControllerEvent {
  final String inspectionId;
  final BuildContext context;

  OnFetchDetails({required this.inspectionId, required this.context});
}

class OnChangeImageIndex extends VDetailsControllerEvent {
  final int newIndex;

  OnChangeImageIndex({required this.newIndex});
}
