import 'dart:typed_data';

class Attachment {
  final String fileName;
  final String file;

  Attachment({required this.fileName, required this.file});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileName: json['fileName'] as String,
      file: json['file'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'fileName': fileName, 'file': file};
}

class UploadInspectionModel {
  final dynamic inspectionId;
  final dynamic questionId;
  String? subQuestionAnswer;
  String? answer;
  String? validOption;
  String? invalidOption;
  String? comment;
  List<Attachment>? attachments;
  // List<Uint8List> ?prefillImages;

  UploadInspectionModel({
    required this.inspectionId,
    required this.questionId,
    this.subQuestionAnswer,
    this.answer,
    // this.prefillImages,
    this.validOption,
    this.invalidOption,
    this.comment,
    this.attachments,
  });

  factory UploadInspectionModel.fromJson(Map<String, dynamic> json) {
    return UploadInspectionModel(
      inspectionId: json['inspectionId'] as int,
      questionId: json['questionId'] as int,
      subQuestionAnswer: json['subQuestionAnswer'] as String?,
      answer: json['answer'] as String?,
      validOption: json['validOption'] as String?,
      invalidOption: json['invalidOption'] as String?,
      comment: json['comment'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'inspectionId': inspectionId,
    'questionId': questionId,
    'subQuestionAnswer': subQuestionAnswer,
    'answer': answer,
    'validOption': validOption,
    'invalidOption': invalidOption,
    'comment': comment,
    'attachments':
        attachments != null ? attachments!.map((e) => e.toJson()).toList() : [],
  };
}
