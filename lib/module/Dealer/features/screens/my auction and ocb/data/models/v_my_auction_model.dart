class VMyAuctionModel {
  String inspectionId;
  String evaluationId;
  String brandName;
  String modelName;
  dynamic frontImage;
  String manufacturingYear;
  String fuelType;
  String kmsDriven;
  String regNo;
  String city;
  String? bidAmount;
  DateTime? bidTime;
  DateTime? bidClosingTime;
  String? bidStatus;
  String? soldTo;
  String? soldName;
  List<YourBid> yourBids;

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
    required this.bidClosingTime,
    required this.bidStatus,
    required this.soldTo,
    required this.soldName,
    required this.yourBids,
  });

  factory VMyAuctionModel.fromJson(Map<String, dynamic> json) =>
      VMyAuctionModel(
        inspectionId: json["inspectionId"] ?? '',
        evaluationId: json["evaluationId"] ?? '',
        brandName: json["brandName"] ?? '',
        modelName: json["modelName"] ?? '',
        frontImage: json["frontImage"] ?? '',
        manufacturingYear: json["manufacturingYear"] ?? '',
        fuelType: json["fuel_type"] ?? '',
        kmsDriven: json["kmsDriven"] ?? '',
        regNo: json["regNo"] ?? '',
        city: json["City"] ?? '',
        bidAmount: json["bidAmount"] ?? '',
        bidTime:
            json["bidTime"] == null ? null : DateTime.parse(json["bidTime"]),
        bidClosingTime:json["bidClosingTime"]==null?null: DateTime.parse(json["bidClosingTime"]),
        bidStatus: json["bidStatus"] ?? '',
        soldTo: json["soldTo"] ?? '',
        soldName: json["soldName"] ?? '',
        yourBids: List<YourBid>.from(
          json["yourBids"].map((x) => YourBid.fromJson(x)),
        ),
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
    "bidTime": bidTime!.toIso8601String(),
    "bidClosingTime": bidClosingTime!.toIso8601String(),
    "bidStatus": bidStatus,
    "soldTo": soldTo,
    "soldName": soldName,
    "yourBids": List<dynamic>.from(yourBids.map((x) => x.toJson())),
  };
}

class YourBid {
  final int amount;
  final DateTime time;
  final String status;

  YourBid({required this.amount, required this.time, required this.status});

  factory YourBid.fromJson(Map<String, dynamic> json) => YourBid(
    amount: json["amount"],
    time: DateTime.parse(json["time"]),
    status: json["status"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "time": time.toIso8601String(),
    "status": status,
  };
}
