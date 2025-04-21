import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

class DocumentDataModel {
    String inspectionDocumentId;
    String inspectionId;
    String documentId;
    String documentName;
    String document;
    String status;
    String uploadedBy;
    CreatedAt createdAt;
    DateTime modifiedAt;
    String documentType;

    DocumentDataModel({
        required this.inspectionDocumentId,
        required this.inspectionId,
        required this.documentId,
        required this.documentName,
        required this.document,
        required this.status,
        required this.uploadedBy,
        required this.createdAt,
        required this.modifiedAt,
        required this.documentType,
    });

    factory DocumentDataModel.fromJson(Map<String, dynamic> json) => DocumentDataModel(
        inspectionDocumentId: json["inspectionDocumentId"],
        inspectionId: json["inspectionId"],
        documentId: json["documentId"],
        documentName: json["documentName"],
        document: json["document"],
        status: json["status"],
        uploadedBy: json["uploadedBy"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
        documentType: json["documentType"],
    );

    Map<String, dynamic> toJson() => {
        "inspectionDocumentId": inspectionDocumentId,
        "inspectionId": inspectionId,
        "documentId": documentId,
        "documentName": documentName,
        "document": document,
        "status": status,
        "uploadedBy": uploadedBy,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
        "documentType": documentType,
    };
}
