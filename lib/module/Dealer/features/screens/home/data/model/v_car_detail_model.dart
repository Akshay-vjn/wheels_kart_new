class VCarDetailModel {
  final CarDetails carDetails;
  final List<CarImage> images;
  final List<Section> sections;

  VCarDetailModel({
    required this.carDetails,
    required this.images,
    required this.sections,
  });

  factory VCarDetailModel.fromJson(Map<String, dynamic> json) =>
      VCarDetailModel(
        carDetails: CarDetails.fromJson(json["carDetails"]),
        images: List<CarImage>.from(
          json["images"].map((x) => CarImage.fromJson(x)),
        ),
        sections: List<Section>.from(
          json["sections"].map((x) => Section.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "carDetails": carDetails.toJson(),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
  };
}

class CarDetails {
  final String brand;
  final String yearOfManufacture;
  final String model;
  final String engineType;
  final String fuelType;
  final String transmission;
  final String variant;
  final String registrationNumber;
  final String registrationDate;
  final String kmsDriven;
  final String noOfOwners;
  final String roadTaxPaid;
  final String roadTaxValidity;
  final String insuranceType;
  final String insuranceValidity;
  final String currentRto;
  final String carLength;
  final String cubicCapacity;
  final String manufactureDate;
  final String noOfKeys;
  final String city;
  final String currentBid;
  final String evaluationId;

  CarDetails({
    required this.evaluationId,
    required this.brand,
    required this.yearOfManufacture,
    required this.model,
    required this.engineType,
    required this.fuelType,
    required this.transmission,
    required this.variant,
    required this.registrationNumber,
    required this.registrationDate,
    required this.kmsDriven,
    required this.noOfOwners,
    required this.roadTaxPaid,
    required this.roadTaxValidity,
    required this.insuranceType,
    required this.insuranceValidity,
    required this.currentRto,
    required this.carLength,
    required this.cubicCapacity,
    required this.manufactureDate,
    required this.noOfKeys,
    required this.city,
    required this.currentBid,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) => CarDetails(
    evaluationId: json['evaluationId'] ?? '',
    brand: json["Brand"] ?? '',
    yearOfManufacture: json["Year of Manufacture"] ?? '',
    model: json["Model"] ?? '',
    engineType: json["Engine Type"] ?? '',
    fuelType: json["Fuel Type"] ?? '',
    transmission: json["Transmission"] ?? '',
    variant: json["Variant"] ?? '',
    registrationNumber: json["Registration Number"] ?? '',
    registrationDate: json["Registration Date"] ?? '',
    kmsDriven: json["KMS Driven"] ?? '',
    noOfOwners: json["No Of Owners"] ?? '',
    roadTaxPaid: json["Road Tax Paid"] ?? '',
    roadTaxValidity: json["Road Tax Validity"] ?? '',
    insuranceType: json["Insurance Type"] ?? '',
    insuranceValidity: json["Insurance Validity"] ?? '',
    currentRto: json["Current Rto"] ?? '',
    carLength: json["Car Length"] ?? '',
    cubicCapacity: json["Cubic Capacity"] ?? '',
    manufactureDate: json["Manufacture Date"] ?? '',
    noOfKeys: json["No Of Keys"] ?? '',
    city: json["City"] ?? '',
    currentBid: json["Current Bid"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "evaluationId": evaluationId,
    "Brand": brand,
    "Year of Manufacture": yearOfManufacture,
    "Model": model,
    "Engine Type": engineType,
    "Fuel Type": fuelType,
    "Transmission": transmission,
    "Variant": variant,
    "Registration Number": registrationNumber,
    "Registration Date": registrationDate,
    "KMS Driven": kmsDriven,
    "No Of Owners": noOfOwners,
    "Road Tax Paid": roadTaxPaid,
    "Road Tax Validity": roadTaxValidity,
    "Insurance Type": insuranceType,
    "Insurance Validity": insuranceValidity,
    "Current Rto": currentRto,
    "Car Length": carLength,
    "Cubic Capacity": cubicCapacity,
    "Manufacture Date": manufactureDate,
    "No Of Keys": noOfKeys,
    "City": city,
    "Current Bid": currentBid,
  };
}

class Section {
  final String portionName;
  final List<Entry> entries;

  Section({required this.portionName, required this.entries});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    portionName: json["portionName"] ?? '',
    entries: List<Entry>.from(json["entries"].map((x) => Entry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "portionName": portionName,
    "entries": List<dynamic>.from(entries.map((x) => x.toJson())),
  };
}

class CarImage {
  final String url;
  final String name;

  CarImage({required this.url, required this.name});

  factory CarImage.fromJson(Map<String, dynamic> json) =>
      CarImage(url: json["url"], name: json["name"]);

  Map<String, dynamic> toJson() => {"url": url, "name": name};
}

class Entry {
  final String question;
  final String answer;
  final String comment;
  final List<String> responseImages;
  final String? options;

  Entry({
    required this.question,
    required this.answer,
    required this.comment,
    required this.responseImages,
    required this.options,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    String? validOption = json["validOption"];
    String? invalidOptin = json["invalidOption"];
    return Entry(
      question: json["question"] ?? '',
      answer: json["answer"] ?? '',
      comment: json["comment"] ?? '',
      responseImages: List<String>.from(json["responseImages"].map((x) => x)),
      options: validOption ?? invalidOptin ,
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "comment": comment,
    "responseImages": List<dynamic>.from(responseImages.map((x) => x)),
  };
}

// enum Comment {
//   COMMENT_NEED_TO_REPLACE,
//   EMPTY,
//   NEED_TO_REAPLACE,
//   NEED_TO_REPLACE,
//   NO_FEATURES,
//   NO_FOG_LAMP,
//   NO_REAR_VIEW_CAMERA,
//   THE_2_D_STERIO,
// }

// final commentValues = EnumValues({
//   "NEED TO REPLACE": Comment.COMMENT_NEED_TO_REPLACE,
//   "": Comment.EMPTY,
//   "NEED TO REAPLACE": Comment.NEED_TO_REAPLACE,
//   "NEED TO REPLACE ": Comment.NEED_TO_REPLACE,
//   "NO FEATURES": Comment.NO_FEATURES,
//   "NO FOG LAMP ": Comment.NO_FOG_LAMP,
//   "NO REAR VIEW CAMERA ": Comment.NO_REAR_VIEW_CAMERA,
//   "2D sterio": Comment.THE_2_D_STERIO,
// });

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
