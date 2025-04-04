class InspectionModel {
    String inspectionId;
    String evaluationId;
    String makeId;
    String manufacturingYear;
    String modelId;
    String engineTypeId;
    String fuelType;
    String transmissionType;
    String variantId;
    String regNo;
    String kmsDriven;
    String cityId;
    String userId;
    String customerId;
    String status;
    CreatedAt createdAt;
    DateTime modifiedAt;
    Customer customer;

    InspectionModel({
        required this.inspectionId,
        required this.evaluationId,
        required this.makeId,
        required this.manufacturingYear,
        required this.modelId,
        required this.engineTypeId,
        required this.fuelType,
        required this.transmissionType,
        required this.variantId,
        required this.regNo,
        required this.kmsDriven,
        required this.cityId,
        required this.userId,
        required this.customerId,
        required this.status,
        required this.createdAt,
        required this.modifiedAt,
        required this.customer,
    });

    factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
        inspectionId: json["inspectionId"],
        evaluationId: json["evaluationId"],
        makeId: json["makeId"],
        manufacturingYear: json["manufacturingYear"],
        modelId: json["modelId"],
        engineTypeId: json["engineTypeId"],
        fuelType: json["fuel_type"],
        transmissionType: json["transmission_type"],
        variantId: json["variantId"],
        regNo: json["regNo"],
        kmsDriven: json["kmsDriven"],
        cityId: json["cityId"],
        userId: json["userId"],
        customerId: json["customerId"],
        status: json["status"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
        customer: Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "inspectionId": inspectionId,
        "evaluationId": evaluationId,
        "makeId": makeId,
        "manufacturingYear": manufacturingYear,
        "modelId": modelId,
        "engineTypeId": engineTypeId,
        "fuel_type": fuelType,
        "transmission_type": transmissionType,
        "variantId": variantId,
        "regNo": regNo,
        "kmsDriven": kmsDriven,
        "cityId": cityId,
        "userId": userId,
        "customerId": customerId,
        "status": status,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
        "customer": customer.toJson(),
    };
}

class CreatedAt {
    DateTime date;
    int timezoneType;
    String timezone;

    CreatedAt({
        required this.date,
        required this.timezoneType,
        required this.timezone,
    });

    factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
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

class Customer {
    String customerId;
    String customerName;
    String customerMobileNumber;
    String cityId;
    CreatedAt createdAt;
    DateTime modifiedAt;

    Customer({
        required this.customerId,
        required this.customerName,
        required this.customerMobileNumber,
        required this.cityId,
        required this.createdAt,
        required this.modifiedAt,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customerId"],
        customerName: json["customerName"],
        customerMobileNumber: json["customerMobileNumber"],
        cityId: json["cityId"],
        createdAt: CreatedAt.fromJson(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "customerName": customerName,
        "customerMobileNumber": customerMobileNumber,
        "cityId": cityId,
        "created_at": createdAt.toJson(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}