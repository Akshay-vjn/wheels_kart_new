import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_navigation_state.dart';

class EvAppNavigationCubit extends Cubit<EvAppNavigationState> {
  EvAppNavigationCubit() : super(AppNavigationInitialState(initailIndex: 0));

  handleBottomnavigation(int newIndex) {
    emit(AppNavigationInitialState(initailIndex: newIndex));
  }
}
