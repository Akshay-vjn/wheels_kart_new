class VCarModel {
  String inspectionId;
  String evaluationId;
  String modelName;
  String frontImage;
  String manufacturingYear;
  String fuelType;
  String kmsDriven;
  String regNo;
  String city;
  String? soldTo;
  String? soldName;
  String? currentBid;
  String? bidStatus;
  DateTime? bidClosingTime;
  int wishlisted;
  String status;
  String brandName;
  String noOfOwners;
  List<String> vendorIds;
  String auctionType;
  String paymentStatus;

  VCarModel({
    required this.noOfOwners,
    required this.auctionType,
    required this.brandName,
    required this.inspectionId,
    required this.evaluationId,
    required this.modelName,
    required this.frontImage,
    required this.manufacturingYear,
    required this.fuelType,
    required this.kmsDriven,
    required this.regNo,
    required this.city,
    required this.soldTo,
    required this.soldName,
    required this.currentBid,
    required this.bidStatus,
    required this.bidClosingTime,
    required this.wishlisted,
    required this.status,
    required this.vendorIds,
    required this.paymentStatus,
  });

  factory VCarModel.fromJson(Map<String, dynamic> json) {
    String? kmDrivern = json["kmsDriven"];
    if (kmDrivern == null || kmDrivern.isEmpty) {
      kmDrivern = "0";
    }
    final list = json['vendorIds'] as List?;
    return VCarModel(
      auctionType: json["auctionType"] ?? '',
      brandName: json['brandName'] ?? '',
      inspectionId: json["inspectionId"] ?? '',
      evaluationId: json["evaluationId"] ?? '',
      modelName: json["modelName"] ?? '',
      frontImage: json["frontImage"] ?? '',
      manufacturingYear: json["manufacturingYear"] ?? '',
      fuelType: json["fuel_type"] ?? '',
      kmsDriven: kmDrivern,
      regNo: json["regNo"] ?? '',
      city: json["City"] ?? '',
      noOfOwners: json['noOfOwners'] ?? '',
      soldTo: json["soldTo"] ?? '',
      soldName: json["soldName"] ?? '',
      currentBid: json["currentBid"] ?? "0.00",
      // json["currentBid"].isEmpty ? "0.00" : json["currentBid"] ?? '0.00',
      bidStatus: json["bidStatus"] ?? '',
      bidClosingTime:
      json["bidClosingTime"] == null
          ? null
          : DateTime.parse(json["bidClosingTime"]),
      wishlisted: json["wishlisted"] ?? 0,
      status: json["status"] ?? '',
      vendorIds: list == null ? [] : list.map((e) => e.toString()).toList(),
      paymentStatus: json['paymentStatus']??"No",
    );
  }

  Map<String, dynamic> toJson() => {
    "noOfOwners": noOfOwners,
    "inspectionId": inspectionId,
    "evaluationId": evaluationId,
    "modelName": modelName,
    "frontImage": frontImage,
    "manufacturingYear": manufacturingYear,
    "fuel_type": fuelType,
    "kmsDriven": kmsDriven,
    "regNo": regNo,
    "City": city,
    "soldTo": soldTo,
    "soldName": soldName,
    "currentBid": currentBid,
    "bidStatus": bidStatus,
    "bidClosingTime": bidClosingTime,
    "wishlisted": wishlisted,
    "status": status,
    "vendorIds": vendorIds.map((e) => e).toList(),
    "paymentStatus": paymentStatus,
  };
}