import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class VarientModel {
    String variantId;
    String displayName;
    String fullName;
    String launchYear;
    dynamic discontinuedYear;
    String transmissionType;
    String fuelType;
    String modelId;
    String spinnyId;
    String makeYear;
    CreatedAt createdAt;
    DateTime modifiedAt;

    VarientModel({
        required this.variantId,
        required this.displayName,
        required this.fullName,
        required this.launchYear,
        required this.discontinuedYear,
        required this.transmissionType,
        required this.fuelType,
        required this.modelId,
        required this.spinnyId,
        required this.makeYear,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory VarientModel.fromJson(Map<String, dynamic> json) => VarientModel(
        variantId: json["variantId"],
        displayName: json["displayName"],
        fullName: json["fullName"],
        launchYear: json["launch_year"],
        discontinuedYear: json["discontinued_year"],
        transmissionType: json["transmission_type"],
        fuelType: json["fuel_type"],
        modelId: json["modelId"],
        spinnyId: json["spinnyId"],
        makeYear: json["makeYear"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "variantId": variantId,
        "displayName": displayName,
        "fullName": fullName,
        "launch_year": launchYear,
        "discontinued_year": discontinuedYear,
        "transmission_type": transmissionType,
        "fuel_type": fuelType,
        "modelId": modelId,
        "spinnyId": spinnyId,
        "makeYear": makeYear,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
