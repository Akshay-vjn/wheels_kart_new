import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/inspection%20progress%20controller/inspection_progress_controller_state.dart';

class InspectionProgressCubit extends Cubit<InspectionProgressState> {
  InspectionProgressCubit() : super(const InspectionProgressState());

  void setQuestionsCompleted(bool completed) {
    emit(state.copyWith(isQuestionsCompleted: completed));
  }

  void setLegalsCompleted(bool completed) {
    emit(state.copyWith(isLegalsCompleted: completed));
  }

  void setPhotosCompleted(bool completed) {
    emit(state.copyWith(isPhotosCompleted: completed));
  }

  void setVideosCompleted(bool completed) {
    emit(state.copyWith(isVideosCompleted: completed));
  }

  void reset() {
    emit(const InspectionProgressState());
  }
}
