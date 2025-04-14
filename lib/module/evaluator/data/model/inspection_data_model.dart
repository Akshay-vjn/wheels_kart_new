import 'package:wheels_kart/module/evaluator/data/model/created_at_model.dart';

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
  List<CurrentStatus> currentStatus;

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
    required this.currentStatus,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      InspectionModel(
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
        currentStatus: List<CurrentStatus>.from(
          json["currentStatus"].map((x) => CurrentStatus.fromJson(x)),
        ),
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
    "currentStatus": List<dynamic>.from(currentStatus.map((x) => x.toJson())),
  };
}

class CurrentStatus {
  String portionId;
  String portionName;
  int totalQuestions;
  int completed;
  int balance;
  List<System> systems;

  CurrentStatus({
    required this.portionId,
    required this.portionName,
    required this.totalQuestions,
    required this.completed,
    required this.balance,
    required this.systems,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    portionId: json["portionId"],
    portionName: json["portionName"],
    totalQuestions: json["totalQuestions"],
    completed: json["completed"],
    balance: json["balance"],
    systems: List<System>.from(json["systems"].map((x) => System.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "portionId": portionId,
    "portionName": portionName,
    "totalQuestions": totalQuestions,
    "completed": completed,
    "balance": balance,
    "systems": List<dynamic>.from(systems.map((x) => x.toJson())),
  };
}

class System {
  String systemId;
  String systemName;
  int totalQuestions;
  int completed;
  int balance;

  System({
    required this.systemId,
    required this.systemName,
    required this.totalQuestions,
    required this.completed,
    required this.balance,
  });

  factory System.fromJson(Map<String, dynamic> json) => System(
    systemId: json["systemId"],
    systemName: json["systemName"],
    totalQuestions: json["totalQuestions"],
    completed: json["completed"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "systemId": systemId,
    "systemName": systemName,
    "totalQuestions": totalQuestions,
    "completed": completed,
    "balance": balance,
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
