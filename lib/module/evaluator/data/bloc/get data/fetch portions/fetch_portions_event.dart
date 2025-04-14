part of 'fetch_portions_bloc.dart';

@immutable
sealed class FetchPortionsEvent {}

class OngetPostionsEvent extends FetchPortionsEvent {
  BuildContext context;
  final String inspectionId;
  OngetPostionsEvent({required this.context,required this. inspectionId});
}
