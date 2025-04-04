import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class PortionModel {
    String portionId;
    String portionName;
    String engineTypeId;
    String position;
    CreatedAt createdAt;
    DateTime modifiedAt;

    PortionModel({
        required this.portionId,
        required this.portionName,
        required this.engineTypeId,
        required this.position,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory PortionModel.fromJson(Map<String, dynamic> json) => PortionModel(
        portionId: json["portionId"],
        portionName: json["portionName"],
        engineTypeId: json["engineTypeId"],
        position: json["position"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "portionId": portionId,
        "portionName": portionName,
        "engineTypeId": engineTypeId,
        "position": position,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}