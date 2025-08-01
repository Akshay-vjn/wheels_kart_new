class LiveBidModel {
  final String? currentBid;
  final String? evaluationId;
  final String? soldTo;
  final String? soldName;
  final String? bidStatus;
  final DateTime? bidClosingTime;
  // final List<String> vendorIds;
  final String? trigger;
  final List<VendorBid> vendorBids;

  LiveBidModel({
    required this.vendorBids,
    required this.bidStatus,
    required this.soldTo,
    required this.soldName,
    required this.currentBid,
    required this.evaluationId,
    required this.bidClosingTime,
    // required this.vendorIds,

    required this.trigger,
  });

  factory LiveBidModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;

    // Safely parse the bidClosingTime if it's a non-null string
    if (json['bidClosingTime'] != null && json['bidClosingTime'] is String) {
      try {
        parsedTime = DateTime.parse(json['bidClosingTime']);
      } catch (e) {
        parsedTime = null;
      }
    }
    final list = json['vendorIds'] as List?;

    return LiveBidModel(
      vendorBids:
          json["vendorBids"] == null
              ? []
              : List<VendorBid>.from(
                json["vendorBids"].map((x) => VendorBid.fromJson(x)),
              ),
      trigger: json['trigger'],
      bidStatus: json['bidStatus'],
      soldName: json['soldName'],
      currentBid: json["currentBid"],
      soldTo: json["soldTo"],
      bidClosingTime: parsedTime,
      evaluationId: json['evaluationId'],
      // vendorIds: list == null ? [] : list.map((e) => e.toString()).toList(),
    );
  }
}

class VendorBid {
  final String vendorId;
  final String currentBid;
  final DateTime createdAt;

  VendorBid({
    required this.vendorId,
    required this.currentBid,
    required this.createdAt,
  });

  factory VendorBid.fromJson(Map<String, dynamic> json) => VendorBid(
    vendorId: json["vendorId"],
    currentBid: json["currentBid"],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "vendorId": vendorId,
    "currentBid": currentBid,
  };
}
