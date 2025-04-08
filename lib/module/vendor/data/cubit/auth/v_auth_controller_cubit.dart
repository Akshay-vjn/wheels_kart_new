import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'v_auth_controller_state.dart';

class VAuthControllerCubit extends Cubit<VAuthControllerState> {
  VAuthControllerCubit() : super(VAuthControllerInitial());

  void onChangePasswordVisibility() {
    final currentState = state;
    emit(
      VAuthControllerState(isObsecure: currentState.isObsecure ? false : true),
    );
  }
}
