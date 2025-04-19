import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class DocumentTypeModel {
    String documentTypeId;
    String documentTypeName;
    CreatedAt createdAt;
    DateTime modifiedAt;

    DocumentTypeModel({
        required this.documentTypeId,
        required this.documentTypeName,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory DocumentTypeModel.fromJson(Map<String, dynamic> json) => DocumentTypeModel(
        documentTypeId: json["documentTypeId"]??'',
        documentTypeName: json["documentTypeName"]??'',
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "documentTypeId": documentTypeId,
        "documentTypeName": documentTypeName,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
