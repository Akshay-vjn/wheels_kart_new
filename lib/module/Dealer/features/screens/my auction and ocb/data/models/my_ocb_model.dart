class MyOcbModel {
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
    final String bidTime;
    final String bidStatus;
    final String soldTo;
    final String soldName;

    MyOcbModel({
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
    });

    factory MyOcbModel.fromJson(Map<String, dynamic> json) => MyOcbModel(
        inspectionId: json["inspectionId"],
        evaluationId: json["evaluationId"],
        brandName: json["brandName"],
        modelName: json["modelName"],
        frontImage: json["frontImage"],
        manufacturingYear: json["manufacturingYear"],
        fuelType: json["fuel_type"],
        kmsDriven: json["kmsDriven"],
        regNo: json["regNo"],
        city: json["City"],
        bidAmount: json["bidAmount"],
        bidTime: json["bidTime"],
        bidStatus: json["bidStatus"],
        soldTo: json["soldTo"],
        soldName: json["soldName"],
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
        "bidTime": bidTime,
        "bidStatus": bidStatus,
        "soldTo": soldTo,
        "soldName": soldName,
    };
}