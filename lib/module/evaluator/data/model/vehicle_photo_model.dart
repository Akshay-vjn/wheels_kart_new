import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class VehiclePhotoModel {
  String pictureId;
  String inspectionId;
  String pictureType;
  String pictureName;
  String picture;
  String status;
  CreatedAt createdAt;
  DateTime modifiedAt;

  VehiclePhotoModel({
    required this.pictureId,
    required this.inspectionId,
    required this.pictureType,
    required this.pictureName,
    required this.picture,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory VehiclePhotoModel.fromJson(Map<String, dynamic> json) =>
      VehiclePhotoModel(
        pictureId: json["pictureId"] ?? '',
        inspectionId: json["inspectionId"] ?? '',
        pictureType: json["pictureType"] ?? '',
        pictureName: json["pictureName"] ?? '',
        picture: json["picture"] ?? '',
        status: json["status"] ?? '',
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
    "pictureId": pictureId,
    "inspectionId": inspectionId,
    "pictureType": pictureType,
    "pictureName": pictureName,
    "picture": picture,
    "status": status,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
  };
}
