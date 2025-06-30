import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class VProfileModel {
    String vendorId;
    String vendorName;
    String vendorMobileNumber;
    String vendorEmail;
    String vendorCity;
    String vendorStatus;
    CreatedAt createdAt;
    DateTime modifiedAt;

    VProfileModel({
        required this.vendorId,
        required this.vendorName,
        required this.vendorMobileNumber,
        required this.vendorEmail,
        required this.vendorCity,
        required this.vendorStatus,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory VProfileModel.fromJson(Map<String, dynamic> json) => VProfileModel(
        vendorId: json["vendorId"],
        vendorName: json["vendorName"],
        vendorMobileNumber: json["vendorMobileNumber"],
        vendorEmail: json["vendorEmail"],
        vendorCity: json["vendorCity"],
        vendorStatus: json["vendorStatus"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
        "vendorName": vendorName,
        "vendorMobileNumber": vendorMobileNumber,
        "vendorEmail": vendorEmail,
        "vendorCity": vendorCity,
        "vendorStatus": vendorStatus,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}