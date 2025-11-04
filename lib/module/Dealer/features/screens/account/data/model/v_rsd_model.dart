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
  final String? balanceAmount;
  final String? totalAmount;

  RsdModel({
    required this.rsdId,
    required this.paidAmount,
    required this.transactionId,
    required this.paymentType,
    required this.paymentDate,
    required this.createdAt,
    this.modifiedAt,
    this.balanceAmount,
    this.totalAmount,
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
      balanceAmount: json['balanceAmount']?.toString(),
      totalAmount: json['totalAmount']?.toString(),
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
      'balanceAmount': balanceAmount,
      'totalAmount': totalAmount,
    };
  }

  /// Get formatted amount with currency symbol
  String get formattedAmount => '₹$paidAmount';
  
  /// Get display status (since API doesn't provide status, we show payment type)
  String get displayStatus => paymentType;
  
  /// Check if payment is online
  bool get isOnline => paymentType.toLowerCase() == 'online';
  
  /// Check if payment is fully paid (won status)
  /// Returns true if balanceAmount is 0, null, empty, or not provided
  /// If balanceAmount is not provided, checks if transactionId exists (indicates payment was made)
  bool get isFullyPaid {
    // If balanceAmount is provided, use it to determine status
    if (balanceAmount != null && balanceAmount!.isNotEmpty) {
      try {
        final balance = double.tryParse(balanceAmount!.trim()) ?? -1;
        // If parsing succeeds, balance of 0 means fully paid
        if (balance >= 0) {
          return balance == 0;
        }
        // If parsing fails, check if it's "0" as string
        return balanceAmount!.trim() == '0';
      } catch (e) {
        // If parsing fails, check if balanceAmount is "0" as string
        return balanceAmount!.trim() == '0' || balanceAmount!.trim().isEmpty;
      }
    }
    
    // If balanceAmount is not provided:
    // - If transactionId exists, assume payment was processed (likely fully paid)
    // - If no transactionId, assume not fully paid (active)
    if (transactionId.isNotEmpty) {
      return true; // Payment transaction exists, likely fully paid
    }
    
    // Default to active if no balance info and no transaction
    return false;
  }
  
  /// Get payment status: "won" if fully paid, "active" if not fully paid
  String get paymentStatus => isFullyPaid ? 'won' : 'active';
}

