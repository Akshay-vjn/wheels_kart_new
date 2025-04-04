part of 'submit_answer_controller_cubit.dart';

@immutable
class SubmitAnswerControllerState {
  final List<SubmissionState> questionState;

  const SubmitAnswerControllerState({required this.questionState});

  SubmitAnswerControllerState copyWith({List<SubmissionState>? questionState}) {
    return SubmitAnswerControllerState(
        questionState: questionState ?? this.questionState);
  }
}

enum SubmissionState { INITIAL, LOADING, ERROR, SUCCESS }
