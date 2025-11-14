class VCarDetailModel {
  final CarDetails carDetails;
  final List<CarImage> images;
  List<Section> sections;
  final List<String> vendorIds;
  final List<CarVideos> carVideos;
  final List<PaymentDetail> paymentDetails;

  VCarDetailModel({
    required this.carDetails,
    required this.images,
    required this.sections,
    required this.vendorIds,
    required this.carVideos,
    required this.paymentDetails,
  });

  factory VCarDetailModel.fromJson(Map<String, dynamic> json) {
    // Debug: Check for inspection_remarks at root level
    print("🔍 VCarDetailModel.fromJson - Root keys: ${json.keys.toList()}");
    print("🔍 Has inspection_remarks at root: ${json.containsKey('inspection_remarks')}");
    if (json.containsKey('inspection_remarks')) {
      print("🔍 Root level inspection_remarks: ${json['inspection_remarks']}");
    }
    
    return VCarDetailModel(
      carVideos: json["videos"] != null 
          ? List<CarVideos>.from(
              json["videos"].map((x) => CarVideos.fromJson(x)),
            )
          : [],
      carDetails: CarDetails.fromJson(json["carDetails"], json["inspection_remarks"]),
      images: json["images"] != null 
          ? List<CarImage>.from(
              json["images"].map((x) => CarImage.fromJson(x)),
            )
          : [],
      sections: json["sections"] != null 
          ? List<Section>.from(
              json["sections"].map((x) => Section.fromJson(x)),
            )
          : [],
      vendorIds: json["vendorIds"] != null 
          ? List<String>.from(json["vendorIds"].map((x) => x))
          : [],
      paymentDetails: _parsePaymentDetails(json["paymentDetails"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "videos": List<dynamic>.from(carVideos.map((x) => x.toJson())),
    "carDetails": carDetails.toJson(),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
    "vendorIds": List<dynamic>.from(vendorIds.map((x) => x)),
    "paymentDetails": List<dynamic>.from(paymentDetails.map((x) => x.toJson())),
  };

  static List<PaymentDetail> _parsePaymentDetails(dynamic paymentData) {
    if (paymentData == null) return [];
    
    try {
      if (paymentData is List) {
        return List<PaymentDetail>.from(
          paymentData.map((x) => PaymentDetail.fromJson(x)),
        );
      } else if (paymentData is Map<String, dynamic>) {
        return [PaymentDetail.fromJson(paymentData)];
      } else {
        print("Warning: paymentDetails is neither List nor Map: ${paymentData.runtimeType}");
        return [];
      }
    } catch (e) {
      print("Error parsing paymentDetails: $e");
      return [];
    }
  }
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
  final String remarks;
  DateTime? bidClosingTime;
  DateTime? bidStartTime;
  String? currentBid;
  final String evaluationId;

  CarDetails({
    required this.bidClosingTime,
    required this.bidStartTime,
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
    required this.remarks,
    required this.currentBid,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json, [String? rootRemarks]) => CarDetails(
    bidClosingTime:
        json['bidClosingTime'] == null
            ? null
            : DateTime.parse(json['bidClosingTime']),
    bidStartTime: (() {
      final dynamic v = json['bidStartTime'] ?? json['startTime'];
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    })(),
    evaluationId: json['evaluationId'] ?? 'N/A',
    brand: json["Brand"] ?? 'N/A',
    yearOfManufacture: json["Year of Manufacture"] ?? 'N/A',
    model: json["Model"] ?? 'N/A',
    engineType: json["Engine Type"] ?? 'N/A',
    fuelType: json["Fuel Type"] ?? 'N/A',
    transmission: json["Transmission"] ?? 'N/A',
    variant: json["Variant"] ?? 'N/A',
    registrationNumber: json["Registration Number"] ?? 'N/A',
    registrationDate: json["Registration Date"] ?? 'N/A',
    kmsDriven: json["KMS Driven"] ?? 'N/A',
    noOfOwners: json["No Of Owners"] ?? '',
    roadTaxPaid: json["Road Tax Paid"] ?? 'N/A',
    roadTaxValidity: json["Road Tax Validity"] ?? 'N/A',
    insuranceType: json["Insurance Type"] ?? 'N/A',
    insuranceValidity: json["Insurance Validity"] ?? 'N/A',
    currentRto: json["Current Rto"] ?? 'N/A',
    carLength: json["Car Length"] ?? 'N/A',
    cubicCapacity: json["Cubic Capacity"] ?? 'N/A',
    manufactureDate: json["Manufacture Date"] ?? 'N/A',
    noOfKeys: json["No Of Keys"] ?? '',
    city: json["City"] ?? 'N/A',
    remarks: rootRemarks ?? json["inspection_remarks"] ?? '',
    currentBid: json["currentBid"] ?? "N/A",
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
    "inspection_remarks": remarks,
    "Current Bid": currentBid,
    "bidStartTime": bidStartTime?.toIso8601String(),
  };
}

class Section {
  final String portionName;
  List<Entry> entries;

  Section({required this.portionName, required this.entries});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    portionName: json["portionName"] ?? 'N/A',
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

class CarVideos {
  final String url;
  final String type;

  CarVideos({required this.url, required this.type});

  factory CarVideos.fromJson(Map<String, dynamic> json) =>
      CarVideos(url: json["url"], type: json["type"]);

  Map<String, dynamic> toJson() => {"url": url, "type": type};
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
      question: json["question"] ?? 'N/A',
      answer: json["answer"] ?? 'N/A',
      comment: json["comment"] ?? 'N/A',
      responseImages: List<String>.from(json["responseImages"].map((x) => x)),
      options: validOption ?? invalidOptin,
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "comment": comment,
    "responseImages": List<dynamic>.from(responseImages.map((x) => x)),
  };
}

class PaymentDetail {
  final String? paymentId;
  final String? paymentType;
  final String? paidAmount;
  final String? balanceAmount;
  final String? transactionId;
  final String? paymentMode;
  final PaymentDate? createdAt;

  PaymentDetail({
    this.paymentId,
    this.paymentType,
    this.paidAmount,
    this.balanceAmount,
    this.transactionId,
    this.paymentMode,
    this.createdAt,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      paymentId: json["paymentId"]?.toString(),
      paymentType: json["paymentType"],
      paidAmount: json["paidAmount"]?.toString(),
      balanceAmount: json["balanceAmount"]?.toString(),
      transactionId: json["transactionId"]?.toString(),
      paymentMode: json["paymentMode"],
      createdAt: json["created_at"] != null 
          ? PaymentDate.fromJson(json["created_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "paymentId": paymentId,
    "paymentType": paymentType,
    "paidAmount": paidAmount,
    "balanceAmount": balanceAmount,
    "transactionId": transactionId,
    "paymentMode": paymentMode,
    "created_at": createdAt?.toJson(),
  };
}

class PaymentDate {
  final String? date;
  final int? timezoneType;
  final String? timezone;

  PaymentDate({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  factory PaymentDate.fromJson(Map<String, dynamic> json) {
    return PaymentDate(
      date: json["date"],
      timezoneType: json["timezone_type"],
      timezone: json["timezone"],
    );
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "timezone_type": timezoneType,
    "timezone": timezone,
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
