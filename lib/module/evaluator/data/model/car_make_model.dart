import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class CarMakeModel {
    String makeId;
    String spinnyMakeId;
    String makeName;
    String logo;
    CreatedAt createdAt;
    DateTime modifiedAt;

    CarMakeModel({
        required this.makeId,
        required this.spinnyMakeId,
        required this.makeName,
        required this.logo,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory CarMakeModel.fromJson(Map<String, dynamic> json) => CarMakeModel(
        makeId: json["makeId"],
        spinnyMakeId: json["spinnyMakeId"],
        makeName: json["makeName"],
        logo: json["logo"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "makeId": makeId,
        "spinnyMakeId": spinnyMakeId,
        "makeName": makeName,
        "logo": logo,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
