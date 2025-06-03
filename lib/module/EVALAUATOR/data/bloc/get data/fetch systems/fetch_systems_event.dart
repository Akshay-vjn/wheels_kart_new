part of 'fetch_systems_bloc.dart';

@immutable
sealed class FetchSystemsEvent {}

final class OnFetchSystemsOfPortions extends FetchSystemsEvent {
  BuildContext context;
  String portionId;
  OnFetchSystemsOfPortions({required this.context, required this.portionId});
}
