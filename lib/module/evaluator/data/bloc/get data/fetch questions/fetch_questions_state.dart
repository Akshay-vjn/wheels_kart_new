part of 'fetch_questions_bloc.dart';

@immutable
sealed class FetchQuestionsState {}

final class InitialFetchQuestionsState extends FetchQuestionsState {}

final class LoadingFetchQuestionsState extends FetchQuestionsState {}

final class SuccessFetchQuestionsState extends FetchQuestionsState {  
  List<QuestionModelData> listOfQuestions;
  List<UploadInspectionModel> listOfUploads;

  SuccessFetchQuestionsState(
      {required this.listOfQuestions, required this.listOfUploads});
  SuccessFetchQuestionsState copyWith(
      {List<UploadInspectionModel>? listOfUploads,
      List<QuestionModelData>? listOfQuestions}) {
    return SuccessFetchQuestionsState(
        listOfUploads: listOfUploads ?? this.listOfUploads,
        listOfQuestions: listOfQuestions ?? this.listOfQuestions);
  }
}

final class ErrorFetchQuestionsState extends FetchQuestionsState {
 final String errorMessage;
  ErrorFetchQuestionsState({required this.errorMessage});
}





//  change question





