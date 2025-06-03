part of 'search_car_make_bloc.dart';

sealed class EvSearchCarMakeState {}

final class SearchCarMakeInitialState extends EvSearchCarMakeState {
  //  List<CarMakeModel> initialList;

  // SearchCarMakeInitial({required this.initialList});
}

final class SearchListIsEmptyState extends EvSearchCarMakeState {
  final String emptyMessage;
  SearchListIsEmptyState(this.emptyMessage);
}

class SearchListHasDataState extends EvSearchCarMakeState {
  List<CarMakeModel> searchResult;

  SearchListHasDataState({required this.searchResult});
}
