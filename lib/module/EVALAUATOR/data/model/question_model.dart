// import 'package:wheels_kart/module/evaluator/data/model/additional_question_model.dart';

// class QuestionModel {
//   int questionId;
//   // bool isEnableQuestion;
//   String question;
//   String questionType;
//   String keyboardtype;
//   String photo;
//   List<AdditionalQuestion> ifNotOk;
//   List<AdditionalQuestion> ifOk;

//   QuestionModel({
//     required this.questionId,
//     // required this.isEnableQuestion,
//     required this.question,
//     required this.questionType,
//     required this.keyboardtype,
//     required this.photo,
//     required this.ifNotOk,
//     required this.ifOk,
//   });

//   factory QuestionModel.fromJson(Map<String, dynamic> json) {
//     List listOfNotOkQuestion = json['ifNotOk'];
//     List listOfOkQuestion = json['ifOk'];

//     return QuestionModel(
//       questionId: json["questionId"],
//       // isEnableQuestion: json["isEnableQuestion"],
//       keyboardtype:json["keyboardtype"],
//       question: json["question"],
//       questionType: json["questionType"],
//       photo: json["photo"],
//       ifNotOk: listOfNotOkQuestion.isEmpty
//           ? []
//           : listOfNotOkQuestion
//               .map((e) => AdditionalQuestion.fromJson(e))
//               .toList(),
//       ifOk: listOfOkQuestion.isEmpty
//           ? []
//           : listOfOkQuestion
//               .map((e) => AdditionalQuestion.fromJson(e))
//               .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "questionId": questionId,
//         // "isEnableQuestion": isEnableQuestion,
//         "keyboardtype":keyboardtype,
//         "question": question,
//         "questionType": questionType,
//         "photo": photo,
//         "ifNotOk": List<AdditionalQuestion>.from(ifNotOk.map((x) => x)),
//         "ifOk": List<dynamic>.from(ifOk.map((x) => x)),
//       };
// }
