part of 'enhanced_ocb_controller.dart';

abstract class EnhancedOcbState extends Equatable {
  const EnhancedOcbState();

  @override
  List<Object> get props => [];
}

class EnhancedOcbInitialState extends EnhancedOcbState {}

class EnhancedOcbLoadingState extends EnhancedOcbState {}

class EnhancedOcbSuccessState extends EnhancedOcbState {
  final List<MyOcbModel> ocbList;
  final List<VCarDetailModel?> ownedDetailsList;

  const EnhancedOcbSuccessState({
    required this.ocbList,
    required this.ownedDetailsList,
  });

  @override
  List<Object> get props => [ocbList, ownedDetailsList];
}

class EnhancedOcbErrorState extends EnhancedOcbState {
  final String error;

  const EnhancedOcbErrorState({required this.error});

  @override
  List<Object> get props => [error];
}




