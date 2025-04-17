part of 'fetch_questions_bloc.dart';

@immutable
sealed class FetchQuestionsEvent {}

class OnCallQuestinApiRepoEvent extends FetchQuestionsEvent {
  BuildContext context;
  String portionId;
  String systemId;
  String inspectionId;
  OnCallQuestinApiRepoEvent({
    required this.context,
    required this.portionId,
    required this.systemId,
    required this.inspectionId,
  });
}

class OnAnswerTheQuestion extends FetchQuestionsEvent {
  final int index;
  final List<UploadInspectionModel> listOfUploads;

  OnAnswerTheQuestion({required this.listOfUploads,required this.index});
}

// class OnSubmitAnswer extends FetchQuestionsEvent {
//   final BuildContext context;
//   final UploadInspectionModel uploadDataModel;

//   OnSubmitAnswer({required this.context, required this.uploadDataModel});
// }

// class OnPressNextButtonEvent extends FetchQuestionsEvent {
//   int nextQuestionIndex;
//   BuildContext context;
//   OnPressNextButtonEvent({required this.nextQuestionIndex,required this.context});
// }

// class OnPressPreviousButtonEvent extends FetchQuestionsEvent {
//   int previouseQuestionIndex;
//   OnPressPreviousButtonEvent({required this.previouseQuestionIndex});
// }

// class OnPressSkipButtonEvent extends FetchQuestionsEvent {
//   int nextQuestionIndex;
//   OnPressSkipButtonEvent({required this.nextQuestionIndex});
// }

// class OnPressTheDropDownItem extends FetchQuestionsEvent {
//   int pressedQuestionIndex;
//   OnPressTheDropDownItem({required this.pressedQuestionIndex});
// }
