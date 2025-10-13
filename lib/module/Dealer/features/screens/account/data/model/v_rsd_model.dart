/// RSD (Refundable Security Deposit) Model
/// Represents a single RSD record with payment details
class RsdModel {
  final String rsdId;
  final String paidAmount;
  final String transactionId;
  final String paymentType;
  final String paymentDate;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  RsdModel({
    required this.rsdId,
    required this.paidAmount,
    required this.transactionId,
    required this.paymentType,
    required this.paymentDate,
    required this.createdAt,
    this.modifiedAt,
  });

  /// Create RsdModel from JSON response
  factory RsdModel.fromJson(Map<String, dynamic> json) {
    return RsdModel(
      rsdId: json['rsdId']?.toString() ?? '',
      paidAmount: json['paidAmount']?.toString() ?? '',
      transactionId: json['transactionId']?.toString() ?? '',
      paymentType: json['paymentType']?.toString() ?? '',
      paymentDate: json['paymentDate']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      modifiedAt: _parseDate(json['modified_at']),
    );
  }

  /// Parse date from various formats
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      // Handle object format: {date: "2025-10-08 18:29:54.000000", timezone_type: 3, timezone: "Asia/Kolkata"}
      if (dateValue is Map) {
        final dateStr = dateValue['date']?.toString();
        if (dateStr == null) return null;
        
        // Remove microseconds and timezone info if present
        final cleanDateStr = dateStr.split('.').first.trim();
        // Replace space with 'T' to make it ISO 8601 compatible
        final isoDateStr = cleanDateStr.replaceFirst(' ', 'T');
        return DateTime.parse(isoDateStr);
      }
      
      final dateStr = dateValue.toString();
      
      // Handle MySQL datetime format: "2025-10-08 18:29:54.000000"
      if (dateStr.contains(' ')) {
        // Remove microseconds and timezone info if present
        final cleanDateStr = dateStr.split('.').first.trim();
        // Replace space with 'T' to make it ISO 8601 compatible
        final isoDateStr = cleanDateStr.replaceFirst(' ', 'T');
        return DateTime.parse(isoDateStr);
      }
      
      // Try standard ISO 8601 format
      return DateTime.parse(dateStr);
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
  }

  /// Convert RsdModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'rsdId': rsdId,
      'paidAmount': paidAmount,
      'transactionId': transactionId,
      'paymentType': paymentType,
      'paymentDate': paymentDate,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt?.toIso8601String(),
    };
  }

  /// Get formatted amount with currency symbol
  String get formattedAmount => '₹$paidAmount';
  
  /// Get display status (since API doesn't provide status, we show payment type)
  String get displayStatus => paymentType;
  
  /// Check if payment is online
  bool get isOnline => paymentType.toLowerCase() == 'online';
}

