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
    required this.isLiked
  });

  factory VCarModel.fromJson(Map<String, dynamic> json) {
    String? kmDrivern = json["kmsDriven"];
    if (kmDrivern == null || kmDrivern.isEmpty) {
      kmDrivern = "0";
    }
    return VCarModel(
      isLiked: json['wishlisted'],
      inspectionId: json["inspectionId"] ?? '',
      modelName: json["modelName"] ?? '',
      frontImage: json["frontImage"] ?? '',
      manufacturingYear: json["manufacturingYear"] ?? '',
      fuelType: json["fuel_type"] ?? '',
      kmsDriven: kmDrivern,
      regNo: json["regNo"] ?? '',
      city: json["City"] ?? '',
      currentBid: json["currentBid"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "inspectionId": inspectionId,
    "wishlisted":isLiked,
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
