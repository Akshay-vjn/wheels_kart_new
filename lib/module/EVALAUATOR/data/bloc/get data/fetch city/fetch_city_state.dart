part of 'fetch_city_bloc.dart';

@immutable
sealed class EvFetchCityState {}

final class FetchCityInitialState extends EvFetchCityState {}

final class FetchCityLoadingState extends EvFetchCityState {}

final class FetchCitySuccessSate extends EvFetchCityState {
  List<CityModel> listOfCities;
  FetchCitySuccessSate({required this.listOfCities});
}

final class FetchCityErrorState extends EvFetchCityState {
  String errorMessage;
  FetchCityErrorState({required this.errorMessage});
}

final class FetchCitySearchHasDataState extends EvFetchCityState {}

final class FetchCitySearchEmptyDataState extends EvFetchCityState {}
