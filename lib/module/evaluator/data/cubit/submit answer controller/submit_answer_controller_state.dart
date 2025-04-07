part of 'submit_answer_controller_cubit.dart';

@immutable
class EvSubmitAnswerControllerState {
  final List<SubmissionState> questionState;

  const EvSubmitAnswerControllerState({required this.questionState});

  EvSubmitAnswerControllerState copyWith({
    List<SubmissionState>? questionState,
  }) {
    return EvSubmitAnswerControllerState(
      questionState: questionState ?? this.questionState,
    );
  }
}

enum SubmissionState { INITIAL, LOADING, ERROR, SUCCESS }
