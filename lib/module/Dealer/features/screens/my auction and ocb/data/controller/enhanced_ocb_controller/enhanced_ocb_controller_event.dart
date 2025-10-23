part of 'enhanced_ocb_controller.dart';

abstract class EnhancedOcbEvent extends Equatable {
  const EnhancedOcbEvent();

  @override
  List<Object> get props => [];
}

class OnFetchOcbWithOwnedDetails extends EnhancedOcbEvent {
  final BuildContext context;

  const OnFetchOcbWithOwnedDetails({required this.context});

  @override
  List<Object> get props => [context];
}

class OnRefreshOcbWithOwnedDetails extends EnhancedOcbEvent {
  final BuildContext context;

  const OnRefreshOcbWithOwnedDetails({required this.context});

  @override
  List<Object> get props => [context];
}




