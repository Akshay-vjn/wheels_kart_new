class VCarModel {
  String inspectionId;
  String modelName;
  dynamic frontImage;
  String manufacturingYear;
  String fuelType;
  String kmsDriven;
  String regNo;
  String city;
  dynamic currentBid;
  int isLiked;
  String status;

  VCarModel({
    required this.inspectionId,
    required this.modelName,
    required this.frontImage,
    required this.manufacturingYear,
    required this.fuelType,
    required this.kmsDriven,
    required this.regNo,
    required this.city,
    required this.currentBid,
    required this.isLiked,
    required this.status,
  });

  factory VCarModel.fromJson(Map<String, dynamic> json) {
    String? kmDrivern = json["kmsDriven"];
    if (kmDrivern == null || kmDrivern.isEmpty) {
      kmDrivern = "0";
    }
    return VCarModel(
      status: json["status"] ?? '',
      isLiked: json['wishlisted'],
      inspectionId: json["inspectionId"] ?? '',
      modelName: json["modelName"] ?? '',
      frontImage: json["frontImage"] ?? '',
      manufacturingYear: json["manufacturingYear"] ?? '',
      fuelType: json["fuel_type"] ?? '',
      kmsDriven: kmDrivern,
      regNo: json["regNo"] ?? '',
      city: json["City"] ?? '',
      currentBid:
          json["currentBid"].isEmpty ? "0.00" : json["currentBid"] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "inspectionId": inspectionId,
    "wishlisted": isLiked,
    "modelName": modelName,
    "frontImage": frontImage,
    "manufacturingYear": manufacturingYear,
    "fuel_type": fuelType,
    "kmsDriven": kmsDriven,
    "regNo": regNo,
    "City": city,
    "currentBid": currentBid,
  };
}
