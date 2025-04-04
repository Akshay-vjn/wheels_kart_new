class QuestionModelData {
  String questionId;
  String portionId;
  String systemId;
  String position;
  String question;
  dynamic subQuestionTitle;
  List<dynamic> subQuestionOptions;
  String questionType;
  String keyboardType;
  String picture;
  List<dynamic> answers;
  List<dynamic> validOptions;
  String invalidAnswers;
  String invalidOptionsTitle;
  List<dynamic> invalidOptions;
  String portionName;
  String systemName;
  String commentsTitle;
  String validOptionsTitle;

  QuestionModelData(
      {required this.questionId,
      required this.portionId,
      required this.systemId,
      required this.position,
      required this.question,
      required this.subQuestionTitle,
      required this.subQuestionOptions,
      required this.questionType,
      required this.keyboardType,
      required this.picture,
      required this.answers,
      required this.validOptions,
      required this.invalidAnswers,
      required this.invalidOptionsTitle,
      required this.invalidOptions,
      required this.portionName,
      required this.systemName,
      required this.commentsTitle,
      required this.validOptionsTitle});

  factory QuestionModelData.fromJson(Map<String, dynamic> json) {
    List<dynamic> answerRew = json['answers'];
    List<dynamic> invalidOption = json["invalidOptions"];
    List<dynamic> subQuestions = json["subQuestionOptions"];
    List<dynamic> validOptions = json["validOptions"];
    return QuestionModelData(
        questionId: json["questionId"] ?? '',
        portionId: json["portionId"] ?? '',
        systemId: json["systemId"] ?? '',
        position: json["position"] ?? '',
        question: json["question"] ?? '',
        subQuestionTitle: json["subQuestionTitle"],
        subQuestionOptions: subQuestions.map((e) => e).toList(),
        questionType: json["questionType"] ?? '',
        keyboardType: json["keyboardType"] ?? '',
        picture: json["picture"] ?? '',
        answers: answerRew.map((e) => e).toList(),
        validOptions: validOptions.map((e) => e).toList(),
        invalidAnswers: json["invalidAnswers"] ?? '',
        invalidOptionsTitle: json["invalidOptionsTitle"] ?? '',
        invalidOptions: invalidOption.map((e) => e).toList(),
        portionName: json["portionName"] ?? '',
        systemName: json["systemName"] ?? '',
        commentsTitle: json['commentsTitle'] ?? '',
        validOptionsTitle: json['validOptionsTitle']??''
        );
  }

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "portionId": portionId,
        "systemId": systemId,
        "position": position,
        "question": question,
        "subQuestionTitle": subQuestionTitle,
        "subQuestionOptions": subQuestionOptions,
        "questionType": questionType,
        "keyboardType": keyboardType,
        "picture": picture,
        "answers": List<dynamic>.from(answers.map((x) => x)),
        "validOptions": validOptions,
        "invalidAnswers": invalidAnswers,
        "invalidOptionsTitle": invalidOptionsTitle,
        "invalidOptions": List<dynamic>.from(invalidOptions.map((x) => x)),
        "portionName": portionName,
        "systemName": systemName,
        "commentsTitle": commentsTitle,
        "validOptionsTitle":validOptionsTitle
      };
}
