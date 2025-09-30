import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class PictureAngleModel {
  String angleId;
  String angleName;
  String samplePicture;
  String order;


  PictureAngleModel({
    required this.angleId,
    required this.angleName,
    required this.samplePicture,
    required this.order,

  });

  factory PictureAngleModel.fromJson(Map<String, dynamic> json) =>
      PictureAngleModel(
        angleId: json["angleId"] ?? '',
        angleName: json["angleName"] ?? '',
        samplePicture: json["samplePicture"] ?? '',
        order: json["order"] ?? '',
     
      );

  Map<String, dynamic> toJson() => {
    "angleId": angleId,
    "angleName": angleName,
    "samplePicture": samplePicture,
    "order": order,

  };
}
