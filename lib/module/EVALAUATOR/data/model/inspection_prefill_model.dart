import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class InspectionPrefillModel {
  String responseId;
  String inspectionId;
  String portionId;
  String systemId;
  String questionId;
  String? subQuestionAnswer;
  String? answer;
  String? validOption;
  String? invalidOption;
  String? comment;
  CreatedAt createdAt;
  DateTime modifiedAt;
  List<Image> images;

  InspectionPrefillModel({
    required this.responseId,
    required this.inspectionId,
    required this.portionId,
    required this.systemId,
    required this.questionId,
    required this.subQuestionAnswer,
    required this.answer,
    required this.validOption,
    required this.invalidOption,
    required this.comment,
    required this.createdAt,
    required this.modifiedAt,
    required this.images,
  });

  factory InspectionPrefillModel.fromJson(Map<String, dynamic> json) =>
      InspectionPrefillModel(
        responseId: json["responseId"] ?? '',
        inspectionId: json["inspectionId"] ?? '',
        portionId: json["portionId"] ?? '',
        systemId: json["systemId"] ?? '',
        questionId: json["questionId"] ?? '',
        subQuestionAnswer: json["subQuestionAnswer"],
        answer: json["answer"],
        validOption: json["validOption"],
        invalidOption: json["invalidOption"],
        comment: json["comment"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "responseId": responseId,
    "inspectionId": inspectionId,
    "portionId": portionId,
    "systemId": systemId,
    "questionId": questionId,
    "subQuestionAnswer": subQuestionAnswer,
    "answer": answer,
    "validOption": validOption,
    "invalidOption": invalidOption,
    "comment": comment,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class Image {
  String responseImageId;
  String responseId;
  String inspectionId;
  String questionId;
  String file;
  String image;
  CreatedAt createdAt;
  DateTime modifiedAt;

  Image({
    required this.responseImageId,
    required this.responseId,
    required this.inspectionId,
    required this.questionId,
    required this.file,
    required this.image,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    responseImageId: json["responseImageId"] ?? '',
    responseId: json["responseId"] ?? '',
    inspectionId: json["inspectionId"] ?? '',
    questionId: json["questionId"] ?? '',
    file: json["file"] ?? '',
    image: json["image"] ?? '',
    createdAt: CreatedAt.fromJson(json["created_at"]),
    modifiedAt: DateTime.parse(json["modified_at"]),
  );

  Map<String, dynamic> toJson() => {
    "responseImageId": responseImageId,
    "responseId": responseId,
    "inspectionId": inspectionId,
    "questionId": questionId,
    "file": file,
    "image": image,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
  };
}
