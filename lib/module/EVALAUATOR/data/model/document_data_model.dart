import 'dart:developer';

import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class VehicleLgalModel {
  final Inspection inspection;
  final List<Document> documents;

  VehicleLgalModel({required this.inspection, required this.documents});

  factory VehicleLgalModel.fromJson(Map<String, dynamic> json) =>
      VehicleLgalModel(
        inspection: Inspection.fromJson(json["inspection"]),
        documents:
         List<Document>.from(
          json["documents"].map((x) => Document.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "inspection": inspection.toJson(),
    "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
  };
}

class Document {
  final String inspectionDocumentId;
  final String inspectionId;
  final String documentId;
  final String documentName;
  final String document;
  final Status status;
  final String uploadedBy;
  final CreatedAt createdAt;
  final DateTime modifiedAt;
  final DocumentType documentType;

  Document({
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

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    inspectionDocumentId: json["inspectionDocumentId"],
    inspectionId: json["inspectionId"],
    documentId: json["documentId"],
    documentName: json["documentName"],
    document: json["document"],
    status: statusValues.map[json["status"]]!,
    uploadedBy: json["uploadedBy"],
    createdAt: CreatedAt.fromJson(json["created_at"]),
    modifiedAt: DateTime.parse(json["modified_at"]),
    documentType: documentTypeValues.map[json["documentType"]]!,
  );

  Map<String, dynamic> toJson() => {
    "inspectionDocumentId": inspectionDocumentId,
    "inspectionId": inspectionId,
    "documentId": documentId,
    "documentName": documentName,
    "document": document,
    "status": statusValues.reverse[status],
    "uploadedBy": uploadedBy,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
    "documentType": documentTypeValues.reverse[documentType],
  };
}

enum Timezone { ASIA_KOLKATA }

final timezoneValues = EnumValues({"Asia/Kolkata": Timezone.ASIA_KOLKATA});

enum DocumentType { INSURANCE, RC_CARD }

final documentTypeValues = EnumValues({
  "Insurance": DocumentType.INSURANCE,
  "RC Card": DocumentType.RC_CARD,
});

enum Status { APPROVED }

final statusValues = EnumValues({"APPROVED": Status.APPROVED});

class Inspection {
  final String noOfOwners;
  final String roadTaxPaid;
  final String roadTaxValidity;
  final String insuranceType;
  final String insuranceValidity;
  final String currentRto;
  final String carLength;
  final String cubicCapacity;
  final String manufactureDate;
  final String noOfKeys;
  final String regDate;

  Inspection({
    required this.noOfOwners,
    required this.roadTaxPaid,
    required this.roadTaxValidity,
    required this.insuranceType,
    required this.insuranceValidity,
    required this.currentRto,
    required this.carLength,
    required this.cubicCapacity,
    required this.manufactureDate,
    required this.noOfKeys,
    required this.regDate,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      noOfOwners: json["noOfOwners"] ?? '',
      roadTaxPaid: json["roadTaxPaid"] ?? '',
      roadTaxValidity: json["roadTaxValidity"] ?? '',
      insuranceType: json["insuranceType"] ?? '',
      insuranceValidity:json["insuranceValidity"],
      currentRto: json["currentRto"] ?? '',
      carLength: json["carLength"] ?? '',
      cubicCapacity: json["cubicCapacity"] ?? '',
      manufactureDate: json["manufactureDate"] ?? '',
      noOfKeys: json["noOfKeys"] ?? "",
      regDate: json["regDate"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "noOfOwners": noOfOwners,
    "roadTaxPaid": roadTaxPaid,
    "roadTaxValidity": roadTaxValidity,
    "insuranceType": insuranceType,
    "insuranceValidity": insuranceValidity,
    "currentRto": currentRto,
    "carLength": carLength,
    "cubicCapacity": cubicCapacity,
    "manufactureDate": manufactureDate,
    "noOfKeys": noOfKeys,
    "regDate": regDate,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
