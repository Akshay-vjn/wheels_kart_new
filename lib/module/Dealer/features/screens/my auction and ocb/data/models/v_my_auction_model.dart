import 'dart:developer';

class VMyAuctionModel {
  String inspectionId;
  String evaluationId;
  String brandName;
  String modelName;
  String frontImage;
  String manufacturingYear;
  String fuelType;
  String kmsDriven;
  String regNo;
  String city;
  String? bidAmount;
  DateTime? bidTime;
  String? bidStatus;
  String? soldTo;
  String? soldName;
  String yourBid;

  VMyAuctionModel({
    required this.inspectionId,
    required this.evaluationId,
    required this.brandName,
    required this.modelName,
    required this.frontImage,
    required this.manufacturingYear,
    required this.fuelType,
    required this.kmsDriven,
    required this.regNo,
    required this.city,
    required this.bidAmount,
    required this.bidTime,
    required this.bidStatus,
    required this.soldTo,
    required this.soldName,
    required this.yourBid,
  });

  factory VMyAuctionModel.fromJson(Map<String, dynamic> json) {
    return VMyAuctionModel(
      inspectionId: json["inspectionId"] ?? '',
      evaluationId: json["evaluationId"] ?? '',
      brandName: json["brandName"] ?? '',
      modelName: json["modelName"] ?? '',
      frontImage: json["frontImage"] ?? '' ?? "",
      manufacturingYear: json["manufacturingYear"] ?? "",
      fuelType: json["fuel_type"] ?? "",
      kmsDriven: json["kmsDriven"] ?? "",
      regNo: json["regNo"] ?? "",
      city: json["City"] ?? "",
      bidAmount: json["bidAmount"] ?? '',
      bidTime:  DateTime.parse(json["bidTime"]),
      bidStatus: json["bidStatus"] ?? "",
      soldTo: json["soldTo"] ?? "",
      soldName: json["soldName"] ?? "",
      yourBid: json["yourBid"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "inspectionId": inspectionId,
    "evaluationId": evaluationId,
    "brandName": brandName,
    "modelName": modelName,
    "frontImage": frontImage,
    "manufacturingYear": manufacturingYear,
    "fuel_type": fuelType,
    "kmsDriven": kmsDriven,
    "regNo": regNo,
    "City": city,
    "bidAmount": bidAmount,
    "bidTime": bidTime,
    "bidStatus": bidStatus,
    "soldTo": soldTo,
    "soldName": soldName,
    "yourBid": yourBid,
  };
}

class BidTime {
  final DateTime date;
  final int timezoneType;
  final String timezone;

  BidTime({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory BidTime.fromJson(Map<String, dynamic> json) => BidTime(
    date: DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "timezone_type": timezoneType,
    "timezone": timezone,
  };
}
