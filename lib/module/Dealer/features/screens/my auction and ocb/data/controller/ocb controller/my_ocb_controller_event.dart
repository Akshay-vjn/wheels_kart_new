part of 'my_ocb_controller_bloc.dart';

@immutable
sealed class MyOcbControllerEvent {}

class OnFetchMyOCBList extends MyOcbControllerEvent {
  final BuildContext context;

  OnFetchMyOCBList({required this.context});
}
