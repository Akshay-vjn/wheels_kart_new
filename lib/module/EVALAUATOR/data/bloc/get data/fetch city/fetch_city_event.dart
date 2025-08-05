part of 'fetch_city_bloc.dart';

@immutable
sealed class EvFetchCityEvent {}

class OnFetchCityDataEvent extends EvFetchCityEvent {
  BuildContext context;
  final String? lastCitySelected;

  OnFetchCityDataEvent({required this.context, required this.lastCitySelected});
}

class OnSelectCity extends EvFetchCityEvent {
 final  String selectedCityId;

  OnSelectCity({required this.selectedCityId});
}
