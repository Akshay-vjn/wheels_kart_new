part of 'fetch_car_model_bloc.dart';

@immutable
sealed class EvFetchCarModelEvent {}

class InitialFetchCarModelEvent extends EvFetchCarModelEvent {
  BuildContext context;
  String makeId;
  String makeYear;
  String? currentModelId;

  InitialFetchCarModelEvent({
    required this.context,
    required this.makeId,
    required this.makeYear,
    required this.currentModelId,
  });
}

class OnSearchCarModelEvent extends EvFetchCarModelEvent {
  final String query;
  final List<CarModeModel> initialListOfCarModels;
  OnSearchCarModelEvent({
    required this.initialListOfCarModels,
    required this.query,
  });
}

class OnSelectModel extends EvFetchCarModelEvent {
  final String modelId;

  OnSelectModel({required this.modelId});
}
