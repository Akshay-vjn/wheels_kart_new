part of 'fetch_portions_bloc.dart';

@immutable
sealed class FetchPortionsEvent {}

class OngetPostionsEvent extends FetchPortionsEvent {
  BuildContext context;
  OngetPostionsEvent({required this.context});
}
