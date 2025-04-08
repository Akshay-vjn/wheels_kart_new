import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'v_bottom_nav_controller_state.dart';

class VBottomNavControllerCubit extends Cubit<VBottomNavControllerState> {
  VBottomNavControllerCubit() : super(VBottomNavControllerInitial(index: 0));

  void onChanageNav(int index) {
    emit(VBottomNavControllerInitial(index: index));
  }
}
