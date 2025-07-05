class LiveBidModel {
  final String? currentBid;
  final String? evaluationId;
  final String? soldTo;
  final String? soldName;
  final String? bidStatus;
  final DateTime? bidClosingTime;

  LiveBidModel({
    required this.bidStatus,
    required this.soldTo,
    required this.soldName,
    required this.currentBid,
    required this.evaluationId,
    required this.bidClosingTime,
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

    return LiveBidModel(
      bidStatus: json['bidStatus'],
      soldName: json['soldName'],
      currentBid: json["currentBid"],
      soldTo: json["soldTo"],
      bidClosingTime: parsedTime,
      evaluationId: json['evaluationId'],
    );
  }
}
