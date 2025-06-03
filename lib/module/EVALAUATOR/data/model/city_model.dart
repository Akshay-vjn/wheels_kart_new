import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class CityModel {
    String cityId;
    String cityName;
    CreatedAt createdAt;
    DateTime modifiedAt;

    CityModel({
        required this.cityId,
        required this.cityName,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        cityId: json["cityId"],
        cityName: json["cityName"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "cityName": cityName,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}