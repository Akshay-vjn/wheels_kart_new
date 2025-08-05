part of 'search_car_make_bloc.dart';

abstract class EvSearchCarMakeEvent {}

class InitalSearchCarMakeEvent extends EvSearchCarMakeEvent {}

final class OnSearchCarMakeEvent extends EvSearchCarMakeEvent {
  final String query;
  final List<CarMakeModel> initialListOfCarMake;

  OnSearchCarMakeEvent({
    required this.query,
    required this.initialListOfCarMake,
  });
}

final class OnSelectCarMake extends EvSearchCarMakeEvent {
  final String ?selectedMakeId;

  OnSelectCarMake({required this.selectedMakeId});
}
