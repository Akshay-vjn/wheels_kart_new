part of 'fetch_car_make_bloc.dart';

sealed class EvFetchCarMakeEvent {}

class InitalFetchCarMakeEvent extends EvFetchCarMakeEvent {
  BuildContext context;
  InitalFetchCarMakeEvent({required this.context});
}

// class SearchCarMakeEvent extends FetchCarMakeEvent {
//   final String query;
//   // final List<CarMakeModel> searchList;
//   SearchCarMakeEvent({required this.query,});
// }
