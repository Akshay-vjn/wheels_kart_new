import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class CarModeModel {
    String modelId;
    String makeId;
    String spinnyMakeId;
    String makeYear;
    String spinnyId;
    String modelName;
    String modelFullName;
    String bodyType;
    String segment;
    String shelfLife;
    String image;
    CreatedAt createdAt;
    DateTime modifiedAt;

    CarModeModel({
        required this.modelId,
        required this.makeId,
        required this.spinnyMakeId,
        required this.makeYear,
        required this.spinnyId,
        required this.modelName,
        required this.modelFullName,
        required this.bodyType,
        required this.segment,
        required this.shelfLife,
        required this.image,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory CarModeModel.fromJson(Map<String, dynamic> json) => CarModeModel(
        modelId: json["modelId"]??'',
        makeId: json["makeId"]??'',
        spinnyMakeId: json["spinnyMakeId"]??'',
        makeYear: json["makeYear"]??'',
        spinnyId: json["spinnyId"]??'',
        modelName: json["modelName"]??'',
        modelFullName: json["modelFullName"]??'',
        bodyType: json["bodyType"]??'',
        segment: json["segment"]??'',
        shelfLife: json["shelfLife"]??'',
        image: json["image"]??'',
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "modelId": modelId,
        "makeId": makeId,
        "spinnyMakeId": spinnyMakeId,
        "makeYear": makeYear,
        "spinnyId": spinnyId,
        "modelName": modelName,
        "modelFullName": modelFullName,
        "bodyType": bodyType,
        "segment": segment,
        "shelfLife": shelfLife,
        "image": image,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
