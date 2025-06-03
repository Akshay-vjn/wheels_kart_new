class AdditionalQuestion {
  String questionType;
  String photo;
  String keyboardtype;
  List<dynamic> mcqOptions;

  AdditionalQuestion({
    required this.keyboardtype,
    required this.questionType,
    required this.photo,
    required this.mcqOptions,
  });

  factory AdditionalQuestion.fromJson(Map<String, dynamic> json) =>
      AdditionalQuestion(
        keyboardtype: json['keyboardtype'],
        // question: json["question"],
        questionType: json["questionType"],
        photo: json["photo"],
        mcqOptions: List<dynamic>.from(json["mcqOptions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "keyboardtype":keyboardtype,
        // "question": question,
        "questionType": questionType,
        "photo": photo,
        "mcqOptions": List<dynamic>.from(mcqOptions.map((x) => x)),
      };
}
