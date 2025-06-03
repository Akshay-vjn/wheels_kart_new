part of 'fetch_city_bloc.dart';

@immutable
sealed class EvFetchCityEvent {}

class OnFetchCityDataEvent extends EvFetchCityEvent {
  BuildContext context;

  OnFetchCityDataEvent({required this.context});
}
