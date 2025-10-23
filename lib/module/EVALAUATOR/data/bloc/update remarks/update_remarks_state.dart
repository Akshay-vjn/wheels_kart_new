part of 'update_remarks_cubit.dart';

@immutable
abstract class UpdateRemarksState {}

class UpdateRemarksInitialState extends UpdateRemarksState {}

class UpdateRemarksLoadingState extends UpdateRemarksState {}

class UpdateRemarksSuccessState extends UpdateRemarksState {}

class UpdateRemarksErrorState extends UpdateRemarksState {
  final String error;
  UpdateRemarksErrorState({required this.error});
}
