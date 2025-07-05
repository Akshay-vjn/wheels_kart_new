import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'v_nav_controller_state.dart';

class VNavControllerCubit extends Cubit<VNavControllerState> {
  VNavControllerCubit() : super(VNavControllerInitial(currentIndex: 0));

  void onChangeNav(int index) {
    emit(VNavControllerInitial(currentIndex: index));
  }
}
