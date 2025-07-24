class VMyAuctionModel {
  final String inspectionId;
  final String evaluationId;
  final String brandName;
  final String modelName;
  final String frontImage;
  final String manufacturingYear;
  final String fuelType;
  final String kmsDriven;
  final String regNo;
  final String city;
  final String bidAmount;
  final BidTime bidTime;
  final String bidStatus;
  final String soldTo;
  final String soldName;
  final String yourBid;

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

  factory VMyAuctionModel.fromJson(Map<String, dynamic> json) =>
      VMyAuctionModel(
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
        bidTime: BidTime.fromJson(json["bidTime"]),
        bidStatus: json["bidStatus"] ?? "",
        soldTo: json["soldTo"] ?? "",
        soldName: json["soldName"] ?? "",
        yourBid: json["yourBid"] ?? "",
      );

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
    "bidTime": bidTime.toJson(),
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
