import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class PaymentHistoryModel {
  final String paymentId;
  final String inspection;
  final String paidAmount;
  final String balanceAmount;
  final String paymentType;
  final String transactionId;
  final String paymentMode;
  final CreatedAt createdAt;
  final DateTime modifiedAt;

  PaymentHistoryModel({
    required this.paymentId,
    required this.inspection,
    required this.paidAmount,
    required this.balanceAmount,
    required this.paymentType,
    required this.transactionId,
    required this.paymentMode,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
        paymentId: json["paymentId"]??'',
        inspection: json["inspection"]??'',
        paidAmount: json["paidAmount"]??'',
        balanceAmount: json["balanceAmount"]??'',
        paymentType: json["paymentType"]??'',
        transactionId: json["transactionId"]??'',
        paymentMode: json["paymentMode"]??'',
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
    "paymentId": paymentId,
    "inspection": inspection,
    "paidAmount": paidAmount,
    "balanceAmount": balanceAmount,
    "paymentType": paymentType,
    "transactionId": transactionId,
    "paymentMode": paymentMode,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
  };
}
