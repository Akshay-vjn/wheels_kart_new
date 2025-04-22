import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class PictureAngleModel {
  String angleId;
  String angleName;
  String samplePicture;
  String order;
  CreatedAt createdAt;
  DateTime modifiedAt;

  PictureAngleModel({
    required this.angleId,
    required this.angleName,
    required this.samplePicture,
    required this.order,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory PictureAngleModel.fromJson(Map<String, dynamic> json) =>
      PictureAngleModel(
        angleId: json["angleId"] ?? '',
        angleName: json["angleName"] ?? '',
        samplePicture: json["samplePicture"] ?? '',
        order: json["order"] ?? '',
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
    "angleId": angleId,
    "angleName": angleName,
    "samplePicture": samplePicture,
    "order": order,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
  };
}
