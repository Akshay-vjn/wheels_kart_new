part of 'fetch_city_bloc.dart';

@immutable
sealed class EvFetchCityState {}

final class FetchCityInitialState extends EvFetchCityState {}

final class FetchCityLoadingState extends EvFetchCityState {}

final class FetchCitySuccessSate extends EvFetchCityState {
  List<CityModel> listOfCities;
  final String? selectedCityId;

  FetchCitySuccessSate({
    required this.listOfCities,
    required this.selectedCityId,
  });
  FetchCitySuccessSate copyWith({
    List<CityModel>? listOfCities,
    String? selectedCityId,
  }) {
    return FetchCitySuccessSate(
      listOfCities: listOfCities ?? this.listOfCities,
      selectedCityId: selectedCityId ?? this.selectedCityId,
    );
  }
}

final class FetchCityErrorState extends EvFetchCityState {
  String errorMessage;
  FetchCityErrorState({required this.errorMessage});
}

// final class FetchCitySearchHasDataState extends EvFetchCityState {}

// final class FetchCitySearchEmptyDataState extends EvFetchCityState {}
