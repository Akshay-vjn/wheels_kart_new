part of 'submit_answer_controller_cubit.dart';

@immutable
class EvSubmitAnswerControllerState {
  final List<SubmissionState> questionState;
  final List<bool> canUpdate;

  const EvSubmitAnswerControllerState({
    required this.questionState,
    required this.canUpdate,
  });

  EvSubmitAnswerControllerState copyWith({
    List<SubmissionState>? questionState,
    List<bool>? isUpdateView,
  }) {
    return EvSubmitAnswerControllerState(
      canUpdate: isUpdateView ?? this.canUpdate,
      questionState: questionState ?? this.questionState,
    );
  }
}

enum SubmissionState { INITIAL, LOADING, ERROR, SUCCESS }
