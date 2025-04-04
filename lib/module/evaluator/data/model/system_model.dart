import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class SystemModel {
    String systemId;
    String systemName;
    String portionId;
    String position;
    CreatedAt createdAt;
    DateTime modifiedAt;

    SystemModel({
        required this.systemId,
        required this.systemName,
        required this.portionId,
        required this.position,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory SystemModel.fromJson(Map<String, dynamic> json) => SystemModel(
        systemId: json["systemId"],
        systemName: json["systemName"],
        portionId: json["portionId"],
        position: json["position"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "systemId": systemId,
        "systemName": systemName,
        "portionId": portionId,
        "position": position,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
