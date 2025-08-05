part of 'search_car_make_bloc.dart';

sealed class EvSearchCarMakeState {}

final class SearchCarMakeInitialState extends EvSearchCarMakeState {}

final class SearchListIsEmptyState extends EvSearchCarMakeState {
  final String emptyMessage;
  SearchListIsEmptyState(this.emptyMessage);
}

class SearchListHasDataState extends EvSearchCarMakeState {
  List<CarMakeModel> searchResult;
  final String? selectedCarMakeId;

  SearchListHasDataState({
    required this.searchResult,
    required this.selectedCarMakeId,
  });
  SearchListHasDataState copyWith({
    List<CarMakeModel>? searchResult,
    String? selectedCarMakeId,
  }) {
    return SearchListHasDataState(
      searchResult: searchResult ?? this.searchResult,
      selectedCarMakeId: selectedCarMakeId ?? this.selectedCarMakeId,
    );
  }
}
